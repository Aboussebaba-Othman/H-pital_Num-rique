package com.othman.clinique.repository.Interfaces;

import com.othman.clinique.model.Administrateur;

import java.util.Optional;

public interface IAdministrateurRepository extends IGenericRepository<Administrateur>{
    Optional<Administrateur> findByEmail(String email);
    boolean existsByEmail(String email);
}
