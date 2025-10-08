package com.othman.clinique.util;

import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

/**
 * Utilitaire pour la gestion des dates et heures
 *
 * @author Othman
 * @version 1.0
 */
public final class DateUtil {

    // Formats standards
    public static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    public static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");
    public static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    // Heures d'ouverture de la clinique
    public static final LocalTime HEURE_OUVERTURE = LocalTime.of(8, 0);
    public static final LocalTime HEURE_FERMETURE = LocalTime.of(18, 0);

    // Durée d'une consultation
    public static final int DUREE_CONSULTATION_MINUTES = 30;

    /**
     * Constructeur privé
     */
    private DateUtil() {
        throw new AssertionError("Cette classe ne doit pas être instanciée");
    }

    /**
     * Formate une date au format dd/MM/yyyy
     */
    public static String formatDate(LocalDate date) {
        return date != null ? date.format(DATE_FORMATTER) : "";
    }

    /**
     * Formate une heure au format HH:mm
     */
    public static String formatTime(LocalTime time) {
        return time != null ? time.format(TIME_FORMATTER) : "";
    }

    /**
     * Formate une date-heure au format dd/MM/yyyy HH:mm
     */
    public static String formatDateTime(LocalDateTime dateTime) {
        return dateTime != null ? dateTime.format(DATETIME_FORMATTER) : "";
    }

    /**
     * Parse une chaîne en LocalDate (dd/MM/yyyy)
     */
    public static LocalDate parseDate(String dateStr) throws DateTimeParseException {
        return LocalDate.parse(dateStr, DATE_FORMATTER);
    }

    /**
     * Parse une chaîne en LocalTime (HH:mm)
     */
    public static LocalTime parseTime(String timeStr) throws DateTimeParseException {
        return LocalTime.parse(timeStr, TIME_FORMATTER);
    }

    /**
     * Vérifie si une date est dans le futur
     */
    public static boolean isFutureDate(LocalDate date) {
        return date != null && date.isAfter(LocalDate.now());
    }

    /**
     * Vérifie si une date-heure est dans le futur
     */
    public static boolean isFutureDateTime(LocalDateTime dateTime) {
        return dateTime != null && dateTime.isAfter(LocalDateTime.now());
    }

    /**
     * Vérifie si une heure est dans les heures d'ouverture
     */
    public static boolean isDansHeuresOuverture(LocalTime time) {
        return time != null &&
                !time.isBefore(HEURE_OUVERTURE) &&
                !time.isAfter(HEURE_FERMETURE.minusMinutes(DUREE_CONSULTATION_MINUTES));
    }

    /**
     * Vérifie si un créneau est valide (multiple de 30 minutes)
     */
    public static boolean isCreneauValide(LocalTime time) {
        return time != null && time.getMinute() % 30 == 0;
    }

    /**
     * Arrondit une heure au créneau de 30 minutes le plus proche
     */
    public static LocalTime arrondirAuCreneauProche(LocalTime time) {
        if (time == null) {
            return null;
        }

        int minutes = time.getMinute();
        int nouveauMinutes = (minutes < 15) ? 0 :
                (minutes < 45) ? 30 : 0;
        int nouvelleHeure = (minutes >= 45) ? time.getHour() + 1 : time.getHour();

        return LocalTime.of(nouvelleHeure, nouveauMinutes);
    }

    /**
     * Génère tous les créneaux disponibles pour une journée
     * Créneaux de 30 minutes de 08:00 à 17:30
     */
    public static List<LocalTime> genererCreneauxJournee() {
        List<LocalTime> creneaux = new ArrayList<>();
        LocalTime creneau = HEURE_OUVERTURE;

        while (!creneau.isAfter(HEURE_FERMETURE.minusMinutes(DUREE_CONSULTATION_MINUTES))) {
            creneaux.add(creneau);
            creneau = creneau.plusMinutes(DUREE_CONSULTATION_MINUTES);
        }

        return creneaux;
    }

    /**
     * Calcule le nombre de jours entre deux dates
     */
    public static long joursEntre(LocalDate debut, LocalDate fin) {
        return debut != null && fin != null ?
                Duration.between(debut.atStartOfDay(), fin.atStartOfDay()).toDays() : 0;
    }

    /**
     * Vérifie si une date est un jour ouvrable (lundi-vendredi)
     */
    public static boolean isJourOuvrable(LocalDate date) {
        if (date == null) {
            return false;
        }

        DayOfWeek jour = date.getDayOfWeek();
        return jour != DayOfWeek.SATURDAY && jour != DayOfWeek.SUNDAY;
    }

    /**
     * Valide une date de consultation
     * - Doit être dans le futur
     * - Doit être un jour ouvrable
     * - Maximum 30 jours à l'avance
     */
    public static String validateDateConsultation(LocalDate date) {
        if (date == null) {
            return "La date est requise";
        }

        if (!date.isAfter(LocalDate.now())) {
            return "La date doit être dans le futur";
        }

        if (!isJourOuvrable(date)) {
            return "La clinique est fermée le week-end";
        }

        if (date.isAfter(LocalDate.now().plusDays(30))) {
            return "Vous ne pouvez réserver que jusqu'à 30 jours à l'avance";
        }

        return null; // Valide
    }

    /**
     * Valide une heure de consultation
     */
    public static String validateHeureConsultation(LocalTime heure) {
        if (heure == null) {
            return "L'heure est requise";
        }

        if (!isCreneauValide(heure)) {
            return "L'heure doit être un multiple de 30 minutes (ex: 09:00, 09:30, 10:00)";
        }

        if (!isDansHeuresOuverture(heure)) {
            return "L'heure doit être entre " + formatTime(HEURE_OUVERTURE) +
                    " et " + formatTime(HEURE_FERMETURE.minusMinutes(DUREE_CONSULTATION_MINUTES));
        }

        return null; // Valide
    }
}