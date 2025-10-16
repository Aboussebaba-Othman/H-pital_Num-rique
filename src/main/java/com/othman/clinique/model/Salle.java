package com.othman.clinique.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

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

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "salle_creneaux_occupes", joinColumns = @JoinColumn(name = "salle_id"))
    @Column(name = "creneau")
    private List<LocalDateTime> creneauxOccupes = new ArrayList<>();

    @OneToMany(mappedBy = "salle", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Consultation> consultations = new ArrayList<>();

    public Salle() {
        this.creneauxOccupes = new ArrayList<>();
    }

    public Salle(String nomSalle, Integer capacite) {
        this.nomSalle = nomSalle;
        this.capacite = capacite;
        this.creneauxOccupes = new ArrayList<>();
    }

    // ==================== GETTERS & SETTERS ====================

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
        if (creneauxOccupes == null) {
            creneauxOccupes = new ArrayList<>();
        }
        return creneauxOccupes;
    }

    public void setCreneauxOccupes(List<LocalDateTime> creneauxOccupes) {
        this.creneauxOccupes = creneauxOccupes != null ? creneauxOccupes : new ArrayList<>();
    }

    public List<Consultation> getConsultations() {
        if (consultations == null) {
            consultations = new ArrayList<>();
        }
        return consultations;
    }

    public void setConsultations(List<Consultation> consultations) {
        this.consultations = consultations;
    }

    // ==================== GESTION DES CRÉNEAUX ====================

    /**
     * Réserve un créneau pour cette salle
     */
    public void reserverCreneau(LocalDateTime dateTime) {
        if (dateTime == null) {
            throw new IllegalArgumentException("La date/heure ne peut pas être null");
        }

        // S'assurer que la liste est initialisée
        if (this.creneauxOccupes == null) {
            this.creneauxOccupes = new ArrayList<>();
        }

        // Vérifier si le créneau est déjà occupé
        boolean dejaOccupe = this.creneauxOccupes.stream()
                .anyMatch(creneau -> creneau.equals(dateTime));

        if (dejaOccupe) {
            throw new IllegalStateException(
                    "Le créneau " + dateTime + " est déjà réservé"
            );
        }

        // Ajouter le créneau
        this.creneauxOccupes.add(dateTime);
    }

    /**
     * Libère un créneau de cette salle
     */
    public void libererCreneau(LocalDateTime dateTime) {
        if (dateTime == null || this.creneauxOccupes == null) {
            return;
        }

        // Retirer le créneau s'il existe
        this.creneauxOccupes.removeIf(creneau -> creneau.equals(dateTime));
    }

    /**
     * Vérifie si la salle est disponible à un créneau donné
     */
    public boolean isDisponible(LocalDateTime dateTime) {
        if (dateTime == null) {
            return false;
        }

        if (this.creneauxOccupes == null || this.creneauxOccupes.isEmpty()) {
            return true;
        }

        // Vérifier si le créneau n'est pas dans la liste
        return this.creneauxOccupes.stream()
                .noneMatch(creneau -> creneau.equals(dateTime));
    }

    /**
     * Retourne tous les créneaux occupés pour une date donnée
     */
    public List<LocalDateTime> getCreneauxOccupesForDate(LocalDate date) {
        if (date == null || creneauxOccupes == null) {
            return new ArrayList<>();
        }

        return creneauxOccupes.stream()
                .filter(creneau -> creneau.toLocalDate().equals(date))
                .collect(Collectors.toList());
    }

    /**
     * Compte le nombre de créneaux occupés pour une date donnée
     */
    public long countCreneauxOccupesForDate(LocalDate date) {
        if (date == null || creneauxOccupes == null) {
            return 0;
        }

        return creneauxOccupes.stream()
                .filter(creneau -> creneau.toLocalDate().equals(date))
                .count();
    }

    @Override
    public String toString() {
        return "Salle{" +
                "idSalle=" + idSalle +
                ", nomSalle='" + nomSalle + '\'' +
                ", capacite=" + capacite +
                ", creneauxOccupes=" + (creneauxOccupes != null ? creneauxOccupes.size() : 0) +
                '}';
    }
}