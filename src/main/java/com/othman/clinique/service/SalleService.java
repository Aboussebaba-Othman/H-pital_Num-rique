package com.othman.clinique.service;

import com.othman.clinique.exception.EntityNotFoundException;
import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.Salle;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.repository.Interfaces.ISalleRepository;
import com.othman.clinique.repository.impl.SalleRepositoryImpl;
import com.othman.clinique.util.ValidationUtil;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SalleService {

    private static final Logger LOGGER = Logger.getLogger(SalleService.class.getName());

    private final ISalleRepository salleRepository;

    public SalleService() {
        this.salleRepository = new SalleRepositoryImpl();
    }

    // ==================== CONSULTATION ====================

    public Salle getSalleById(Long salleId) {
        if (salleId == null || salleId <= 0) {
            throw new ValidationException("ID salle invalide");
        }

        return salleRepository.findById(salleId)
                .orElseThrow(() -> new EntityNotFoundException("Salle", salleId));
    }


    public Salle getSalleByNom(String nomSalle) {
        if (ValidationUtil.isNullOrEmpty(nomSalle)) {
            throw new ValidationException("Le nom de la salle est requis");
        }

        return salleRepository.findByNomSalle(nomSalle)
                .orElseThrow(() -> new EntityNotFoundException("Salle introuvable avec le nom: " + nomSalle));
    }


    public Salle getSalleWithConsultations(Long salleId, LocalDate date) {
        if (salleId == null || salleId <= 0) {
            throw new ValidationException("ID salle invalide");
        }
        if (date == null) {
            throw new ValidationException("La date est requise");
        }

        return salleRepository.findByIdWithConsultations(salleId, date)
                .orElseThrow(() -> new EntityNotFoundException("Salle", salleId));
    }


    public List<Salle> getAllSalles() {
        try {
            List<Salle> salles = salleRepository.findAll();
            LOGGER.info("Récupération de " + salles.size() + " salles");
            return salles;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur récupération salles", e);
            throw new RuntimeException("Erreur système lors de la récupération", e);
        }
    }

    public List<Salle> getSallesByCapacite(Integer capaciteMin) {
        if (capaciteMin == null || capaciteMin <= 0) {
            throw new ValidationException("Capacité minimale invalide");
        }

        try {
            List<Salle> salles = salleRepository.findByCapaciteGreaterThanEqual(capaciteMin);
            LOGGER.info("Trouvé " + salles.size() + " salles avec capacité >= " + capaciteMin);
            return salles;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur récupération par capacité", e);
            throw new RuntimeException("Erreur système lors de la récupération", e);
        }
    }

    // ==================== DISPONIBILITÉ ====================


    public List<Salle> getSallesDisponibles(LocalDateTime dateHeure) {
        if (dateHeure == null) {
            throw new ValidationException("La date et l'heure sont requises");
        }

        try {
            List<Salle> salles = salleRepository.findSallesDisponibles(dateHeure);
            LOGGER.info("Trouvé " + salles.size() + " salles disponibles pour " + dateHeure);
            return salles;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur recherche disponibilités", e);
            throw new RuntimeException("Erreur système lors de la recherche", e);
        }
    }


    public boolean isSalleDisponible(Long salleId, LocalDateTime dateHeure) {
        if (salleId == null || salleId <= 0) {
            throw new ValidationException("ID salle invalide");
        }
        if (dateHeure == null) {
            throw new ValidationException("La date et l'heure sont requises");
        }

        try {
            Salle salle = getSalleById(salleId);
            return salle.isDisponible(dateHeure);
        } catch (EntityNotFoundException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Erreur vérification disponibilité", e);
            return false;
        }
    }

//     Calcule le taux d'occupation d'une salle pour une date

    public double getTauxOccupation(Long salleId, LocalDate date) {
        try {
            Salle salle = getSalleWithConsultations(salleId, date);

            final int CRENEAUX_TOTAL = 20;

            long consultationsActives = salle.getConsultations().stream()
                    .filter(c -> c.getDate().equals(date))
                    .filter(c -> c.getStatut() != StatutConsultation.ANNULEE)
                    .count();

            double taux = (consultationsActives * 100.0) / CRENEAUX_TOTAL;
            LOGGER.info("Taux occupation salle " + salleId + " le " + date + ": " +
                    String.format("%.1f%%", taux));

            return Math.round(taux * 10.0) / 10.0;

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Erreur calcul taux occupation", e);
            return 0.0;
        }
    }

    // ==================== CRÉATION ====================

    public Salle createSalle(String nomSalle, Integer capacite) {
        try {
            validateSalleData(nomSalle, capacite);

            if (salleRepository.existsByNomSalle(nomSalle)) {
                throw new ValidationException("Une salle existe déjà avec ce nom");
            }

            Salle salle = new Salle();
            salle.setNomSalle(ValidationUtil.sanitize(nomSalle));
            salle.setCapacite(capacite);

            Salle saved = salleRepository.save(salle);
            LOGGER.info("Salle créée - ID: " + saved.getIdSalle());

            return saved;

        } catch (ValidationException e) {
            LOGGER.warning("Échec création: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur création salle", e);
            throw new RuntimeException("Erreur système lors de la création", e);
        }
    }

    // ==================== MODIFICATION ====================

    public Salle updateSalle(Long salleId, String nouveauNom, Integer nouvelleCapacite) {
        try {
            Salle salle = getSalleById(salleId);
            validateSalleData(nouveauNom, nouvelleCapacite);

            if (!salle.getNomSalle().equalsIgnoreCase(nouveauNom)) {
                if (salleRepository.existsByNomSalle(nouveauNom)) {
                    throw new ValidationException("Une salle existe déjà avec ce nom");
                }
            }

            salle.setNomSalle(ValidationUtil.sanitize(nouveauNom));
            salle.setCapacite(nouvelleCapacite);

            Salle updated = salleRepository.update(salle);
            LOGGER.info("Salle mise à jour - ID: " + salleId);

            return updated;

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.warning("Échec mise à jour: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur mise à jour salle", e);
            throw new RuntimeException("Erreur système lors de la mise à jour", e);
        }
    }


    public void deleteSalle(Long salleId) {
        try {
            Salle salle = getSalleWithConsultations(salleId, LocalDate.now());

            boolean hasConsultationsFutures = salle.getConsultations().stream()
                    .anyMatch(c -> c.getDateTimeDebut().isAfter(LocalDateTime.now()) &&
                            c.getStatut() != StatutConsultation.ANNULEE);

            if (hasConsultationsFutures) {
                throw new ValidationException(
                        "Impossible de supprimer: consultations futures prévues. " +
                                "Annulez ou déplacez-les d'abord."
                );
            }

            salleRepository.deleteById(salleId);
            LOGGER.info("Salle supprimée - ID: " + salleId);

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.warning("Échec suppression: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur suppression salle", e);
            throw new RuntimeException("Erreur système lors de la suppression", e);
        }
    }

    // ==================== STATISTIQUES ====================

    public Long countSalles() {
        try {
            return salleRepository.count();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur comptage", e);
            return 0L;
        }
    }

    public boolean salleExists(Long salleId) {
        if (salleId == null || salleId <= 0) return false;
        return salleRepository.existsById(salleId);
    }

    // ==================== VALIDATION PRIVÉE ====================

    private void validateSalleData(String nomSalle, Integer capacite) {
        if (ValidationUtil.isNullOrEmpty(nomSalle)) {
            throw new ValidationException("Le nom de la salle est requis");
        }

        if (nomSalle.trim().length() < 2) {
            throw new ValidationException("Le nom doit contenir au moins 2 caractères");
        }

        if (nomSalle.length() > 50) {
            throw new ValidationException("Le nom ne peut pas dépasser 50 caractères");
        }

        if (capacite == null || capacite <= 0) {
            throw new ValidationException("La capacité doit être supérieure à 0");
        }

        if (capacite > 100) {
            throw new ValidationException("La capacité ne peut pas dépasser 100");
        }
    }
}