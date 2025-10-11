package com.othman.clinique.repository.impl;

import com.othman.clinique.model.Salle;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.repository.Interfaces.ISalleRepository;
import com.othman.clinique.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

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
    public List<Salle> findSallesDisponibles(LocalDateTime dateHeure) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            LocalDate date = dateHeure.toLocalDate();

            // Trouver les salles qui n'ont PAS de consultation à ce créneau
            return em.createQuery(
                            "SELECT s FROM Salle s " +
                                    "WHERE s.id NOT IN (" +
                                    "  SELECT c.salle.id FROM Consultation c " +
                                    "  WHERE c.date = :date " +
                                    "  AND c.heure = :heure " +
                                    "  AND c.statut != :annulee" +
                                    ") " +
                                    "ORDER BY s.nomSalle",
                            Salle.class
                    )
                    .setParameter("date", date)
                    .setParameter("heure", dateHeure.toLocalTime())
                    .setParameter("annulee", StatutConsultation.ANNULEE)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
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
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Salle updated = em.merge(salle);
            em.getTransaction().commit();
            LOGGER.info("Salle mise à jour - ID: " + salle.getIdSalle());
            return updated;
        } catch (Exception e) {
            handleTransactionException(em, "Erreur mise à jour salle", e);
            throw new RuntimeException("Impossible de mettre à jour la salle", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Optional<Salle> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Salle salle = em.find(Salle.class, id);
            return Optional.ofNullable(salle);
        } finally {
            JPAUtil.close(em);
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