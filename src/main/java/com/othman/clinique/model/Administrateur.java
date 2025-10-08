package com.othman.clinique.model;

import jakarta.persistence.*;


@Entity
@Table(name = "administrateur")
public class Administrateur extends Personne {

    public Administrateur() {
        super();
    }

    public Administrateur(String nom, String prenom, String email, String motDePasse) {
        super(nom, prenom, email, motDePasse, Role.ADMIN);
    }

    public Long getIdAdmin() {
        return id;
    }

    @Override
    public String toString() {
        return "Administrateur{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", email='" + email + '\'' +
                ", role=" + role +
                '}';
    }
}