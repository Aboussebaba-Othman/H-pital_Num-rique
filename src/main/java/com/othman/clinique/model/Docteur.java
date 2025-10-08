package com.othman.clinique.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "docteur")
public class Docteur extends Personne {

    @Column(name = "specialite", nullable = false, length = 100)
    private String specialite;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "departement_id", nullable = false)
    private Departement departement;

    @OneToMany(mappedBy = "docteur", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Consultation> planning = new ArrayList<>();

    public Docteur() {
        super();
    }

    public Docteur(String nom, String prenom, String email, String motDePasse, String specialite, Departement departement) {
        super(nom, prenom, email, motDePasse, Role.DOCTEUR);
        this.specialite = specialite;
        this.departement = departement;
    }

    public Long getIdDocteur() {
        return id;
    }

    public String getSpecialite() {
        return specialite;
    }

    public void setSpecialite(String specialite) {
        this.specialite = specialite;
    }

    public Departement getDepartement() {
        return departement;
    }

    public void setDepartement(Departement departement) {
        this.departement = departement;
    }

    public List<Consultation> getPlanning() {
        return planning;
    }

    public void setPlanning(List<Consultation> planning) {
        this.planning = planning;
    }

    public void addConsultation(Consultation consultation) {
        planning.add(consultation);
        consultation.setDocteur(this);
    }

    public void removeConsultation(Consultation consultation) {
        planning.remove(consultation);
        consultation.setDocteur(null);
    }

    @Override
    public String toString() {
        return "Docteur{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", email='" + email + '\'' +
                ", specialite='" + specialite + '\'' +
                ", departement=" + (departement != null ? departement.getNom() : "null") +
                '}';
    }
}