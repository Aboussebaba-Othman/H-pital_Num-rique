package com.othman.clinique.service;

import com.othman.clinique.exception.AuthenticationException;
import com.othman.clinique.exception.EmailAlreadyExistsException;
import com.othman.clinique.exception.EntityNotFoundException;
import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.*;
import com.othman.clinique.repository.Interfaces.IAdministrateurRepository;
import com.othman.clinique.repository.Interfaces.IDocteurRepository;
import com.othman.clinique.repository.Interfaces.IPatientRepository;
import com.othman.clinique.repository.impl.AdministrateurRepositoryImpl;
import com.othman.clinique.repository.impl.DocteurRepository;
import com.othman.clinique.repository.impl.PatientRepositoryImpl;
import com.othman.clinique.util.PasswordUtil;
import com.othman.clinique.util.ValidationUtil;

import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;


public class AuthenticationService {

    private static final Logger LOGGER = Logger.getLogger(AuthenticationService.class.getName());

    private final IPatientRepository patientRepository;
    private final IDocteurRepository docteurRepository;
    private final IAdministrateurRepository adminRepository;

    public AuthenticationService() {
        this.patientRepository = new PatientRepositoryImpl();
        this.docteurRepository = new DocteurRepository();
        this.adminRepository = new AdministrateurRepositoryImpl();
    }

    // ==================== AUTHENTIFICATION ====================

    public Personne login(String email, String password) {
        try {
            if (ValidationUtil.isNullOrEmpty(email) || ValidationUtil.isNullOrEmpty(password)) {
                throw new ValidationException("Email et mot de passe requis");
            }

            Personne user = findUserByEmail(email);
            if (user == null) {
                LOGGER.warning("Tentative de connexion - Utilisateur introuvable: " + email);
                throw new AuthenticationException();
            }

            if (!PasswordUtil.checkPassword(password, user.getMotDePasse())) {
                LOGGER.warning("Tentative de connexion - Mot de passe incorrect: " + email);
                throw new AuthenticationException();
            }

            LOGGER.info("Connexion réussie - Email: " + email + ", Rôle: " + user.getRole());
            return user;

        } catch (ValidationException | AuthenticationException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de l'authentification", e);
            throw new RuntimeException("Erreur système lors de l'authentification", e);
        }
    }


    public Patient registerPatient(String nom, String prenom, String email,
                                   String plainPassword, Double poids, Double taille) {
        try {
            // Validation des données
            validatePatientRegistration(nom, prenom, email, plainPassword, poids, taille);

            // Vérifier unicité email
            if (emailExists(email)) {
                throw new EmailAlreadyExistsException(email);
            }

            // Créer le patient
            Patient patient = new Patient();
            patient.setNom(ValidationUtil.sanitize(nom));
            patient.setPrenom(ValidationUtil.sanitize(prenom));
            patient.setEmail(email.toLowerCase().trim());
            patient.setMotDePasse(PasswordUtil.hashPassword(plainPassword));
            patient.setRole(Role.PATIENT);
            patient.setPoids(poids);
            patient.setTaille(taille);

            // Sauvegarder
            Patient savedPatient = patientRepository.save(patient);
            LOGGER.info("Nouveau patient inscrit - ID: " + savedPatient.getId() + ", Email: " + email);

            return savedPatient;

        } catch (ValidationException | EmailAlreadyExistsException e) {
            LOGGER.warning("Échec inscription patient: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de l'inscription patient", e);
            throw new RuntimeException("Erreur système lors de l'inscription", e);
        }
    }


    private void validatePatientRegistration(String nom, String prenom, String email,
                                             String password, Double poids, Double taille) {
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

        if ((error = PasswordUtil.validatePassword(password)) != null) {
            throw new ValidationException(error);
        }

        if ((error = ValidationUtil.validatePoids(poids)) != null) {
            throw new ValidationException(error);
        }

        if ((error = ValidationUtil.validateTaille(taille)) != null) {
            throw new ValidationException(error);
        }
    }

