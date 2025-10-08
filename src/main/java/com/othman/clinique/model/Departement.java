package com.othman.clinique.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


@Entity
@Table(name = "departement")
public class Departement implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_departement")
    private Long idDepartement;

    @Column(name = "nom", nullable = false, unique = true, length = 100)
    private String nom;

    @OneToMany(mappedBy = "departement", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Docteur> docteurs = new ArrayList<>();

    public Departement() {}

    public Departement(String nom) {
        this.nom = nom;
    }

    public Long getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(Long idDepartement) {
        this.idDepartement = idDepartement;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public List<Docteur> getDocteurs() {
        return docteurs;
    }

    public void setDocteurs(List<Docteur> docteurs) {
        this.docteurs = docteurs;
    }

    public void addDocteur(Docteur docteur) {
        docteurs.add(docteur);
        docteur.setDepartement(this);
    }

    public void removeDocteur(Docteur docteur) {
        docteurs.remove(docteur);
        docteur.setDepartement(null);
    }

    @Override
    public String toString() {
        return "Departement{" +
                "idDepartement=" + idDepartement +
                ", nom='" + nom + '\'' +
                ", nombreDocteurs=" + docteurs.size() +
                '}';
    }
}