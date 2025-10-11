package com.othman.clinique.repository.impl;

import com.othman.clinique.model.Departement;
import com.othman.clinique.repository.Interfaces.IDepartementRepository;
import com.othman.clinique.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DepartementRepositoryImpl implements IDepartementRepository {
    private static final Logger LOGGER = Logger.getLogger(DepartementRepositoryImpl.class.getName());

    @Override
    public Optional<Departement> findByNom(String nom) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Departement> query = em.createQuery(
                    "SELECT d FROM Departement d WHERE d.nom = :nom",
                    Departement.class
            );
            query.setParameter("nom", nom);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public boolean existsByNom(String nom) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Long count = em.createQuery(
                            "SELECT COUNT(d) FROM Departement d WHERE d.nom = :nom",
                            Long.class
                    )
                    .setParameter("nom", nom)
                    .getSingleResult();
            return count > 0;
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Optional<Departement> findByIdWithDocteurs(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Departement> query = em.createQuery(
                    "SELECT DISTINCT d FROM Departement d " +
                            "LEFT JOIN FETCH d.docteurs " +
                            "WHERE d.id = :id",
                    Departement.class
            );
            query.setParameter("id", id);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Departement save(Departement departement) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(departement);
            em.getTransaction().commit();
            LOGGER.info("Département sauvegardé avec ID: " + departement.getIdDepartement());
            return departement;
        } catch (Exception e) {
            handleTransactionException(em, "Erreur sauvegarde département", e);
            throw new RuntimeException("Impossible de sauvegarder le département", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Departement update(Departement departement) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Departement updated = em.merge(departement);
            em.getTransaction().commit();
            LOGGER.info("Département mis à jour - ID: " + departement.getIdDepartement());
            return updated;
        } catch (Exception e) {
            handleTransactionException(em, "Erreur mise à jour département", e);
            throw new RuntimeException("Impossible de mettre à jour le département", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Optional<Departement> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Departement departement = em.find(Departement.class, id);
            return Optional.ofNullable(departement);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Departement> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT d FROM Departement d ORDER BY d.nom",
                    Departement.class
            ).getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public void delete(Departement departement) {
        if (departement != null && departement.getIdDepartement() != null) {
            deleteById(departement.getIdDepartement());
        }
    }

    @Override
    public void deleteById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Departement departement = em.find(Departement.class, id);
            if (departement != null) {
                em.remove(departement);
                LOGGER.info("Département supprimé - ID: " + id);
            } else {
                LOGGER.warning("Département non trouvé pour suppression - ID: " + id);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            handleTransactionException(em, "Erreur suppression département", e);
            throw new RuntimeException("Impossible de supprimer le département", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Long count() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(d) FROM Departement d", Long.class).getSingleResult();
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