    public Docteur registerDocteur(String nom, String prenom, String email,
                                   String plainPassword, String specialite, Long departementId) {
        try {
            // Validation des données
            validateDocteurRegistration(nom, prenom, email, plainPassword, specialite, departementId);

            // Vérifier  email
            if (emailExists(email)) {
                throw new EmailAlreadyExistsException(email);
            }

            // Créer le département
            Departement departement = new Departement();
            departement.setIdDepartement(departementId);

            // Créer le docteur
            Docteur docteur = new Docteur();
            docteur.setNom(ValidationUtil.sanitize(nom));
            docteur.setPrenom(ValidationUtil.sanitize(prenom));
            docteur.setEmail(email.toLowerCase().trim());
            docteur.setMotDePasse(PasswordUtil.hashPassword(plainPassword));
            docteur.setRole(Role.DOCTEUR);
            docteur.setSpecialite(ValidationUtil.sanitize(specialite));
            docteur.setDepartement(departement);

            // Sauvegarder
            Docteur savedDocteur = docteurRepository.save(docteur);
            LOGGER.info("Nouveau docteur inscrit - ID: " + savedDocteur.getId() + ", Email: " + email);

            return savedDocteur;

        } catch (ValidationException | EmailAlreadyExistsException e) {
            LOGGER.warning("Échec inscription docteur: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de l'inscription docteur", e);
            throw new RuntimeException("Erreur système lors de l'inscription", e);
        }
    }


    private void validateDocteurRegistration(String nom, String prenom, String email,
                                             String password, String specialite, Long departementId) {
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

        if ((error = PasswordUtil.validatePassword(password)) != null) {
            throw new ValidationException(error);
        }

        if (ValidationUtil.isNullOrEmpty(specialite)) {
            throw new ValidationException("La spécialité est requise");
        }

        if (departementId == null || departementId <= 0) {
            throw new ValidationException("Le département est requis");
        }
    }

    // ==================== CHANGEMENT MOT DE PASSE ====================

    public void changePassword(Long userId, Role role, String oldPassword, String newPassword) {
        try {
            // Validation
            if (userId == null || role == null) {
                throw new ValidationException("ID et rôle requis");
            }

            String error = PasswordUtil.validatePassword(newPassword);
            if (error != null) {
                throw new ValidationException(error);
            }

            // Récupérer l'utilisateur
            Personne user = findUserById(userId, role);
            if (user == null) {
                throw new EntityNotFoundException(role.name(), userId);
            }

            // Vérifier l'ancien mot de passe
            if (!PasswordUtil.checkPassword(oldPassword, user.getMotDePasse())) {
                throw new AuthenticationException("Ancien mot de passe incorrect");
            }

            // Mettre à jour le mot de passe
            user.setMotDePasse(PasswordUtil.hashPassword(newPassword));
            updateUser(user, role);

            LOGGER.info("Mot de passe changé - UserID: " + userId + ", Rôle: " + role);

        } catch (ValidationException | EntityNotFoundException | AuthenticationException e) {
            LOGGER.warning("Échec changement mot de passe: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du changement de mot de passe", e);
            throw new RuntimeException("Erreur système lors du changement de mot de passe", e);
        }
    }

    // ==================== UTILITAIRES ====================

    private Personne findUserByEmail(String email) {
        Optional<Patient> patient = patientRepository.findByEmail(email);
        if (patient.isPresent()) {
            return patient.get();
        }

        Optional<Docteur> docteur = docteurRepository.findByEmail(email);
        if (docteur.isPresent()) {
            return docteur.get();
        }

        Optional<Administrateur> admin = adminRepository.findByEmail(email);
        return admin.orElse(null);
    }


    public boolean emailExists(String email) {
        return patientRepository.existsByEmail(email) ||
                docteurRepository.existsByEmail(email) ||
                adminRepository.existsByEmail(email);
    }

    private Personne findUserById(Long userId, Role role) {
        switch (role) {
            case PATIENT:
                return patientRepository.findById(userId).orElse(null);
            case DOCTEUR:
                return docteurRepository.findById(userId).orElse(null);
            case ADMIN:
                return adminRepository.findById(userId).orElse(null);
            default:
                return null;
        }
    }


    private void updateUser(Personne user, Role role) {
        switch (role) {
            case PATIENT:
                patientRepository.update((Patient) user);
                break;
            case DOCTEUR:
                docteurRepository.update((Docteur) user);
                break;
            case ADMIN:
                adminRepository.update((Administrateur) user);
                break;
        }
    }

}