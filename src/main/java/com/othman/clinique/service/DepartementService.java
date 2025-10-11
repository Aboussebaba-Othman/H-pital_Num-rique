package com.othman.clinique.service;

import com.othman.clinique.exception.EntityNotFoundException;
import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.Departement;
import com.othman.clinique.repository.Interfaces.IDepartementRepository;
import com.othman.clinique.repository.impl.DepartementRepositoryImpl;
import com.othman.clinique.util.ValidationUtil;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DepartementService {

    private static final Logger LOGGER = Logger.getLogger(DepartementService.class.getName());

    private final IDepartementRepository departementRepository;

    public DepartementService() {
        this.departementRepository = new DepartementRepositoryImpl();
    }

    // ==================== CONSULTATION ====================

    public Departement getDepartementById(Long departementId) {
        if (departementId == null || departementId <= 0) {
            throw new ValidationException("ID département invalide");
        }

        return departementRepository.findById(departementId)
                .orElseThrow(() -> new EntityNotFoundException("Département", departementId));
    }

    public Departement getDepartementByNom(String nom) {
        if (ValidationUtil.isNullOrEmpty(nom)) {
            throw new ValidationException("Le nom du département est requis");
        }

        return departementRepository.findByNom(nom)
                .orElseThrow(() -> new EntityNotFoundException("Département introuvable avec le nom: " + nom));
    }


    public Departement getDepartementWithDocteurs(Long departementId) {
        if (departementId == null || departementId <= 0) {
            throw new ValidationException("ID département invalide");
        }

        return departementRepository.findByIdWithDocteurs(departementId)
                .orElseThrow(() -> new EntityNotFoundException("Département", departementId));
    }


    public List<Departement> getAllDepartements() {
        try {
            List<Departement> departements = departementRepository.findAll();
            LOGGER.info("Récupération de " + departements.size() + " départements");
            return departements;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération", e);
            throw new RuntimeException("Erreur système lors de la récupération", e);
        }
    }

    // ==================== CRÉATION ====================

    public Departement createDepartement(String nom) {
        try {
            validateNomDepartement(nom);

            if (departementRepository.existsByNom(nom)) {
                throw new ValidationException("Un département existe déjà avec ce nom");
            }

            Departement departement = new Departement();
            departement.setNom(ValidationUtil.sanitize(nom));

            Departement saved = departementRepository.save(departement);
            LOGGER.info("Département créé - ID: " + saved.getIdDepartement());

            return saved;

        } catch (ValidationException e) {
            LOGGER.warning("Échec création: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la création", e);
            throw new RuntimeException("Erreur système lors de la création", e);
        }
    }

    // ==================== MODIFICATION ====================


    public Departement updateDepartement(Long departementId, String nouveauNom) {
        try {
            Departement departement = getDepartementById(departementId);
            validateNomDepartement(nouveauNom);

            if (!departement.getNom().equalsIgnoreCase(nouveauNom)) {
                if (departementRepository.existsByNom(nouveauNom)) {
                    throw new ValidationException("Un département existe déjà avec ce nom");
                }
            }

            departement.setNom(ValidationUtil.sanitize(nouveauNom));
            Departement updated = departementRepository.update(departement);
            LOGGER.info("Département mis à jour - ID: " + departementId);

            return updated;

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.warning("Échec mise à jour: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la mise à jour", e);
            throw new RuntimeException("Erreur système lors de la mise à jour", e);
        }
    }

    // ==================== SUPPRESSION ====================


    public void deleteDepartement(Long departementId) {
        try {
            Departement departement = getDepartementWithDocteurs(departementId);

            if (departement.getDocteurs() != null && !departement.getDocteurs().isEmpty()) {
                throw new ValidationException(
                        "Impossible de supprimer: " + departement.getDocteurs().size() +
                                " docteur(s) rattaché(s). Réaffectez-les d'abord."
                );
            }

            departementRepository.deleteById(departementId);
            LOGGER.info("Département supprimé - ID: " + departementId);

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.warning("Échec suppression: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la suppression", e);
            throw new RuntimeException("Erreur système lors de la suppression", e);
        }
    }

    // ==================== STATISTIQUES ====================

    public Long countDepartements() {
        try {
            return departementRepository.count();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur comptage", e);
            return 0L;
        }
    }

    public boolean departementExists(Long departementId) {
        if (departementId == null || departementId <= 0) return false;
        return departementRepository.existsById(departementId);
    }

    public int countDocteursInDepartement(Long departementId) {
        try {
            Departement dept = getDepartementWithDocteurs(departementId);
            return dept.getDocteurs() != null ? dept.getDocteurs().size() : 0;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Erreur comptage docteurs", e);
            return 0;
        }
    }

    // ==================== VALIDATION PRIVÉE ====================


    private void validateNomDepartement(String nom) {
        if (ValidationUtil.isNullOrEmpty(nom)) {
            throw new ValidationException("Le nom du département est requis");
        }

        if (nom.trim().length() < 2) {
            throw new ValidationException("Le nom doit contenir au moins 2 caractères");
        }

        if (nom.length() > 100) {
            throw new ValidationException("Le nom ne peut pas dépasser 100 caractères");
        }
    }
}