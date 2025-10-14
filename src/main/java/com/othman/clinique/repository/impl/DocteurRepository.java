package com.othman.clinique.repository.impl;

import com.othman.clinique.model.Docteur;
import com.othman.clinique.repository.Interfaces.IDocteurRepository;
import com.othman.clinique.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DocteurRepository implements IDocteurRepository {
    private static final Logger LOGGER = Logger.getLogger(DocteurRepository.class.getName());

    @Override
    public Optional<Docteur> findByEmail(String email) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT d FROM Docteur d WHERE d.email = :email",
                    Docteur.class
            );
            query.setParameter("email", email);

            return Optional.ofNullable(query.getSingleResult());

        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public boolean existsByEmail(String email) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            Long count = em.createQuery(
                            "SELECT COUNT(d) FROM Docteur d WHERE d.email = :email",
                            Long.class
                    )
                    .setParameter("email", email)
                    .getSingleResult();

            return count > 0;
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Docteur> findByDepartementId(Long departementId) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            return em.createQuery(
                            "SELECT d FROM Docteur d WHERE d.departement.id = :depId ORDER BY d.nom",
                            Docteur.class
                    )
                    .setParameter("depId", departementId)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Docteur> findBySpecialite(String specialite) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            return em.createQuery(
                            "SELECT d FROM Docteur d WHERE d.specialite = :spec ORDER BY d.nom",
                            Docteur.class
                    )
                    .setParameter("spec", specialite)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Optional<Docteur> findByIdWithPlanning(Long docteurId) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT DISTINCT d FROM Docteur d " +
                            "LEFT JOIN FETCH d.planning " +
                            "WHERE d.id = :id",
                    Docteur.class
            );
            query.setParameter("id", docteurId);

            return Optional.ofNullable(query.getSingleResult());

        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Docteur> search(String searchTerm) {
        EntityManager em = JPAUtil.getEntityManager();
        String jpql = "SELECT d FROM Docteur d WHERE " +
                "LOWER(d.nom) LIKE LOWER(:search) OR " +
                "LOWER(d.prenom) LIKE LOWER(:search) OR " +
                "LOWER(d.email) LIKE LOWER(:search)";

        TypedQuery<Docteur> query = em.createQuery(jpql, Docteur.class);
        query.setParameter("search", "%" + searchTerm + "%");
        return query.getResultList();
    }


    @Override
    public Docteur save(Docteur docteur) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(docteur);
            em.getTransaction().commit();
            LOGGER.info("Docteur saved with ID: " + docteur.getIdDocteur());
            return docteur;
        } catch (Exception e) {
            handleTransactionException(em, "Error saving docteur", e);
            throw new RuntimeException();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Docteur update(Docteur docteur) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Docteur updated = em.merge(docteur);
            em.getTransaction().commit();
            LOGGER.info("docteur mis à jour - ID: " + docteur.getIdDocteur());
            return updated;
        } catch (Exception e) {
            handleTransactionException(em, "Error lors de la mise à jour", e);
            throw new RuntimeException("Impossible de mettre à jour", e);
        } finally {
            JPAUtil.close(em);
        }
    }


    @Override
    public Optional<Docteur> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Docteur docteur = em.find(Docteur.class, id);
            return Optional.ofNullable(docteur);
        }finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Docteur> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT d FROM Docteur d ORDER BY d.nom, d.prenom",
                    Docteur.class
            ).getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public void delete(Docteur docteur) {
        if (docteur != null && docteur.getId() != null) {
            deleteById(docteur.getId());
        }
    }

    @Override
    public void deleteById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            em.getTransaction().begin();

            Docteur docteur = em.find(Docteur.class, id);
            if (docteur != null) {
                em.remove(docteur);
                LOGGER.info("Docteur supprimé - ID: " + id);
            }

            em.getTransaction().commit();

        } catch (Exception e) {
            handleTransactionException(em, "Erreur suppression docteur", e);
            throw new RuntimeException("Impossible de supprimer le docteur", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Long count() {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            return em.createQuery("SELECT COUNT(d) FROM Docteur d", Long.class)
                    .getSingleResult();
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
        }
        LOGGER.log(Level.SEVERE, message, e);
    }
}
