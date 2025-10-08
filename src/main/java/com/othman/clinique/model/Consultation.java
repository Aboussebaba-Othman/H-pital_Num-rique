package com.othman.clinique.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;


@Entity
@Table(name = "consultation")
public class Consultation implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_consultation")
    private Long idConsultation;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "heure", nullable = false)
    private LocalTime heure;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut", nullable = false, length = 20)
    private StatutConsultation statut;

    @Column(name = "motif_consultation", columnDefinition = "TEXT")
    private String motifConsultation;

    @Column(name = "compte_rendu", columnDefinition = "TEXT")
    private String compteRendu;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "docteur_id", nullable = false)
    private Docteur docteur;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "salle_id", nullable = false)
    private Salle salle;

    public Consultation() {}

    public Consultation(LocalDate date, LocalTime heure, String motifConsultation,
                        Patient patient, Docteur docteur, Salle salle) {
        this.date = date;
        this.heure = heure;
        this.motifConsultation = motifConsultation;
        this.statut = StatutConsultation.RESERVEE;
        this.patient = patient;
        this.docteur = docteur;
        this.salle = salle;
    }

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

    public StatutConsultation getStatut() {
        return statut;
    }

    public void setStatut(StatutConsultation statut) {
        this.statut = statut;
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



    public LocalDateTime getDateTimeDebut() {
        return LocalDateTime.of(date, heure);
    }


    public LocalDateTime getDateTimeFin() {
        return getDateTimeDebut().plusMinutes(30);
    }

    @Override
    public String toString() {
        return "Consultation{" +
                "idConsultation=" + idConsultation +
                ", date=" + date +
                ", heure=" + heure +
                ", statut=" + statut +
                ", patient=" + (patient != null ? patient.getNom() : "null") +
                ", docteur=" + (docteur != null ? docteur.getNom() : "null") +
                ", salle=" + (salle != null ? salle.getNomSalle() : "null") +
                '}';
    }
}