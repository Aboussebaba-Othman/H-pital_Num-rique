package com.othman.clinique.exception;

public class EmailAlreadyExistsException extends RuntimeException {

    public EmailAlreadyExistsException(String email) {
        super(String.format("L'email %s est déjà utilisé", email));
    }
}