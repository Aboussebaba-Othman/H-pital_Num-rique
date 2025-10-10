package com.othman.clinique.repository.Interfaces;

import com.othman.clinique.model.Docteur;

import java.util.List;
import java.util.Optional;

public interface IDocteurRepository extends IGenericRepository<Docteur>{
    Optional<Docteur> findByEmail(String email);
    boolean existsByEmail(String email);
    List<Docteur> findByDepartementId(Long departementId);
    List<Docteur> findBySpecialite(String specialite);
    Optional<Docteur> findByIdWithPlanning(Long docteurId);
    List<Docteur> search(String searchTerm);
}
