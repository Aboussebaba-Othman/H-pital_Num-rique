package com.othman.clinique.exception;

import java.time.LocalDateTime;

public class CreneauOccupeException extends RuntimeException {

    public CreneauOccupeException(String message) {
        super(message);
    }

    public CreneauOccupeException(LocalDateTime creneau) {
        super(String.format("Le créneau %s est déjà occupé", creneau));
    }
}