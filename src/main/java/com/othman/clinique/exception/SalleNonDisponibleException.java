package com.othman.clinique.exception;

public class SalleNonDisponibleException extends RuntimeException {

    public SalleNonDisponibleException(String message) {
        super(message);
    }

    public SalleNonDisponibleException() {
        super("Aucune salle disponible pour ce créneau");
    }
}