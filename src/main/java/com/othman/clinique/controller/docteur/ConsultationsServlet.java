package com.othman.clinique.controller.docteur;

import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.Docteur;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.service.ConsultationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Comparator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet(name = "ConsultationsServlet", urlPatterns = {"/docteur/consultations"})
public class ConsultationsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ConsultationsServlet.class.getName());

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        LOGGER.info("ConsultationsServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Docteur docteur = (Docteur) session.getAttribute("userConnecte");

        if (docteur == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Long docteurId = docteur.getIdDocteur();

            // Récupérer les paramètres de filtre
            String statutParam = request.getParameter("statut");
            String dateDebutParam = request.getParameter("dateDebut");
            String dateFinParam = request.getParameter("dateFin");
            String searchParam = request.getParameter("search");
            String sortParam = request.getParameter("sort");

            // Récupérer toutes les consultations du docteur
            List<Consultation> toutesConsultations = consultationService.getConsultationsByDocteur(docteurId);

            // Appliquer les filtres
            List<Consultation> consultationsFiltrees = toutesConsultations.stream()
                    .filter(c -> applyStatutFilter(c, statutParam))
                    .filter(c -> applyDateFilter(c, dateDebutParam, dateFinParam))
                    .filter(c -> applySearchFilter(c, searchParam))
                    .collect(Collectors.toList());

            // Appliquer le tri
            consultationsFiltrees = applySorting(consultationsFiltrees, sortParam);

            // Calculer les statistiques
            long totalConsultations = consultationsFiltrees.size();
            long reservees = consultationsFiltrees.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.RESERVEE)
                    .count();
            long validees = consultationsFiltrees.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.VALIDEE)
                    .count();
            long terminees = consultationsFiltrees.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                    .count();
            long annulees = consultationsFiltrees.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.ANNULEE)
                    .count();

            // Passer les données à la JSP
            request.setAttribute("docteur", docteur);
            request.setAttribute("consultations", consultationsFiltrees);
            request.setAttribute("totalConsultations", totalConsultations);
            request.setAttribute("reservees", reservees);
            request.setAttribute("validees", validees);
            request.setAttribute("terminees", terminees);
            request.setAttribute("annulees", annulees);

            // Conserver les filtres pour l'affichage
            request.setAttribute("filtreStatut", statutParam);
            request.setAttribute("filtreDateDebut", dateDebutParam);
            request.setAttribute("filtreDateFin", dateFinParam);
            request.setAttribute("filtreSearch", searchParam);
            request.setAttribute("filtreSort", sortParam);

            LOGGER.info("Consultations chargées pour docteur ID: " + docteurId +
                    ", Total: " + totalConsultations +
                    ", Filtres appliqués: statut=" + statutParam +
                    ", dateDebut=" + dateDebutParam +
                    ", dateFin=" + dateFinParam +
                    ", search=" + searchParam);

            request.getRequestDispatcher("/WEB-INF/views/docteur/consultations.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement des consultations", e);
            request.setAttribute("error", "Erreur lors du chargement des consultations");
            request.getRequestDispatcher("/WEB-INF/views/error/error.jsp")
                    .forward(request, response);
        }
    }

    // Filtre par statut
    private boolean applyStatutFilter(Consultation consultation, String statutParam) {
        if (statutParam == null || statutParam.trim().isEmpty() || statutParam.equals("TOUS")) {
            return true;
        }

        try {
            StatutConsultation statut = StatutConsultation.valueOf(statutParam);
            return consultation.getStatut() == statut;
        } catch (IllegalArgumentException e) {
            LOGGER.warning("Statut invalide: " + statutParam);
            return true;
        }
    }

    // Filtre par date
    private boolean applyDateFilter(Consultation consultation, String dateDebutParam, String dateFinParam) {
        try {
            LocalDate dateConsultation = consultation.getDate();

            if (dateDebutParam != null && !dateDebutParam.trim().isEmpty()) {
                LocalDate dateDebut = LocalDate.parse(dateDebutParam);
                if (dateConsultation.isBefore(dateDebut)) {
                    return false;
                }
            }

            if (dateFinParam != null && !dateFinParam.trim().isEmpty()) {
                LocalDate dateFin = LocalDate.parse(dateFinParam);
                if (dateConsultation.isAfter(dateFin)) {
                    return false;
                }
            }

            return true;
        } catch (DateTimeParseException e) {
            LOGGER.warning("Format de date invalide");
            return true;
        }
    }

    // Filtre par recherche textuelle
    private boolean applySearchFilter(Consultation consultation, String searchParam) {
        if (searchParam == null || searchParam.trim().isEmpty()) {
            return true;
        }

        String search = searchParam.toLowerCase().trim();

        // Recherche dans le nom du patient
        String nomPatient = (consultation.getPatient().getNom() + " " +
                consultation.getPatient().getPrenom()).toLowerCase();
        if (nomPatient.contains(search)) {
            return true;
        }

        // Recherche dans le motif
        String motif = consultation.getMotifConsultation().toLowerCase();
        if (motif.contains(search)) {
            return true;
        }

        // Recherche dans la salle
        String salle = consultation.getSalle().getNomSalle().toLowerCase();
        if (salle.contains(search)) {
            return true;
        }

        return false;
    }

    // Tri des consultations
    private List<Consultation> applySorting(List<Consultation> consultations, String sortParam) {
        if (sortParam == null || sortParam.trim().isEmpty()) {
            sortParam = "date_desc"; // Tri par défaut
        }

        switch (sortParam) {
            case "date_asc":
                return consultations.stream()
                        .sorted(Comparator.comparing(Consultation::getDate)
                                .thenComparing(Consultation::getHeure))
                        .collect(Collectors.toList());

            case "date_desc":
                return consultations.stream()
                        .sorted(Comparator.comparing(Consultation::getDate)
                                .thenComparing(Consultation::getHeure)
                                .reversed())
                        .collect(Collectors.toList());

            case "patient_asc":
                return consultations.stream()
                        .sorted(Comparator.comparing(c -> c.getPatient().getNom()))
                        .collect(Collectors.toList());

            case "patient_desc":
                return consultations.stream()
                        .sorted(Comparator.comparing((Consultation c) -> c.getPatient().getNom())
                                .reversed())
                        .collect(Collectors.toList());

            case "statut_asc":
                return consultations.stream()
                        .sorted(Comparator.comparing(c -> c.getStatut().toString()))
                        .collect(Collectors.toList());

            case "statut_desc":
                return consultations.stream()
                        .sorted(Comparator.comparing((Consultation c) -> c.getStatut().toString())
                                .reversed())
                        .collect(Collectors.toList());

            default:
                return consultations.stream()
                        .sorted(Comparator.comparing(Consultation::getDate)
                                .thenComparing(Consultation::getHeure)
                                .reversed())
                        .collect(Collectors.toList());
        }
    }
}