package com.othman.clinique.controller.patient;

import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.Patient;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.service.ConsultationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet(name = "HistoriquePatientServlet", urlPatterns = {"/patient/historique"})
public class HistoriquePatientServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(HistoriquePatientServlet.class.getName());

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        LOGGER.info("HistoriquePatientServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("userConnecte");

        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Long patientId = patient.getId();

            // Récupérer l'historique complet (avec FETCH joins)
            List<Consultation> historique = consultationService.getHistoriquePatient(patientId);

            // Paramètres de filtrage
            String anneeStr = request.getParameter("annee");
            String docteurIdStr = request.getParameter("docteurId");

            // Filtrer par année si spécifié
            if (anneeStr != null && !anneeStr.isEmpty()) {
                try {
                    int annee = Integer.parseInt(anneeStr);
                    historique = historique.stream()
                            .filter(c -> c.getDate() != null && c.getDate().getYear() == annee)
                            .collect(Collectors.toList());
                    request.setAttribute("anneeFiltre", annee);
                } catch (NumberFormatException e) {
                    LOGGER.warning("Année invalide: " + anneeStr);
                }
            }

            // Filtrer par docteur si spécifié
            if (docteurIdStr != null && !docteurIdStr.isEmpty()) {
                try {
                    Long docteurId = Long.parseLong(docteurIdStr);
                    historique = historique.stream()
                            .filter(c -> c.getDocteur() != null &&
                                    c.getDocteur().getIdDocteur() != null &&
                                    c.getDocteur().getIdDocteur().equals(docteurId))
                            .collect(Collectors.toList());
                    request.setAttribute("docteurIdFiltre", docteurId);
                } catch (NumberFormatException e) {
                    LOGGER.warning("ID docteur invalide: " + docteurIdStr);
                }
            }

            // Statistiques
            long consultationsTerminees = historique.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                    .count();

            long consultationsAnnulees = historique.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.ANNULEE)
                    .count();

            long consultationsValidees = historique.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.VALIDEE)
                    .count();

            // Statistiques par docteur
            java.util.Map<String, Long> consultationsParDocteur = historique.stream()
                    .filter(c -> c.getDocteur() != null)
                    .collect(Collectors.groupingBy(
                            c -> "Dr. " + c.getDocteur().getPrenom() + " " + c.getDocteur().getNom(),
                            Collectors.counting()
                    ));

            // Statistiques par spécialité
            java.util.Map<String, Long> consultationsParSpecialite = historique.stream()
                    .filter(c -> c.getDocteur() != null && c.getDocteur().getSpecialite() != null)
                    .collect(Collectors.groupingBy(
                            c -> c.getDocteur().getSpecialite(),
                            Collectors.counting()
                    ));

            // Statistiques par mois (format: "YYYY-MM" -> "Janvier 2025")
            java.util.Map<String, Long> consultationsParMois = historique.stream()
                    .filter(c -> c.getDate() != null)
                    .collect(Collectors.groupingBy(
                            c -> {
                                int mois = c.getDate().getMonthValue();
                                int annee = c.getDate().getYear();
                                String[] nomsMois = {"Jan", "Fév", "Mar", "Avr", "Mai", "Juin", 
                                                     "Juil", "Août", "Sep", "Oct", "Nov", "Déc"};
                                return nomsMois[mois - 1] + " " + annee;
                            },
                            Collectors.counting()
                    ));

            // Années disponibles pour le filtre
            List<Integer> anneesDisponibles = historique.stream()
                    .map(c -> c.getDate())
                    .filter(date -> date != null)
                    .map(date -> date.getYear())
                    .distinct()
                    .sorted((a, b) -> b - a)
                    .collect(Collectors.toList());

            // Liste des docteurs consultés
            List<com.othman.clinique.model.Docteur> docteursConsultes = historique.stream()
                    .map(Consultation::getDocteur)
                    .filter(d -> d != null)
                    .distinct()
                    .collect(Collectors.toList());

            request.setAttribute("historique", historique);
            request.setAttribute("consultationsTerminees", consultationsTerminees);
            request.setAttribute("consultationsAnnulees", consultationsAnnulees);
            request.setAttribute("consultationsValidees", consultationsValidees);
            request.setAttribute("consultationsParDocteur", consultationsParDocteur);
            request.setAttribute("consultationsParSpecialite", consultationsParSpecialite);
            request.setAttribute("consultationsParMois", consultationsParMois);
            request.setAttribute("anneesDisponibles", anneesDisponibles);
            request.setAttribute("docteursConsultes", docteursConsultes);

            LOGGER.info("Historique chargé pour patient ID: " + patientId +
                    " - " + historique.size() + " consultations");

            request.getRequestDispatcher("/WEB-INF/views/patient/historique.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement de l'historique", e);
            request.setAttribute("error", "Erreur lors du chargement de l'historique");
            request.getRequestDispatcher("/WEB-INF/views/error/error.jsp")
                    .forward(request, response);
        }
    }
}