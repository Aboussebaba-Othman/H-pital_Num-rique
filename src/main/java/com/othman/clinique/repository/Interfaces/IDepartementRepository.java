package com.othman.clinique.repository.Interfaces;

import com.othman.clinique.model.Departement;

import java.util.Optional;

public interface IDepartementRepository extends IGenericRepository<Departement> {
    Optional<Departement> findByNom(String nom);
    boolean existsByNom(String nom);
    Optional<Departement> findByIdWithDocteurs(Long id);
}
