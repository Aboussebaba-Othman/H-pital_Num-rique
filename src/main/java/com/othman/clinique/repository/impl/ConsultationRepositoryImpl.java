package com.othman.clinique.repository.impl;

import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.repository.Interfaces.IConsultationRepository;
import com.othman.clinique.util.JPAUtil;
import jakarta.persistence.EntityManager;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ConsultationRepositoryImpl implements IConsultationRepository {
    private static final Logger LOGGER = Logger.getLogger(ConsultationRepositoryImpl.class.getName());

    @Override
    public List<Consultation> findByPatientId(Long patientId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // EAGER FETCH pour charger toutes les relations
            return em.createQuery(
                            "SELECT DISTINCT c FROM Consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH c.docteur d " +
                                    "LEFT JOIN FETCH d.departement " +
                                    "LEFT JOIN FETCH c.salle " +
                                    "WHERE c.patient.id = :patientId " +
                                    "ORDER BY c.date DESC, c.heure DESC",
                            Consultation.class
                    )
                    .setParameter("patientId", patientId)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Consultation> findByDocteurId(Long docteurId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // EAGER FETCH
            return em.createQuery(
                            "SELECT DISTINCT c FROM Consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH c.docteur " +
                                    "LEFT JOIN FETCH c.salle " +
                                    "WHERE c.docteur.id = :docteurId " +
                                    "ORDER BY c.date, c.heure",
                            Consultation.class
                    )
                    .setParameter("docteurId", docteurId)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Consultation> findBySalleId(Long salleId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT c FROM Consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH c.docteur " +
                                    "LEFT JOIN FETCH c.salle " +
                                    "WHERE c.salle.id = :salleId " +
                                    "ORDER BY c.date, c.heure",
                            Consultation.class
                    )
                    .setParameter("salleId", salleId)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Consultation> findByStatut(StatutConsultation statut) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT c FROM Consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH c.docteur " +
                                    "LEFT JOIN FETCH c.salle " +
                                    "WHERE c.statut = :statut " +
                                    "ORDER BY c.date, c.heure",
                            Consultation.class
                    )
                    .setParameter("statut", statut)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Consultation> findByDate(LocalDate date) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT c FROM Consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH c.docteur " +
                                    "LEFT JOIN FETCH c.salle " +
                                    "WHERE c.date = :date " +
                                    "ORDER BY c.heure",
                            Consultation.class
                    )
                    .setParameter("date", date)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Consultation> findByDateBetween(LocalDate debut, LocalDate fin) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT c FROM Consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH c.docteur " +
                                    "LEFT JOIN FETCH c.salle " +
                                    "WHERE c.date BETWEEN :debut AND :fin " +
                                    "ORDER BY c.date, c.heure",
                            Consultation.class
                    )
                    .setParameter("debut", debut)
                    .setParameter("fin", fin)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public boolean isCreneauDisponible(Long salleId, LocalDateTime dateHeure) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            LocalDate date = dateHeure.toLocalDate();
            LocalDateTime heureDebut = dateHeure;
            LocalDateTime heureFin = dateHeure.plusMinutes(30);

            Long count = em.createQuery(
                            "SELECT COUNT(c) FROM Consultation c " +
                                    "WHERE c.salle.id = :salleId " +
                                    "AND c.date = :date " +
                                    "AND c.statut != :annulee " +
                                    "AND (c.heure >= :heureDebut AND c.heure < :heureFin)",
                            Long.class
                    )
                    .setParameter("salleId", salleId)
                    .setParameter("date", date)
                    .setParameter("annulee", StatutConsultation.ANNULEE)
                    .setParameter("heureDebut", heureDebut.toLocalTime())
                    .setParameter("heureFin", heureFin.toLocalTime())
                    .getSingleResult();

            return count == 0;
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Consultation> findByDocteurAndDate(Long docteurId, LocalDate date) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT c FROM Consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH c.docteur " +
                                    "LEFT JOIN FETCH c.salle " +
                                    "WHERE c.docteur.id = :docteurId " +
                                    "AND c.date = :date " +
                                    "ORDER BY c.heure",
                            Consultation.class
                    )
                    .setParameter("docteurId", docteurId)
                    .setParameter("date", date)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Consultation> findBySalleAndDate(Long salleId, LocalDate date) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT c FROM Consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH c.docteur " +
                                    "LEFT JOIN FETCH c.salle " +
                                    "WHERE c.salle.id = :salleId " +
                                    "AND c.date = :date " +
                                    "ORDER BY c.heure",
                            Consultation.class
                    )
                    .setParameter("salleId", salleId)
                    .setParameter("date", date)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Consultation> findHistoriquePatient(Long patientId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT c FROM Consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH c.docteur d " +
                                    "LEFT JOIN FETCH d.departement " +
                                    "LEFT JOIN FETCH c.salle " +
                                    "WHERE c.patient.id = :patientId " +
                                    "AND c.statut = :terminee " +
                                    "ORDER BY c.date DESC, c.heure DESC",
                            Consultation.class
                    )
                    .setParameter("patientId", patientId)
                    .setParameter("terminee", StatutConsultation.TERMINEE)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Consultation> findPlanningDocteur(Long docteurId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT DISTINCT c FROM Consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH c.docteur " +
                                    "LEFT JOIN FETCH c.salle " +
                                    "WHERE c.docteur.id = :docteurId " +
                                    "AND c.date >= :today " +
                                    "AND c.statut IN (:reservee, :validee) " +
                                    "ORDER BY c.date, c.heure",
                            Consultation.class
                    )
                    .setParameter("docteurId", docteurId)
                    .setParameter("today", LocalDate.now())
                    .setParameter("reservee", StatutConsultation.RESERVEE)
                    .setParameter("validee", StatutConsultation.VALIDEE)
                    .getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Consultation save(Consultation consultation) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(consultation);
            em.getTransaction().commit();
            LOGGER.info("Consultation sauvegardée avec ID: " + consultation.getIdConsultation());
            return consultation;
        } catch (Exception e) {
            handleTransactionException(em, "Erreur sauvegarde consultation", e);
            throw new RuntimeException("Impossible de sauvegarder la consultation", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Consultation update(Consultation consultation) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Consultation updated = em.merge(consultation);
            em.getTransaction().commit();
            LOGGER.info("Consultation mise à jour - ID: " + consultation.getIdConsultation());
            return updated;
        } catch (Exception e) {
            handleTransactionException(em, "Erreur mise à jour consultation", e);
            throw new RuntimeException("Impossible de mettre à jour la consultation", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Optional<Consultation> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // EAGER FETCH pour charger toutes les relations
            List<Consultation> results = em.createQuery(
                            "SELECT DISTINCT c FROM Consultation c " +
                                    "LEFT JOIN FETCH c.patient " +
                                    "LEFT JOIN FETCH c.docteur d " +
                                    "LEFT JOIN FETCH d.departement " +
                                    "LEFT JOIN FETCH c.salle " +
                                    "WHERE c.idConsultation = :id",
                            Consultation.class
                    )
                    .setParameter("id", id)
                    .getResultList();

            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public List<Consultation> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT DISTINCT c FROM Consultation c " +
                            "LEFT JOIN FETCH c.patient " +
                            "LEFT JOIN FETCH c.docteur " +
                            "LEFT JOIN FETCH c.salle " +
                            "ORDER BY c.date DESC, c.heure DESC",
                    Consultation.class
            ).getResultList();
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public void delete(Consultation consultation) {
        if (consultation != null && consultation.getIdConsultation() != null) {
            deleteById(consultation.getIdConsultation());
        }
    }

    @Override
    public void deleteById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Consultation consultation = em.find(Consultation.class, id);
            if (consultation != null) {
                em.remove(consultation);
                LOGGER.info("Consultation supprimée - ID: " + id);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            handleTransactionException(em, "Erreur suppression consultation", e);
            throw new RuntimeException("Impossible de supprimer la consultation", e);
        } finally {
            JPAUtil.close(em);
        }
    }

    @Override
    public Long count() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(c) FROM Consultation c",
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