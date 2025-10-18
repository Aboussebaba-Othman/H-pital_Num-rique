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

            // Recharger le docteur avec ses relations pour éviter LazyInitializationException
            Docteur docteurComplet = docteurService.getDocteurById(docteurId);
            
            // Récupérer le planning complet (avec FETCH joins) - seulement futures RESERVEE/VALIDEE
            List<Consultation> planning = consultationService.getPlanningDocteur(docteurId);
            
            // Récupérer TOUTES les consultations pour les stats
            List<Consultation> toutesConsultations = consultationService.getConsultationsByDocteur(docteurId);

            // Consultations en attente de validation
            List<Consultation> consultationsEnAttente = planning.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.RESERVEE)
                    .sorted(Comparator.comparing(Consultation::getDate)
                            .thenComparing(Consultation::getHeure))
                    .collect(Collectors.toList());

            // Consultations d'aujourd'hui
            LocalDate aujourdhui = LocalDate.now();
            List<Consultation> consultationsAujourdhui = planning.stream()
                    .filter(c -> c.getDate().equals(aujourdhui))
                    .filter(c -> c.getStatut() == StatutConsultation.VALIDEE ||
                            c.getStatut() == StatutConsultation.RESERVEE)
                    .sorted(Comparator.comparing(Consultation::getHeure))
                    .collect(Collectors.toList());

            // Consultations validées à venir
            List<Consultation> consultationsValidees = planning.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.VALIDEE)
                    .filter(c -> c.getDate().isAfter(aujourdhui) ||
                            c.getDate().equals(aujourdhui))
                    .sorted(Comparator.comparing(Consultation::getDate)
                            .thenComparing(Consultation::getHeure))
                    .collect(Collectors.toList());

            // Statistiques basées sur TOUTES les consultations
            long totalConsultations = toutesConsultations.size();
            long consultationsTerminees = toutesConsultations.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                    .count();

            // Prochaine consultation
            Consultation prochaineConsultation = consultationsValidees.isEmpty()
                    ? null
                    : consultationsValidees.get(0);

            request.setAttribute("docteur", docteurComplet);
            request.setAttribute("totalConsultations", totalConsultations);
            request.setAttribute("consultationsEnAttente", consultationsEnAttente);
            request.setAttribute("consultationsAujourdhui", consultationsAujourdhui);
            request.setAttribute("consultationsDuJour", consultationsAujourdhui); // Alias pour la JSP
            request.setAttribute("consultationsValidees", consultationsValidees);
            request.setAttribute("consultationsTerminees", consultationsTerminees);
            request.setAttribute("prochaineConsultation", prochaineConsultation);

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