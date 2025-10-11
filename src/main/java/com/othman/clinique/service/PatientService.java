package com.othman.clinique.service;

import com.othman.clinique.exception.EmailAlreadyExistsException;
import com.othman.clinique.exception.EntityNotFoundException;
import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.Patient;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.repository.Interfaces.IPatientRepository;
import com.othman.clinique.repository.impl.PatientRepositoryImpl;
import com.othman.clinique.util.ValidationUtil;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


public class PatientService {

    private static final Logger LOGGER = Logger.getLogger(PatientService.class.getName());

    private final IPatientRepository patientRepository;

    public PatientService() {
        this.patientRepository = new PatientRepositoryImpl();
    }

    // ==================== CONSULTATION ====================

    public Patient getPatientById(Long patientId) {
        if (patientId == null || patientId <= 0) {
            throw new ValidationException("ID patient invalide");
        }

        return patientRepository.findById(patientId)
                .orElseThrow(() -> new EntityNotFoundException("Patient", patientId));
    }

    public Patient getPatientByEmail(String email) {
        String error = ValidationUtil.validateEmail(email);
        if (error != null) {
            throw new ValidationException(error);
        }

        return patientRepository.findByEmail(email)
                .orElseThrow(() -> new EntityNotFoundException("Patient introuvable avec l'email: " + email));
    }


    public Patient getPatientWithConsultations(Long patientId) {
        if (patientId == null || patientId <= 0) {
            throw new ValidationException("ID patient invalide");
        }

        return patientRepository.findByIdWithConsultations(patientId)
                .orElseThrow(() -> new EntityNotFoundException("Patient", patientId));
    }

    public List<Patient> getAllPatients() {
        try {
            List<Patient> patients = patientRepository.findAll();
            LOGGER.info("Récupération de " + patients.size() + " patients");
            return patients;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération des patients", e);
            throw new RuntimeException("Erreur système lors de la récupération des patients", e);
        }
    }
    public List<Patient> searchPatients(String searchTerm) {
        if (ValidationUtil.isNullOrEmpty(searchTerm)) {
            return getAllPatients();
        }

        try {
            String sanitized = ValidationUtil.sanitize(searchTerm);
            List<Patient> patients = patientRepository.search(sanitized);
            LOGGER.info("Recherche patients '" + sanitized + "' - " + patients.size() + " résultats");
            return patients;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la recherche de patients", e);
            throw new RuntimeException("Erreur système lors de la recherche", e);
        }
    }

    // ==================== MODIFICATION ====================

    public Patient updatePatient(Long patientId, String nom, String prenom,
                                 String email, Double poids, Double taille) {
        try {
            // Récupérer le patient existant
            Patient patient = getPatientById(patientId);

            // Validation des nouvelles données
            validatePatientData(nom, prenom, email, poids, taille);

            // Vérifier unicité email si changement
            if (!patient.getEmail().equalsIgnoreCase(email)) {
                if (patientRepository.existsByEmail(email)) {
                    throw new EmailAlreadyExistsException(email);
                }
            }

            // Mise à jour des champs
            patient.setNom(ValidationUtil.sanitize(nom));
            patient.setPrenom(ValidationUtil.sanitize(prenom));
            patient.setEmail(email.toLowerCase().trim());
            patient.setPoids(poids);
            patient.setTaille(taille);

            // Sauvegarder
            Patient updated = patientRepository.update(patient);
            LOGGER.info("Patient mis à jour - ID: " + patientId);

            return updated;

        } catch (ValidationException | EntityNotFoundException | EmailAlreadyExistsException e) {
            LOGGER.warning("Échec mise à jour patient: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la mise à jour du patient", e);
            throw new RuntimeException("Erreur système lors de la mise à jour", e);
        }
    }

    public Patient updatePatientMesures(Long patientId, Double poids, Double taille) {
        try {
            Patient patient = getPatientById(patientId);

            // Validation
            String error;
            if ((error = ValidationUtil.validatePoids(poids)) != null) {
                throw new ValidationException(error);
            }
            if ((error = ValidationUtil.validateTaille(taille)) != null) {
                throw new ValidationException(error);
            }

            // Mise à jour
            patient.setPoids(poids);
            patient.setTaille(taille);

            Patient updated = patientRepository.update(patient);
            LOGGER.info("Mesures patient mises à jour - ID: " + patientId);

            return updated;

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.warning("Échec mise à jour mesures: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la mise à jour des mesures", e);
            throw new RuntimeException("Erreur système lors de la mise à jour", e);
        }
    }

    // ==================== SUPPRESSION ====================

    public void deletePatient(Long patientId) {
        try {
            Patient patient = getPatientWithConsultations(patientId);

            // Vérifier consultations futures
            boolean hasConsultationsFutures = patient.getConsultations().stream()
                    .anyMatch(c -> c.getDateTimeDebut().isAfter(java.time.LocalDateTime.now()) &&
                            !c.getStatut().equals(StatutConsultation.ANNULEE));

            if (hasConsultationsFutures) {
                throw new ValidationException(
                        "Impossible de supprimer ce patient: il a des consultations futures. " +
                                "Veuillez d'abord annuler ses consultations."
                );
            }

            patientRepository.deleteById(patientId);
            LOGGER.info("Patient supprimé - ID: " + patientId);

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.warning("Échec suppression patient: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la suppression du patient", e);
            throw new RuntimeException("Erreur système lors de la suppression", e);
        }
    }

    // ==================== STATISTIQUES ====================

    public Long countPatients() {
        try {
            return patientRepository.count();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du comptage des patients", e);
            return 0L;
        }
    }


    public boolean patientExists(Long patientId) {
        if (patientId == null || patientId <= 0) {
            return false;
        }
        return patientRepository.existsById(patientId);
    }

    // ==================== VALIDATION PRIVÉE ====================

    private void validatePatientData(String nom, String prenom, String email,
                                     Double poids, Double taille) {
        String error;

        if ((error = ValidationUtil.validateNom(nom)) != null) {
            throw new ValidationException(error);
        }

        if ((error = ValidationUtil.validatePrenom(prenom)) != null) {
            throw new ValidationException(error);
        }

        if ((error = ValidationUtil.validateEmail(email)) != null) {
            throw new ValidationException(error);
        }

        if ((error = ValidationUtil.validatePoids(poids)) != null) {
            throw new ValidationException(error);
        }

        if ((error = ValidationUtil.validateTaille(taille)) != null) {
            throw new ValidationException(error);
        }
    }
}