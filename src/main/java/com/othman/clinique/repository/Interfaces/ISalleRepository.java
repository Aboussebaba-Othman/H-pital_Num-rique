package com.othman.clinique.repository.Interfaces;

import com.othman.clinique.model.Salle;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface ISalleRepository extends IGenericRepository<Salle> {

    // Trouver une salle par son nom
    Optional<Salle> findByNomSalle(String nomSalle);

    // Vérifier l'existence par nom
    boolean existsByNomSalle(String nomSalle);

    // Trouver toutes les salles disponibles pour un créneau donné
    List<Salle> findSallesDisponibles(LocalDateTime dateHeure);

    // Trouver une salle avec ses consultations pour une date
    Optional<Salle> findByIdWithConsultations(Long salleId, LocalDate date);

    // Rechercher des salles par capacité minimale
    List<Salle> findByCapaciteGreaterThanEqual(Integer capacite);
}