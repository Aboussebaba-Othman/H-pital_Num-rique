package com.othman.clinique.service;

import com.othman.clinique.exception.EmailAlreadyExistsException;
import com.othman.clinique.exception.EntityNotFoundException;
import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.Docteur;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.repository.Interfaces.IDocteurRepository;
import com.othman.clinique.repository.impl.DocteurRepository;
import com.othman.clinique.util.ValidationUtil;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class DocteurService {

    private static final Logger LOGGER = Logger.getLogger(DocteurService.class.getName());

    private final IDocteurRepository docteurRepository;

    public DocteurService() {
        this.docteurRepository = new DocteurRepository();
    }

    // ==================== CONSULTATION ====================

    public Docteur getDocteurById(Long docteurId) {
        if (docteurId == null || docteurId <= 0) {
            throw new ValidationException("ID docteur invalide");
        }

        return docteurRepository.findById(docteurId)
                .orElseThrow(() -> new EntityNotFoundException("Docteur", docteurId));
    }


    public Docteur getDocteurByEmail(String email) {
        String error = ValidationUtil.validateEmail(email);
        if (error != null) {
            throw new ValidationException(error);
        }

        return docteurRepository.findByEmail(email)
                .orElseThrow(() -> new EntityNotFoundException("Docteur introuvable avec l'email: " + email));
    }


    public Docteur getDocteurWithPlanning(Long docteurId) {
        if (docteurId == null || docteurId <= 0) {
            throw new ValidationException("ID docteur invalide");
        }

        return docteurRepository.findByIdWithPlanning(docteurId)
                .orElseThrow(() -> new EntityNotFoundException("Docteur", docteurId));
    }

    public List<Docteur> getAllDocteurs() {
        try {
            List<Docteur> docteurs = docteurRepository.findAll();
            LOGGER.info("Récupération de " + docteurs.size() + " docteurs");
            return docteurs;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération des docteurs", e);
            throw new RuntimeException("Erreur système lors de la récupération", e);
        }
    }

    public List<Docteur> getDocteursByDepartement(Long departementId) {
        if (departementId == null || departementId <= 0) {
            throw new ValidationException("ID département invalide");
        }

        try {
            List<Docteur> docteurs = docteurRepository.findByDepartementId(departementId);
            LOGGER.info("Récupération de " + docteurs.size() + " docteurs pour le département " + departementId);
            return docteurs;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération par département", e);
            throw new RuntimeException("Erreur système lors de la récupération", e);
        }
    }

    public List<Docteur> getDocteursBySpecialite(String specialite) {
        if (ValidationUtil.isNullOrEmpty(specialite)) {
            throw new ValidationException("La spécialité est requise");
        }

        try {
            String sanitized = ValidationUtil.sanitize(specialite);
            List<Docteur> docteurs = docteurRepository.findBySpecialite(sanitized);
            LOGGER.info("Récupération de " + docteurs.size() + " docteurs en " + sanitized);
            return docteurs;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération par spécialité", e);
            throw new RuntimeException("Erreur système lors de la récupération", e);
        }
    }

    public List<Docteur> searchDocteurs(String searchTerm) {
        if (ValidationUtil.isNullOrEmpty(searchTerm)) {
            return getAllDocteurs();
        }

        try {
            String sanitized = ValidationUtil.sanitize(searchTerm);
            List<Docteur> docteurs = docteurRepository.search(sanitized);
            LOGGER.info("Recherche docteurs '" + sanitized + "' - " + docteurs.size() + " résultats");
            return docteurs;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la recherche", e);
            throw new RuntimeException("Erreur système lors de la recherche", e);
        }
    }

    // ==================== PLANNING ====================


    public List<Consultation> getPlanningByDate(Long docteurId, LocalDate date) {
        if (date == null) {
            throw new ValidationException("La date est requise");
        }

        try {
            Docteur docteur = getDocteurWithPlanning(docteurId);

            return docteur.getPlanning().stream()
                    .filter(c -> c.getDate().equals(date))
                    .filter(c -> c.getStatut() != StatutConsultation.ANNULEE)
                    .sorted(Comparator.comparing(Consultation::getHeure))
                    .collect(Collectors.toList());

        } catch (ValidationException | EntityNotFoundException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération du planning", e);
            throw new RuntimeException("Erreur système lors de la récupération", e);
        }
    }


    public List<Consultation> getConsultationsFutures(Long docteurId) {
        try {
            Docteur docteur = getDocteurWithPlanning(docteurId);
            LocalDate today = LocalDate.now();

            return docteur.getPlanning().stream()
                    .filter(c -> c.getDate().isAfter(today) || c.getDate().equals(today))
                    .filter(c -> c.getStatut() == StatutConsultation.RESERVEE ||
                            c.getStatut() == StatutConsultation.VALIDEE)
                    .sorted(Comparator.comparing(Consultation::getDate).thenComparing(Consultation::getHeure))
                    .collect(Collectors.toList());

        } catch (EntityNotFoundException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération des consultations futures", e);
            throw new RuntimeException("Erreur système lors de la récupération", e);
        }
    }

    // ==================== MODIFICATION ====================


    public Docteur updateDocteur(Long docteurId, String nom, String prenom,
                                 String email, String specialite, Long departementId) {
        try {
            // Récupérer le docteur existant
            Docteur docteur = getDocteurById(docteurId);

            // Validation des nouvelles données
            validateDocteurData(nom, prenom, email, specialite, departementId);

            // Vérifier unicité email si changement
            if (!docteur.getEmail().equalsIgnoreCase(email)) {
                if (docteurRepository.existsByEmail(email)) {
                    throw new EmailAlreadyExistsException(email);
                }
            }

            // Mise à jour des champs
            docteur.setNom(ValidationUtil.sanitize(nom));
            docteur.setPrenom(ValidationUtil.sanitize(prenom));
            docteur.setEmail(email.toLowerCase().trim());
            docteur.setSpecialite(ValidationUtil.sanitize(specialite));

            // Mise à jour département si nécessaire
            if (!docteur.getDepartement().getIdDepartement().equals(departementId)) {
                com.othman.clinique.model.Departement dept = new com.othman.clinique.model.Departement();
                dept.setIdDepartement(departementId);
                docteur.setDepartement(dept);
            }

            // Sauvegarder
            Docteur updated = docteurRepository.update(docteur);
            LOGGER.info("Docteur mis à jour - ID: " + docteurId);

            return updated;

        } catch (ValidationException | EntityNotFoundException | EmailAlreadyExistsException e) {
            LOGGER.warning("Échec mise à jour docteur: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la mise à jour", e);
            throw new RuntimeException("Erreur système lors de la mise à jour", e);
        }
    }

    // ==================== SUPPRESSION ====================

    public void deleteDocteur(Long docteurId) {
        try {
            Docteur docteur = getDocteurWithPlanning(docteurId);

            // Vérifier consultations futures
            boolean hasConsultationsFutures = docteur.getPlanning().stream()
                    .anyMatch(c -> c.getDateTimeDebut().isAfter(java.time.LocalDateTime.now()) &&
                            c.getStatut() != StatutConsultation.ANNULEE);

            if (hasConsultationsFutures) {
                throw new ValidationException(
                        "Impossible de supprimer ce docteur: il a des consultations futures. " +
                                "Veuillez d'abord annuler ses consultations."
                );
            }

            docteurRepository.deleteById(docteurId);
            LOGGER.info("Docteur supprimé - ID: " + docteurId);

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.warning("Échec suppression docteur: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la suppression", e);
            throw new RuntimeException("Erreur système lors de la suppression", e);
        }
    }

    // ==================== STATISTIQUES ====================

    public Long countDocteurs() {
        try {
            return docteurRepository.count();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du comptage", e);
            return 0L;
        }
    }

    public boolean docteurExists(Long docteurId) {
        if (docteurId == null || docteurId <= 0) {
            return false;
        }
        return docteurRepository.existsById(docteurId);
    }

    // ==================== VALIDATION PRIVÉE ====================

    private void validateDocteurData(String nom, String prenom, String email,
                                     String specialite, Long departementId) {
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

        if (ValidationUtil.isNullOrEmpty(specialite)) {
            throw new ValidationException("La spécialité est requise");
        }

        if (departementId == null || departementId <= 0) {
            throw new ValidationException("Le département est requis");
        }
    }
}