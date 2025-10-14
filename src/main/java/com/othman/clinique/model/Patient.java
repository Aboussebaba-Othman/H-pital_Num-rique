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

    @Transient
    private Double imc;

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

    public Double getImc() {
        return imc;
    }

    public void setImc(Double imc) {
        this.imc = imc;
    }

    public Double calculateImc() {
        if (poids != null && taille != null && taille > 0) {
            this.imc = Math.round((poids / (taille * taille)) * 10.0) / 10.0;
            return this.imc;
        }
        return null;
    }

    public String getImcCategory() {
        if (imc == null) return "Non calculé";

        if (imc < 18.5) return "Insuffisance pondérale";
        if (imc < 25) return "Poids normal";
        if (imc < 30) return "Surpoids";
        if (imc < 35) return "Obésité modérée";
        if (imc < 40) return "Obésité sévère";
        return "Obésité morbide";
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
                ", imc=" + imc +
                '}';
    }
}