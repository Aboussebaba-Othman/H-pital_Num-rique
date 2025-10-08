package com.othman.clinique.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "salle")
public class Salle implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_salle")
    private Long idSalle;

    @Column(name = "nom_salle", nullable = false, unique = true, length = 50)
    private String nomSalle;

    @Column(name = "capacite")
    private Integer capacite;

    @ElementCollection
    @CollectionTable(name = "salle_creneaux_occupes", joinColumns = @JoinColumn(name = "salle_id"))
    @Column(name = "creneau")
    private List<LocalDateTime> creneauxOccupes = new ArrayList<>();

    @OneToMany(mappedBy = "salle", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Consultation> consultations = new ArrayList<>();

    public Salle() {}

    public Salle(String nomSalle, Integer capacite) {
        this.nomSalle = nomSalle;
        this.capacite = capacite;
    }

    public Long getIdSalle() {
        return idSalle;
    }

    public void setIdSalle(Long idSalle) {
        this.idSalle = idSalle;
    }

    public String getNomSalle() {
        return nomSalle;
    }

    public void setNomSalle(String nomSalle) {
        this.nomSalle = nomSalle;
    }

    public Integer getCapacite() {
        return capacite;
    }

    public void setCapacite(Integer capacite) {
        this.capacite = capacite;
    }

    public List<LocalDateTime> getCreneauxOccupes() {
        return creneauxOccupes;
    }

    public void setCreneauxOccupes(List<LocalDateTime> creneauxOccupes) {
        this.creneauxOccupes = creneauxOccupes;
    }

    public List<Consultation> getConsultations() {
        return consultations;
    }

    public void setConsultations(List<Consultation> consultations) {
        this.consultations = consultations;
    }



    public boolean isDisponible(LocalDateTime dateTime) {
        return !creneauxOccupes.contains(dateTime);
    }


    public void reserverCreneau(LocalDateTime dateTime) {
        if (!creneauxOccupes.contains(dateTime)) {
            creneauxOccupes.add(dateTime);
        }
    }


    public void libererCreneau(LocalDateTime dateTime) {
        creneauxOccupes.remove(dateTime);
    }

    @Override
    public String toString() {
        return "Salle{" +
                "idSalle=" + idSalle +
                ", nomSalle='" + nomSalle + '\'' +
                ", capacite=" + capacite +
                ", creneauxOccupes=" + creneauxOccupes.size() +
                '}';
    }
}