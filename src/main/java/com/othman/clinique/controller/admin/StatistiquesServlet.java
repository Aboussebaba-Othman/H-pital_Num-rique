package com.othman.clinique.controller.admin;

import com.othman.clinique.model.*;
import com.othman.clinique.service.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;


@WebServlet(name = "StatistiquesServlet", urlPatterns = {"/admin/statistiques"})
public class StatistiquesServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(StatistiquesServlet.class.getName());

    private ConsultationService consultationService;
    private DocteurService docteurService;
    private PatientService patientService;
    private DepartementService departementService;
    private SalleService salleService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        this.docteurService = new DocteurService();
        this.patientService = new PatientService();
        this.departementService = new DepartementService();
        this.salleService = new SalleService();
        LOGGER.info("StatistiquesServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long totalPatients = patientService.countPatients();
            Long totalDocteurs = docteurService.countDocteurs();
            Long totalDepartements = departementService.countDepartements();
            Long totalSalles = salleService.countSalles();

            List<Consultation> consultations = consultationService.getAllConsultations();

            long totalConsultations = consultations.size();
            long reservees = consultations.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.RESERVEE)
                    .count();
            long validees = consultations.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.VALIDEE)
                    .count();
            long terminees = consultations.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                    .count();
            long annulees = consultations.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.ANNULEE)
                    .count();

            double tauxAnnulation = totalConsultations > 0
                    ? (annulees * 100.0 / totalConsultations)
                    : 0.0;

            List<Docteur> docteurs = docteurService.getAllDocteurs();
            Map<String, Long> docteursStats = new HashMap<>();

            for (Docteur doc : docteurs) {
                long count = consultations.stream()
                        .filter(c -> c.getDocteur().getIdDocteur().equals(doc.getIdDocteur()))
                        .filter(c -> c.getStatut() != StatutConsultation.ANNULEE)
                        .count();
                docteursStats.put("Dr. " + doc.getNom() + " " + doc.getPrenom(), count);
            }

            List<Map.Entry<String, Long>> topDocteurs = docteursStats.entrySet().stream()
                    .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
                    .limit(5)
                    .collect(Collectors.toList());

            // Statistiques par département
            List<Departement> departements = departementService.getAllDepartements();
            Map<String, Integer> departementStats = new HashMap<>();

            for (Departement dept : departements) {
                int count = departementService.countDocteursInDepartement(dept.getIdDepartement());
                departementStats.put(dept.getNom(), count);
            }

            // Consultations par mois (6 derniers mois)
            Map<String, Long> consultationsParMois = new LinkedHashMap<>();
            YearMonth currentMonth = YearMonth.now();

            for (int i = 5; i >= 0; i--) {
                YearMonth month = currentMonth.minusMonths(i);
                LocalDate startDate = month.atDay(1);
                LocalDate endDate = month.atEndOfMonth();

                long count = consultations.stream()
                        .filter(c -> !c.getDate().isBefore(startDate) && !c.getDate().isAfter(endDate))
                        .filter(c -> c.getStatut() != StatutConsultation.ANNULEE)
                        .count();

                String monthLabel = month.getMonth().toString().substring(0, 3) + " " + month.getYear();
                consultationsParMois.put(monthLabel, count);
            }

            List<Salle> salles = salleService.getAllSalles();
            double tauxOccupationMoyen = 0.0;

            if (!salles.isEmpty()) {
                LocalDate today = LocalDate.now();
                double totalTaux = 0.0;

                for (Salle salle : salles) {
                    totalTaux += salleService.getTauxOccupation(salle.getIdSalle(), today);
                }

                tauxOccupationMoyen = totalTaux / salles.size();
            }

            // Répartition des consultations par statut (pour graphique)
            Map<String, Long> repartitionStatuts = new LinkedHashMap<>();
            repartitionStatuts.put("Réservées", reservees);
            repartitionStatuts.put("Validées", validees);
            repartitionStatuts.put("Terminées", terminees);
            repartitionStatuts.put("Annulées", annulees);

            // Passer les données à la JSP
            request.setAttribute("totalPatients", totalPatients);
            request.setAttribute("totalDocteurs", totalDocteurs);
            request.setAttribute("totalDepartements", totalDepartements);
            request.setAttribute("totalSalles", totalSalles);
            request.setAttribute("totalConsultations", totalConsultations);
            request.setAttribute("reservees", reservees);
            request.setAttribute("validees", validees);
            request.setAttribute("terminees", terminees);
            request.setAttribute("annulees", annulees);
            request.setAttribute("tauxAnnulation", Math.round(tauxAnnulation * 10.0) / 10.0);
            request.setAttribute("topDocteurs", topDocteurs);
            request.setAttribute("departementStats", departementStats);
            request.setAttribute("consultationsParMois", consultationsParMois);
            request.setAttribute("tauxOccupationMoyen", Math.round(tauxOccupationMoyen * 10.0) / 10.0);
            request.setAttribute("repartitionStatuts", repartitionStatuts);

            LOGGER.info("Statistiques calculées et chargées");

            request.getRequestDispatcher("/WEB-INF/views/admin/statistiques.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du calcul des statistiques", e);
            request.setAttribute("error", "Erreur lors du chargement des statistiques");
            request.getRequestDispatcher("/WEB-INF/views/admin/statistiques.jsp")
                    .forward(request, response);
        }
    }
}