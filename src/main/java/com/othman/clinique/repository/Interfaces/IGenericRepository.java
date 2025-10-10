package com.othman.clinique.repository.Interfaces;

import java.util.List;
import java.util.Optional;

public interface IGenericRepository<T> {
    T save(T entity);
    T update(T entity);
    Optional<T> findById(Long id);
    List<T> findAll();
    void delete(T entity);
    void deleteById(Long id);
    Long count();
    boolean existsById(Long id);
}
