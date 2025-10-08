package com.othman.clinique.exception;

public class AuthenticationException extends RuntimeException {

    public AuthenticationException(String message) {
        super(message);
    }

    public AuthenticationException() {
        super("Email ou mot de passe incorrect");
    }
}