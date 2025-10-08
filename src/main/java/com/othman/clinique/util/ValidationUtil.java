package com.othman.clinique.util;

import java.util.regex.Pattern;

/**
 * Utilitaire pour la validation des données
 *
 * @author Othman
 * @version 1.0
 */
public final class ValidationUtil {

    // Patterns de validation
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );

    private static final Pattern PHONE_PATTERN = Pattern.compile(
            "^(\\+212|0)[5-7][0-9]{8}$" // Format marocain
    );

    /**
     * Constructeur privé
     */
    private ValidationUtil() {
        throw new AssertionError("Cette classe ne doit pas être instanciée");
    }

    /**
     * Vérifie si une chaîne est null ou vide
     */
    public static boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    /**
     * Vérifie si une chaîne est non null et non vide
     */
    public static boolean isNotEmpty(String str) {
        return !isNullOrEmpty(str);
    }

    /**
     * Valide une adresse email
     */
    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }

    /**
     * Valide un numéro de téléphone marocain
     */
    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone).matches();
    }

    /**
     * Valide un nom (au moins 2 caractères, lettres uniquement)
     */
    public static boolean isValidName(String name) {
        return name != null &&
                name.trim().length() >= 2 &&
                name.matches("^[a-zA-ZÀ-ÿ\\s-]+$");
    }

    /**
     * Valide un poids (entre 1 et 300 kg)
     */
    public static boolean isValidPoids(Double poids) {
        return poids != null && poids > 0 && poids <= 300;
    }

    /**
     * Valide une taille (entre 0.5 et 2.5 m)
     */
    public static boolean isValidTaille(Double taille) {
        return taille != null && taille >= 0.5 && taille <= 2.5;
    }

    /**
     * Valide un email avec message d'erreur
     */
    public static String validateEmail(String email) {
        if (isNullOrEmpty(email)) {
            return "L'email est requis";
        }

        if (!isValidEmail(email)) {
            return "Format d'email invalide";
        }

        return null; // Valide
    }

    /**
     * Valide un nom avec message d'erreur
     */
    public static String validateNom(String nom) {
        if (isNullOrEmpty(nom)) {
            return "Le nom est requis";
        }

        if (nom.trim().length() < 2) {
            return "Le nom doit contenir au moins 2 caractères";
        }

        if (!isValidName(nom)) {
            return "Le nom ne doit contenir que des lettres";
        }

        return null; // Valide
    }

    /**
     * Valide un prénom avec message d'erreur
     */
    public static String validatePrenom(String prenom) {
        return validateNom(prenom); // Même validation que le nom
    }

    /**
     * Valide un poids avec message d'erreur
     */
    public static String validatePoids(Double poids) {
        if (poids == null) {
            return "Le poids est requis";
        }

        if (poids <= 0) {
            return "Le poids doit être supérieur à 0";
        }

        if (poids > 300) {
            return "Le poids ne peut pas dépasser 300 kg";
        }

        return null; // Valide
    }

    /**
     * Valide une taille avec message d'erreur
     */
    public static String validateTaille(Double taille) {
        if (taille == null) {
            return "La taille est requise";
        }

        if (taille < 0.5) {
            return "La taille ne peut pas être inférieure à 0,5 m";
        }

        if (taille > 2.5) {
            return "La taille ne peut pas dépasser 2,5 m";
        }

        return null; // Valide
    }

    /**
     * Valide un motif de consultation
     */
    public static String validateMotifConsultation(String motif) {
        if (isNullOrEmpty(motif)) {
            return "Le motif de consultation est requis";
        }

        if (motif.trim().length() < 10) {
            return "Le motif doit contenir au moins 10 caractères";
        }

        if (motif.length() > 500) {
            return "Le motif ne peut pas dépasser 500 caractères";
        }

        return null; // Valide
    }

    /**
     * Valide un compte rendu médical
     */
    public static String validateCompteRendu(String compteRendu) {
        if (isNullOrEmpty(compteRendu)) {
            return "Le compte rendu est requis";
        }

        if (compteRendu.trim().length() < 50) {
            return "Le compte rendu doit contenir au moins 50 caractères";
        }

        if (compteRendu.length() > 5000) {
            return "Le compte rendu ne peut pas dépasser 5000 caractères";
        }

        return null; // Valide
    }

    /**
     * Nettoie une chaîne (trim et supprime les espaces multiples)
     */
    public static String sanitize(String input) {
        if (input == null) {
            return null;
        }

        return input.trim().replaceAll("\\s+", " ");
    }
}