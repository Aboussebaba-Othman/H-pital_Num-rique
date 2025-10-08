package com.othman.clinique.exception;


public class ValidationException extends RuntimeException {

    public ValidationException(String message) {
        super(message);
    }
}