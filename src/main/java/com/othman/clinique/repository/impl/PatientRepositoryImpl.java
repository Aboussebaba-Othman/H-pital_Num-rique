package com.othman.clinique.repository.impl;

import com.othman.clinique.model.Patient;
import com.othman.clinique.repository.Interfaces.IPatientRepository;
import com.othman.clinique.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PatientRepositoryImpl implements IPatientRepository {
    private static final Logger LOGGER = Logger.getLogger(PatientRepositoryImpl.class.getName());

    @Override
    public Optional<Patient> findByEmail(String email) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Patient patient = em.createQuery("SELECT p FROM Patient p WHERE p.email = :email", Patient.class)
                    .setParameter("email", email)
                    .getSingleResult();
            return Optional.ofNullable(patient);
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
            Long count = em.createQuery("SELECT COUNT(p) FROM Patient p WHERE p.email = :email", Long.class)
                    .setParameter("email", email)
                    .getSingleResult();
            return count != null && count > 0;
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Patient> search(String searchTerm) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                    "SELECT p FROM Patient p WHERE " +
                            "LOWER(p.nom) LIKE LOWER(:search) OR " +
                            "LOWER(p.prenom) LIKE LOWER(:search) OR " +
                            "LOWER(p.email) LIKE LOWER(:search)",
                    Patient.class
            );
            query.setParameter("search", "%" + searchTerm + "%");

            return query.getResultList();

        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Optional<Patient> findByIdWithConsultations(Long patientId) {
        EntityManager  em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                    "SELECT DISTINCT p FROM Patient p " +
                            "LEFT JOIN FETCH p.consultations " +
                            "WHERE p.id = :id",
                    Patient.class
            );
            query.setParameter("id", patientId);

            return Optional.ofNullable(query.getSingleResult());

        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Patient save(Patient patient) {
        EntityManager em = JPAUtil.getEntityManager();
        try{
            em.getTransaction().begin();
            em.persist(patient);
            em.getTransaction().commit();
            LOGGER.info("Patient saved with ID: " + patient.getId());
            return patient;
        } catch (Exception e) {
            handleTransactionException(em, "Error saving Patient", e);
            throw new RuntimeException();
            } finally {
            JPAUtil.close(em);
            }
    }

    @Override
    public Patient update(Patient patient) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Patient updated = em.merge(patient);
            em.getTransaction().commit();

            LOGGER.info("Patient mis à jour - ID: " + patient.getId());
            return updated;

        } catch (Exception e) {
            handleTransactionException(em, "Erreur lors de la mise à jour du patient", e);
            throw new RuntimeException("Impossible de mettre à jour le patient", e);

        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Optional<Patient> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Patient patient = em.find(Patient.class, id);
            return Optional.ofNullable(patient);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Patient> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Patient p", Patient.class).getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public void delete(Patient patient) {
        if (patient != null && patient.getId() != null) {
            deleteById(patient.getId());
        }
    }

    @Override
    public void deleteById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try{
            em.getTransaction().begin();
            Patient patient = em.find(Patient.class, id);
            if(patient != null){
                em.remove(patient);
                LOGGER.info("Patient deleted with ID: " + id);
            } else {
                LOGGER.warning("Patient not found for deletion with ID: " + id);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            handleTransactionException(em, "Error deleting Patient by ID", e);
            throw new RuntimeException("Impossible de supprimer le patient", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Long count() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(p) FROM Patient p", Long.class).getSingleResult();
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
