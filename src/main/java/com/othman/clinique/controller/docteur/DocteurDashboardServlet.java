package com.othman.clinique.controller.docteur;

import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.Docteur;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.service.ConsultationService;
import com.othman.clinique.service.DocteurService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 * Dashboard Docteur
 * Affiche le planning et les consultations en attente
 *
 * @author Othman
 * @version 1.0
 */
@WebServlet(name = "DocteurDashboardServlet", urlPatterns = {"/docteur/dashboard"})
public class DocteurDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DocteurDashboardServlet.class.getName());

    private ConsultationService consultationService;
    private DocteurService docteurService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        this.docteurService = new DocteurService();
        LOGGER.info("DocteurDashboardServlet initialisé");
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

            // Récupérer le planning complet
            List<Consultation> planningComplet = consultationService.getPlanningDocteur(docteurId);

            // Consultations du jour
            LocalDate aujourdhui = LocalDate.now();
            List<Consultation> consultationsDuJour = planningComplet.stream()
                    .filter(c -> c.getDate().equals(aujourdhui))
                    .sorted((c1, c2) -> c1.getHeure().compareTo(c2.getHeure()))
                    .collect(Collectors.toList());

            // Consultations en attente de validation
            List<Consultation> consultationsEnAttente = planningComplet.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.RESERVEE)
                    .sorted((c1, c2) -> {
                        int dateComp = c1.getDate().compareTo(c2.getDate());
                        return dateComp != 0 ? dateComp : c1.getHeure().compareTo(c2.getHeure());
                    })
                    .collect(Collectors.toList());

            // Consultations validées à venir
            List<Consultation> consultationsValidees = planningComplet.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.VALIDEE)
                    .sorted(Comparator.comparing(Consultation::getDate).thenComparing(Consultation::getHeure))
                    .collect(Collectors.toList());

            // Prochaine consultation
            Consultation prochaineConsultation = consultationsValidees.isEmpty()
                    ? null
                    : consultationsValidees.get(0);

            // Statistiques
            request.setAttribute("totalConsultations", planningComplet.size());
            request.setAttribute("consultationsDuJour", consultationsDuJour);
            request.setAttribute("consultationsEnAttente", consultationsEnAttente);
            request.setAttribute("consultationsValidees", consultationsValidees);
            request.setAttribute("prochaineConsultation", prochaineConsultation);
            request.setAttribute("docteur", docteur);

            LOGGER.info("Dashboard chargé pour docteur ID: " + docteurId);

            request.getRequestDispatcher("/WEB-INF/views/docteur/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement du dashboard docteur", e);
            request.setAttribute("error", "Erreur lors du chargement du dashboard");
            request.getRequestDispatcher("/WEB-INF/views/error/error.jsp")
                    .forward(request, response);
        }
    }
}