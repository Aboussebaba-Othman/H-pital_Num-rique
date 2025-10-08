package com.othman.clinique.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;


@Entity
@Table(name = "patient")
public class Patient extends Personne {

    @Column(name = "poids")
    private Double poids;

    @Column(name = "taille")
    private Double taille;

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Consultation> consultations = new ArrayList<>();

    public Patient() {
        super();
    }

    public Patient(String nom, String prenom, String email, String motDePasse, Double poids, Double taille) {
        super(nom, prenom, email, motDePasse, Role.PATIENT);
        this.poids = poids;
        this.taille = taille;
    }

    public Long getIdPatient() {
        return id;
    }

    public Double getPoids() {
        return poids;
    }

    public void setPoids(Double poids) {
        this.poids = poids;
    }

    public Double getTaille() {
        return taille;
    }

    public void setTaille(Double taille) {
        this.taille = taille;
    }

    public List<Consultation> getConsultations() {
        return consultations;
    }

    public void setConsultations(List<Consultation> consultations) {
        this.consultations = consultations;
    }

    public void addConsultation(Consultation consultation) {
        consultations.add(consultation);
        consultation.setPatient(this);
    }

    public void removeConsultation(Consultation consultation) {
        consultations.remove(consultation);
        consultation.setPatient(null);
    }

    @Override
    public String toString() {
        return "Patient{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", email='" + email + '\'' +
                ", poids=" + poids +
                ", taille=" + taille +
                '}';
    }
}