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
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet(name = "PlanningServlet", urlPatterns = {"/docteur/planning"})
public class PlanningServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PlanningServlet.class.getName());

    private ConsultationService consultationService;
    private DocteurService docteurService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        this.docteurService = new DocteurService();
        LOGGER.info("PlanningServlet initialisé");
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
            // Make docteurId effectively final
            final Long docteurId = docteur.getIdDocteur();

            // Récupérer les paramètres de date (mois/année)
            String monthParam = request.getParameter("month");
            String yearParam = request.getParameter("year");

            // Date par défaut : aujourd'hui
            LocalDate currentDate = LocalDate.now();
            YearMonth tempYearMonth;

            if (monthParam != null && yearParam != null) {
                try {
                    int month = Integer.parseInt(monthParam);
                    int year = Integer.parseInt(yearParam);
                    tempYearMonth = YearMonth.of(year, month);
                } catch (Exception e) {
                    tempYearMonth = YearMonth.from(currentDate);
                }
            } else {
                tempYearMonth = YearMonth.from(currentDate);
            }

            // Make it effectively final for lambda expressions
            final YearMonth yearMonth = tempYearMonth;

            // Récupérer toutes les consultations du docteur
            List<Consultation> toutesConsultations = consultationService.getConsultationsByDocteur(docteurId);

            // Filtrer par mois
            List<Consultation> consultationsDuMois = toutesConsultations.stream()
                    .filter(c -> YearMonth.from(c.getDate()).equals(yearMonth))
                    .sorted(Comparator.comparing(Consultation::getDate)
                            .thenComparing(Consultation::getHeure))
                    .collect(Collectors.toList());

            // Grouper par date
            Map<LocalDate, List<Consultation>> consultationsParDate = consultationsDuMois.stream()
                    .collect(Collectors.groupingBy(Consultation::getDate));

            // Calculer les statistiques du mois
            long reservees = consultationsDuMois.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.RESERVEE)
                    .count();

            long validees = consultationsDuMois.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.VALIDEE)
                    .count();

            long terminees = consultationsDuMois.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                    .count();

            long annulees = consultationsDuMois.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.ANNULEE)
                    .count();

            // Calculer les informations du calendrier
            LocalDate premierJourDuMois = yearMonth.atDay(1);
            int jourDeLaSemaine = premierJourDuMois.getDayOfWeek().getValue(); // 1 = Lundi, 7 = Dimanche
            int nombreDeJours = yearMonth.lengthOfMonth();

            // Mois précédent et suivant
            YearMonth moisPrecedent = yearMonth.minusMonths(1);
            YearMonth moisSuivant = yearMonth.plusMonths(1);

            // Formatter pour l'affichage
            DateTimeFormatter monthFormatter = DateTimeFormatter.ofPattern("MMMM yyyy", Locale.FRENCH);

            request.setAttribute("docteur", docteur);
            request.setAttribute("currentDate", currentDate);
            request.setAttribute("yearMonth", yearMonth);
            request.setAttribute("monthName", yearMonth.format(monthFormatter));
            request.setAttribute("premierJourSemaine", jourDeLaSemaine);
            request.setAttribute("nombreDeJours", nombreDeJours);
            request.setAttribute("consultationsParDate", consultationsParDate);
            request.setAttribute("consultationsDuMois", consultationsDuMois);

            // Navigation
            request.setAttribute("moisPrecedent", moisPrecedent.getMonthValue());
            request.setAttribute("anneePrecedente", moisPrecedent.getYear());
            request.setAttribute("moisSuivant", moisSuivant.getMonthValue());
            request.setAttribute("anneeSuivante", moisSuivant.getYear());

            // Statistiques
            request.setAttribute("totalConsultations", consultationsDuMois.size());
            request.setAttribute("reservees", reservees);
            request.setAttribute("validees", validees);
            request.setAttribute("terminees", terminees);
            request.setAttribute("annulees", annulees);

            LOGGER.info("Planning chargé pour docteur ID: " + docteurId +
                    ", Mois: " + yearMonth + ", Total: " + consultationsDuMois.size());

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