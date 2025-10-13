package com.othman.clinique.util;

import org.mindrot.jbcrypt.BCrypt;


public final class PasswordUtil {

    private static final int BCRYPT_ROUNDS = 12;


    private PasswordUtil() {
        throw new AssertionError("Cette classe ne doit pas être instanciée");
    }

    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Le mot de passe ne peut pas être vide");
        }

        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_ROUNDS));
    }


    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }

        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }


    public static boolean isPasswordStrong(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }

        boolean hasUpperCase = password.chars().anyMatch(Character::isUpperCase);
        boolean hasLowerCase = password.chars().anyMatch(Character::isLowerCase);
        boolean hasDigit = password.chars().anyMatch(Character::isDigit);

        return hasUpperCase && hasLowerCase && hasDigit;
    }

    public static String validatePassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return "Le mot de passe est requis";
        }

        if (password.length() < 8) {
            return "Le mot de passe doit contenir au moins 8 caractères";
        }

        if (password.chars().noneMatch(Character::isUpperCase)) {
            return "Le mot de passe doit contenir au moins une majuscule";
        }

        if (password.chars().noneMatch(Character::isLowerCase)) {
            return "Le mot de passe doit contenir au moins une minuscule";
        }

        if (password.chars().noneMatch(Character::isDigit)) {
            return "Le mot de passe doit contenir au moins un chiffre";
        }

        return null;
    }
}