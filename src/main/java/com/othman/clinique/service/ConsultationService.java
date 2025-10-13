package com.othman.clinique.service;

import com.othman.clinique.exception.*;
import com.othman.clinique.model.*;
import com.othman.clinique.repository.Interfaces.*;
import com.othman.clinique.repository.impl.*;
import com.othman.clinique.util.DateUtil;
import com.othman.clinique.util.ValidationUtil;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ConsultationService {

    private static final Logger LOGGER = Logger.getLogger(ConsultationService.class.getName());

    private final IConsultationRepository consultationRepository;
    private final IPatientRepository patientRepository;
    private final IDocteurRepository docteurRepository;
    private final ISalleRepository salleRepository;

    public ConsultationService() {
        this.consultationRepository = new ConsultationRepositoryImpl();
        this.patientRepository = new PatientRepositoryImpl();
        this.docteurRepository = new DocteurRepository();
        this.salleRepository = new SalleRepositoryImpl();
    }

    public Consultation reserverConsultation(Long patientId, Long docteurId,
                                             LocalDate date, LocalTime heure,
                                             String motif) {
        try {
            // 1. Validation des données d'entrée
            validateReservationInput(patientId, docteurId, date, heure, motif);

            // 2. Vérifier existence patient et docteur
            Patient patient = patientRepository.findById(patientId)
                    .orElseThrow(() -> new EntityNotFoundException("Patient", patientId));

            Docteur docteur = docteurRepository.findById(docteurId)
                    .orElseThrow(() -> new EntityNotFoundException("Docteur", docteurId));

            // 3. Valider la date et l'heure selon les règles métier
            validateDateTimeConsultation(date, heure);

            // 4. Vérifier que le patient n'a pas déjà une réservation à ce créneau
            LocalDateTime dateTime = LocalDateTime.of(date, heure);
            if (patientHasReservationAtCreneau(patientId, date, heure)) {
                throw new CreneauOccupeException(
                        "Vous avez déjà une réservation à cette date et heure");
            }

            // 5. Trouver une salle disponible pour ce créneau
            Salle salleDisponible = findSalleDisponible(dateTime);

            // 6. Créer la consultation
            Consultation consultation = new Consultation();
            consultation.setDate(date);
            consultation.setHeure(heure);
            consultation.setMotifConsultation(ValidationUtil.sanitize(motif));
            consultation.setStatut(StatutConsultation.RESERVEE);
            consultation.setPatient(patient);
            consultation.setDocteur(docteur);
            consultation.setSalle(salleDisponible);

            // 7. Sauvegarder
            Consultation saved = consultationRepository.save(consultation);

            salleDisponible.reserverCreneau(dateTime);
            salleRepository.update(salleDisponible);

            LOGGER.info("Consultation réservée - ID: " + saved.getIdConsultation() +
                    ", Patient: " + patientId + ", Docteur: " + docteurId);

            return saved;

        } catch (ValidationException | EntityNotFoundException |
                 CreneauOccupeException | SalleNonDisponibleException e) {
            LOGGER.warning("Échec réservation: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la réservation", e);
            throw new RuntimeException("Erreur système lors de la réservation", e);
        }
    }

    private Salle findSalleDisponible(LocalDateTime dateTime) {
        List<Salle> sallesDisponibles = salleRepository.findSallesDisponibles(dateTime);

        if (sallesDisponibles.isEmpty()) {
            throw new SalleNonDisponibleException(
                    "Aucune salle disponible pour ce créneau. " +
                            "Veuillez choisir une autre date ou heure.");
        }

        return sallesDisponibles.get(0);
    }

    private boolean patientHasReservationAtCreneau(Long patientId, LocalDate date, LocalTime heure) {
        List<Consultation> consultations = consultationRepository.findByPatientId(patientId);

        return consultations.stream()
                .anyMatch(c -> c.getDate().equals(date) &&
                        c.getHeure().equals(heure) &&
                        (c.getStatut() == StatutConsultation.RESERVEE ||
                                c.getStatut() == StatutConsultation.VALIDEE));
    }

    // ==================== VALIDATION DOCTEUR ====================

    public Consultation validerConsultation(Long consultationId, Long docteurId) {
        try {
            Consultation consultation = getConsultationById(consultationId);

            if (!consultation.getDocteur().getIdDocteur().equals(docteurId)) {
                throw new ValidationException(
                        "Seul le docteur assigné peut valider cette consultation");
            }

            if (consultation.getStatut() != StatutConsultation.RESERVEE) {
                throw new ValidationException(
                        "Seules les consultations réservées peuvent être validées");
            }

            consultation.setStatut(StatutConsultation.VALIDEE);
            Consultation updated = consultationRepository.update(consultation);

            LOGGER.info("Consultation validée - ID: " + consultationId +
                    ", Docteur: " + docteurId);

            return updated;

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.warning("Échec validation: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la validation", e);
            throw new RuntimeException("Erreur système lors de la validation", e);
        }
    }
    public Consultation refuserConsultation(Long consultationId, Long docteurId, String motifRefus) {
        try {
            Consultation consultation = getConsultationById(consultationId);

            if (!consultation.getDocteur().getIdDocteur().equals(docteurId)) {
                throw new ValidationException(
                        "Seul le docteur assigné peut refuser cette consultation");
            }

            if (consultation.getStatut() != StatutConsultation.RESERVEE) {
                throw new ValidationException(
                        "Seules les consultations réservées peuvent être refusées");
            }

            consultation.setStatut(StatutConsultation.ANNULEE);
            consultation.setCompteRendu("REFUSÉE - Motif: " +
                    (ValidationUtil.isNullOrEmpty(motifRefus) ? "Non spécifié" : motifRefus));

            Consultation updated = consultationRepository.update(consultation);

            LocalDateTime dateTime = consultation.getDateTimeDebut();
            Salle salle = consultation.getSalle();
            salle.libererCreneau(dateTime);
            salleRepository.update(salle);

            LOGGER.info("Consultation refusée - ID: " + consultationId);

            return updated;

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.warning("Échec refus: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du refus", e);
            throw new RuntimeException("Erreur système lors du refus", e);
        }
    }
    public Consultation annulerConsultation(Long consultationId, Long userId, Role userRole) {
        try {
            Consultation consultation = getConsultationById(consultationId);

            // Vérifier le statut
            if (consultation.getStatut() == StatutConsultation.TERMINEE) {
                throw new ValidationException(
                        "Une consultation terminée ne peut pas être annulée");
            }

            if (consultation.getStatut() == StatutConsultation.ANNULEE) {
                throw new ValidationException("Cette consultation est déjà annulée");
            }

            // Vérifier les droits selon le rôle
            if (userRole == Role.PATIENT) {
                // Patient ne peut annuler que ses propres consultations
                if (!consultation.getPatient().getIdPatient().equals(userId)) {
                    throw new ValidationException(
                            "Vous ne pouvez annuler que vos propres consultations");
                }

                // Vérifier délai 24h
                LocalDateTime now = LocalDateTime.now();
                LocalDateTime consultationDateTime = consultation.getDateTimeDebut();

                if (consultationDateTime.minusHours(24).isBefore(now)) {
                    throw new ValidationException(
                            "Vous devez annuler au moins 24 heures avant la consultation");
                }
            }

            // Annuler
            consultation.setStatut(StatutConsultation.ANNULEE);
            Consultation updated = consultationRepository.update(consultation);

            // Libérer le créneau dans la salle
            LocalDateTime dateTime = consultation.getDateTimeDebut();
            Salle salle = consultation.getSalle();
            salle.libererCreneau(dateTime);
            salleRepository.update(salle);

            LOGGER.info("Consultation annulée - ID: " + consultationId +
                    ", Par: " + userRole);

            return updated;

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.warning("Échec annulation: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de l'annulation", e);
            throw new RuntimeException("Erreur système lors de l'annulation", e);
        }
    }
    public Consultation terminerConsultation(Long consultationId, Long docteurId, String compteRendu) {
        try {
            Consultation consultation = getConsultationById(consultationId);

            // Vérifier que c'est le bon docteur
            if (!consultation.getDocteur().getIdDocteur().equals(docteurId)) {
                throw new ValidationException(
                        "Seul le docteur assigné peut terminer cette consultation");
            }

            // Vérifier le statut
            if (consultation.getStatut() != StatutConsultation.VALIDEE) {
                throw new ValidationException(
                        "Seules les consultations validées peuvent être terminées");
            }

            // Valider le compte rendu
            String error = ValidationUtil.validateCompteRendu(compteRendu);
            if (error != null) {
                throw new ValidationException(error);
            }

            consultation.setStatut(StatutConsultation.TERMINEE);
            consultation.setCompteRendu(ValidationUtil.sanitize(compteRendu));

            Consultation updated = consultationRepository.update(consultation);

            LOGGER.info("Consultation terminée - ID: " + consultationId);

            return updated;

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.warning("Échec terminaison: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la terminaison", e);
            throw new RuntimeException("Erreur système lors de la terminaison", e);
        }
    }

    // ==================== CONSULTATION ====================

    public Consultation getConsultationById(Long consultationId) {
        if (consultationId == null || consultationId <= 0) {
            throw new ValidationException("ID consultation invalide");
        }

        return consultationRepository.findById(consultationId)
                .orElseThrow(() -> new EntityNotFoundException("Consultation", consultationId));
    }


    public List<Consultation> getHistoriquePatient(Long patientId) {
        if (patientId == null || patientId <= 0) {
            throw new ValidationException("ID patient invalide");
        }

        try {
            List<Consultation> historique = consultationRepository.findHistoriquePatient(patientId);
            LOGGER.info("Historique patient " + patientId + ": " + historique.size() + " consultations");
            return historique;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur récupération historique", e);
            throw new RuntimeException("Erreur système lors de la récupération", e);
        }
    }

    public List<Consultation> getPlanningDocteur(Long docteurId) {
        if (docteurId == null || docteurId <= 0) {
            throw new ValidationException("ID docteur invalide");
        }

        try {
            List<Consultation> planning = consultationRepository.findPlanningDocteur(docteurId);
            LOGGER.info("Planning docteur " + docteurId + ": " + planning.size() + " consultations");
            return planning;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur récupération planning", e);
            throw new RuntimeException("Erreur système lors de la récupération", e);
        }
    }

    public List<Consultation> getConsultationsByPatient(Long patientId) {
        if (patientId == null || patientId <= 0) {
            throw new ValidationException("ID patient invalide");
        }

        return consultationRepository.findByPatientId(patientId);
    }


    public List<Consultation> getConsultationsByStatut(StatutConsultation statut) {
        if (statut == null) {
            throw new ValidationException("Le statut est requis");
        }

        return consultationRepository.findByStatut(statut);
    }

    public List<Consultation> getConsultationsByDate(LocalDate date) {
        if (date == null) {
            throw new ValidationException("La date est requise");
        }
        return consultationRepository.findByDate(date);
    }

    public List<Consultation> getAllConsultations() {
        try {
            return consultationRepository.findAll();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur récupération consultations", e);
            throw new RuntimeException("Erreur système lors de la récupération", e);
        }
    }

    // ==================== VALIDATION PRIVÉE ====================

    private void validateReservationInput(Long patientId, Long docteurId,
                                          LocalDate date, LocalTime heure, String motif) {
        if (patientId == null || patientId <= 0) {
            throw new ValidationException("ID patient invalide");
        }

        if (docteurId == null || docteurId <= 0) {
            throw new ValidationException("ID docteur invalide");
        }

        if (date == null) {
            throw new ValidationException("La date est requise");
        }

        if (heure == null) {
            throw new ValidationException("L'heure est requise");
        }

        String error = ValidationUtil.validateMotifConsultation(motif);
        if (error != null) {
            throw new ValidationException(error);
        }
    }

    private void validateDateTimeConsultation(LocalDate date, LocalTime heure) {
        String dateError = DateUtil.validateDateConsultation(date);
        if (dateError != null) {
            throw new ValidationException(dateError);
        }

        String heureError = DateUtil.validateHeureConsultation(heure);
        if (heureError != null) {
            throw new ValidationException(heureError);
        }
    }
}