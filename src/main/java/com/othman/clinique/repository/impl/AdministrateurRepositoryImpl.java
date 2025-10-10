package com.othman.clinique.repository.impl;

import com.othman.clinique.model.Administrateur;
import com.othman.clinique.repository.Interfaces.IAdministrateurRepository;
import com.othman.clinique.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import java.util.List;
import java.util.Optional;

public class AdministrateurRepositoryImpl implements IAdministrateurRepository {

    @Override
    public Optional<Administrateur> findByEmail(String email) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return Optional.ofNullable(
                    em.createQuery("SELECT a FROM Administrateur a WHERE a.email = :email", Administrateur.class)
                            .setParameter("email", email)
                            .getSingleResult()
            );
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
            Long count = em.createQuery("SELECT COUNT(a) FROM Administrateur a WHERE a.email = :email", Long.class)
                    .setParameter("email", email)
                    .getSingleResult();
            return count > 0;
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Administrateur save(Administrateur admin) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(admin);
            em.getTransaction().commit();
            return admin;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("Erreur sauvegarde admin", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Administrateur update(Administrateur admin) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Administrateur updated = em.merge(admin);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("Erreur mise à jour admin", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Optional<Administrateur> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return Optional.ofNullable(em.find(Administrateur.class, id));
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Administrateur> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT a FROM Administrateur a", Administrateur.class)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public void delete(Administrateur admin) {
        if (admin != null && admin.getId() != null) deleteById(admin.getId());
    }

    @Override
    public void deleteById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Administrateur admin = em.find(Administrateur.class, id);
            if (admin != null) em.remove(admin);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("Erreur suppression admin", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Long count() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(a) FROM Administrateur a", Long.class)
                    .getSingleResult();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public boolean existsById(Long id) {
        return findById(id).isPresent();
    }

}
