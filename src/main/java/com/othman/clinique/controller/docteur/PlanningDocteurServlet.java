package com.othman.clinique.controller.docteur;

import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.Docteur;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.service.DocteurService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet(name = "PlanningDocteurServlet", urlPatterns = {"/docteur/planning"})
public class PlanningDocteurServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PlanningDocteurServlet.class.getName());

    private DocteurService docteurService;

    @Override
    public void init() throws ServletException {
        this.docteurService = new DocteurService();
        LOGGER.info("PlanningDocteurServlet initialisé");
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
            String dateParam = request.getParameter("date");

            LocalDate dateSelectionnee;
            if (dateParam != null && !dateParam.isEmpty()) {
                dateSelectionnee = LocalDate.parse(dateParam);
            } else {
                dateSelectionnee = LocalDate.now();
            }

            // Récupérer le planning pour la date sélectionnée
            List<Consultation> planning = docteurService.getPlanningByDate(docteurId, dateSelectionnee);

            // Récupérer toutes les consultations futures
            List<Consultation> consultationsFutures = docteurService.getConsultationsFutures(docteurId);

            // Statistiques du jour
            long consultationsJour = planning.size();
            long consultationsValidees = planning.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.VALIDEE)
                    .count();
            long consultationsReservees = planning.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.RESERVEE)
                    .count();

            // Semaine courante (7 jours à partir d'aujourd'hui)
            LocalDate debutSemaine = LocalDate.now();
            LocalDate finSemaine = debutSemaine.plusDays(6);

            List<Consultation> consultationsSemaine = consultationsFutures.stream()
                    .filter(c -> !c.getDate().isBefore(debutSemaine) &&
                            !c.getDate().isAfter(finSemaine))
                    .collect(Collectors.toList());

            request.setAttribute("docteur", docteur);
            request.setAttribute("dateSelectionnee", dateSelectionnee);
            request.setAttribute("planning", planning);
            request.setAttribute("consultationsFutures", consultationsFutures);
            request.setAttribute("consultationsSemaine", consultationsSemaine);
            request.setAttribute("consultationsJour", consultationsJour);
            request.setAttribute("consultationsValidees", consultationsValidees);
            request.setAttribute("consultationsReservees", consultationsReservees);

            LOGGER.info("Planning chargé pour docteur ID: " + docteurId +
                    " - Date: " + dateSelectionnee);

            request.getRequestDispatcher("/WEB-INF/views/docteur/planning.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement du planning", e);
            request.setAttribute("error", "Erreur lors du chargement du planning");
            request.getRequestDispatcher("/WEB-INF/views/error/error.jsp")
                    .forward(request, response);
        }
    }
}