package com.othman.clinique.repository.impl;

import com.othman.clinique.model.Salle;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.repository.Interfaces.ISalleRepository;
import com.othman.clinique.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class SalleRepositoryImpl implements ISalleRepository {
    private static final Logger LOGGER = Logger.getLogger(SalleRepositoryImpl.class.getName());

    @Override
    public Optional<Salle> findByNomSalle(String nomSalle) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Salle> query = em.createQuery(
                    "SELECT s FROM Salle s WHERE s.nomSalle = :nomSalle",
                    Salle.class
            );
            query.setParameter("nomSalle", nomSalle);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public boolean existsByNomSalle(String nomSalle) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Long count = em.createQuery(
                            "SELECT COUNT(s) FROM Salle s WHERE s.nomSalle = :nomSalle",
                            Long.class
                    )
                    .setParameter("nomSalle", nomSalle)
                    .getSingleResult();
            return count > 0;
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Salle> findSallesDisponibles(LocalDateTime dateTime) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // Charger toutes les salles avec leurs créneaux
            String jpql = "SELECT DISTINCT s FROM Salle s " +
                    "LEFT JOIN FETCH s.creneauxOccupes";

            List<Salle> salles = em.createQuery(jpql, Salle.class)
                    .getResultList();

            // Filtrer celles qui sont disponibles pour ce créneau
            List<Salle> sallesDisponibles = salles.stream()
                    .filter(s -> {
                        // Initialiser la liste si elle est null
                        if (s.getCreneauxOccupes() == null) {
                            s.setCreneauxOccupes(new ArrayList<>());
                        }
                        // Vérifier la disponibilité
                        return s.isDisponible(dateTime);
                    })
                    .collect(Collectors.toList());

            LOGGER.info("Salles disponibles pour " + dateTime + ": " +
                    sallesDisponibles.size() + "/" + salles.size());

            return sallesDisponibles;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la recherche des salles disponibles", e);
            throw new RuntimeException("Erreur lors de la recherche des salles disponibles", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Salle> findByIdWithConsultations(Long salleId, LocalDate date) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Salle> query = em.createQuery(
                    "SELECT DISTINCT s FROM Salle s " +
                            "LEFT JOIN FETCH s.consultations c " +
                            "WHERE s.id = :salleId " +
                            "AND (c.date = :date OR c IS NULL)",
                    Salle.class
            );
            query.setParameter("salleId", salleId);
            query.setParameter("date", date);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Salle> findByCapaciteGreaterThanEqual(Integer capacite) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT s FROM Salle s " +
                                    "WHERE s.capacite >= :capacite " +
                                    "ORDER BY s.capacite, s.nomSalle",
                            Salle.class
                    )
                    .setParameter("capacite", capacite)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Salle save(Salle salle) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(salle);
            em.getTransaction().commit();
            LOGGER.info("Salle sauvegardée avec ID: " + salle.getIdSalle());
            return salle;
        } catch (Exception e) {
            handleTransactionException(em, "Erreur sauvegarde salle", e);
            throw new RuntimeException("Impossible de sauvegarder la salle", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Salle update(Salle salle) {
        EntityManager em = null;
        EntityTransaction transaction = null;

        try {
            em = JPAUtil.getEntityManagerFactory().createEntityManager();
            transaction = em.getTransaction();
            transaction.begin();

            // IMPORTANT: Merger la salle et ses collections
            Salle merged = em.merge(salle);

            // Forcer la synchronisation avec la base de données
            em.flush();

            transaction.commit();

            LOGGER.info("Salle mise à jour - ID: " + salle.getIdSalle() +
                    ", Créneaux occupés: " +
                    (salle.getCreneauxOccupes() != null ? salle.getCreneauxOccupes().size() : 0));

            return merged;

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            LOGGER.log(Level.SEVERE, "Erreur lors de la mise à jour de la salle", e);
            throw new RuntimeException("Erreur lors de la mise à jour de la salle", e);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }


    @Override
    public Optional<Salle> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // Charger la salle avec ses créneaux (EAGER)
            String jpql = "SELECT s FROM Salle s " +
                    "LEFT JOIN FETCH s.creneauxOccupes " +
                    "WHERE s.idSalle = :id";

            List<Salle> results = em.createQuery(jpql, Salle.class)
                    .setParameter("id", id)
                    .getResultList();

            if (results.isEmpty()) {
                return Optional.empty();
            }

            Salle salle = results.get(0);

            // Initialiser la liste si elle est null
            if (salle.getCreneauxOccupes() == null) {
                salle.setCreneauxOccupes(new ArrayList<>());
            }

            LOGGER.info("Salle chargée: " + salle.getNomSalle() +
                    ", créneaux: " + salle.getCreneauxOccupes().size());

            return Optional.of(salle);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement de la salle " + id, e);
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Salle> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT s FROM Salle s ORDER BY s.nomSalle",
                    Salle.class
            ).getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public void delete(Salle salle) {
        if (salle != null && salle.getIdSalle() != null) {
            deleteById(salle.getIdSalle());
        }
    }

    @Override
    public void deleteById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Salle salle = em.find(Salle.class, id);
            if (salle != null) {
                em.remove(salle);
                LOGGER.info("Salle supprimée - ID: " + id);
            } else {
                LOGGER.warning("Salle non trouvée pour suppression - ID: " + id);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            handleTransactionException(em, "Erreur suppression salle", e);
            throw new RuntimeException("Impossible de supprimer la salle", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Long count() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(s) FROM Salle s",
                    Long.class
            ).getSingleResult();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public boolean existsById(Long id) {
        return findById(id).isPresent();
    }

    private void handleTransactionException(EntityManager em, String message, Exception e) {
        if (em.getTransaction().isActive()) {
            em.getTransaction().rollback();
            LOGGER.warning("Transaction annulée (rollback)");
        }
        LOGGER.log(Level.SEVERE, message, e);
    }
}