package com.othman.clinique.repository.Interfaces;

import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.StatutConsultation;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public interface IConsultationRepository extends IGenericRepository<Consultation> {

        // Recherche par patient
        List<Consultation> findByPatientId(Long patientId);

        // Recherche par docteur
        List<Consultation> findByDocteurId(Long docteurId);

        // Recherche par salle
        List<Consultation> findBySalleId(Long salleId);

        // Recherche par statut
        List<Consultation> findByStatut(StatutConsultation statut);

        // Recherche par date
        List<Consultation> findByDate(LocalDate date);

        // Recherche par plage de dates
        List<Consultation> findByDateBetween(LocalDate debut, LocalDate fin);

        // Vérifier disponibilité créneau
        boolean isCreneauDisponible(Long salleId, LocalDateTime dateHeure);

        // Trouver consultations d'un docteur pour une date
        List<Consultation> findByDocteurAndDate(Long docteurId, LocalDate date);

        // Trouver consultations d'une salle pour une date
        List<Consultation> findBySalleAndDate(Long salleId, LocalDate date);

        // Historique patient avec détails
        List<Consultation> findHistoriquePatient(Long patientId);

        // Planning docteur (consultations futures)
        List<Consultation> findPlanningDocteur(Long docteurId);
}
