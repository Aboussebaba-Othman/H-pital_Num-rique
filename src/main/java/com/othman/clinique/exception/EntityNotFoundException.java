
package com.othman.clinique.exception;

public class EntityNotFoundException extends RuntimeException {

    public EntityNotFoundException(String message) {
        super(message);
    }

    public EntityNotFoundException(String entityName, Long id) {
        super(String.format("%s avec l'ID %d introuvable", entityName, id));
    }
}