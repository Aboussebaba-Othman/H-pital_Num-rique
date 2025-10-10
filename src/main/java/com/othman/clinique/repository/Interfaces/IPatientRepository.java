package com.othman.clinique.repository.Interfaces;

import com.othman.clinique.model.Patient;

import java.util.List;
import java.util.Optional;

public interface IPatientRepository extends IGenericRepository<Patient>{
    Optional<Patient> findByEmail(String email);
    boolean existsByEmail(String email);
    List<Patient> search(String searchTerm);
    Optional<Patient> findByIdWithConsultations(Long patientId);
}
