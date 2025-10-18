package com.othman.clinique.model;

import com.othman.clinique.util.DateUtil;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "consultation")
public class Consultation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_consultation")
    private Long idConsultation;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "heure", nullable = false)
    private LocalTime heure;

    @Column(name = "motif_consultation", nullable = false)
    private String motifConsultation;

    @Column(name = "compte_rendu", columnDefinition = "TEXT")
    private String compteRendu;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut", nullable = false)
    private StatutConsultation statut;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "docteur_id", nullable = false)
    private Docteur docteur;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "salle_id", nullable = false)
    private Salle salle;

    // ==================== CONSTRUCTEURS ====================

    public Consultation() {
    }

    public Consultation(LocalDate date, LocalTime heure, String motifConsultation,
                        StatutConsultation statut, Patient patient, Docteur docteur, Salle salle) {
        this.date = date;
        this.heure = heure;
        this.motifConsultation = motifConsultation;
        this.statut = statut;
        this.patient = patient;
        this.docteur = docteur;
        this.salle = salle;
    }

    // ==================== MÉTHODES DE FORMATAGE (AJOUT) ====================

    /**
     * Retourne la date formatée en version longue (ex: vendredi 01 janvier 2025)
     * Utilisable directement dans les JSP avec ${consultation.dateFormatee}
     */
    @Transient
    public String getDateFormatee() {
        return DateUtil.formatDateLong(this.date);
    }

    /**
     * Retourne la date au format court (ex: 01/01/2025)
     * Utilisable dans les JSP avec ${consultation.dateCourte}
     */
    @Transient
    public String getDateCourte() {
        return DateUtil.formatDate(this.date);
    }

    /**
     * Retourne l'heure formatée (ex: 09:30)
     * Utilisable dans les JSP avec ${consultation.heureFormatee}
     */
    @Transient
    public String getHeureFormatee() {
        return DateUtil.formatTime(this.heure);
    }

    /**
     * Retourne la date et l'heure formatées (ex: 01/01/2025 09:30)
     * Utilisable dans les JSP avec ${consultation.dateHeureFormatee}
     */
    @Transient
    public String getDateHeureFormatee() {
        return DateUtil.formatDateTime(this.date, this.heure);
    }

    // ==================== MÉTHODES MÉTIER ====================

    public LocalDateTime getDateTimeDebut() {
        return LocalDateTime.of(date, heure);
    }

    public LocalDateTime getDateTimeFin() {
        return getDateTimeDebut().plusMinutes(DateUtil.DUREE_CONSULTATION_MINUTES);
    }

    public boolean isPassed() {
        return getDateTimeDebut().isBefore(LocalDateTime.now());
    }

    public boolean isToday() {
        return DateUtil.isToday(this.date);
    }

    public boolean isFuture() {
        return DateUtil.isFutureDateTime(getDateTimeDebut());
    }

    // ==================== GETTERS & SETTERS ====================

    public Long getIdConsultation() {
        return idConsultation;
    }

    public void setIdConsultation(Long idConsultation) {
        this.idConsultation = idConsultation;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public LocalTime getHeure() {
        return heure;
    }

    public void setHeure(LocalTime heure) {
        this.heure = heure;
    }

    public String getMotifConsultation() {
        return motifConsultation;
    }

    public void setMotifConsultation(String motifConsultation) {
        this.motifConsultation = motifConsultation;
    }

    public String getCompteRendu() {
        return compteRendu;
    }

    public void setCompteRendu(String compteRendu) {
        this.compteRendu = compteRendu;
    }

    public StatutConsultation getStatut() {
        return statut;
    }

    public void setStatut(StatutConsultation statut) {
        this.statut = statut;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Docteur getDocteur() {
        return docteur;
    }

    public void setDocteur(Docteur docteur) {
        this.docteur = docteur;
    }

    public Salle getSalle() {
        return salle;
    }

    public void setSalle(Salle salle) {
        this.salle = salle;
    }

    @Override
    public String toString() {
        return "Consultation{" +
                "id=" + idConsultation +
                ", date=" + date +
                ", heure=" + heure +
                ", motif='" + motifConsultation + '\'' +
                ", statut=" + statut +
                ", patient=" + (patient != null ? patient.getNom() : "null") +
                ", docteur=" + (docteur != null ? docteur.getNom() : "null") +
                ", salle=" + (salle != null ? salle.getNomSalle() : "null") +
                '}';
    }
}