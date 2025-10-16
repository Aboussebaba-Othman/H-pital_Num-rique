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
import java.time.LocalDate;
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
            Long patientId = patient.getIdPatient();

            // Récupérer l'historique complet
            List<Consultation> historique = consultationService.getHistoriquePatient(patientId);

            // Paramètres de filtrage
            String anneeStr = request.getParameter("annee");
            String docteurIdStr = request.getParameter("docteurId");

            // Filtrer par année si spécifié
            if (anneeStr != null && !anneeStr.isEmpty()) {
                int annee = Integer.parseInt(anneeStr);
                historique = historique.stream()
                        .filter(c -> c.getDate().getYear() == annee)
                        .collect(Collectors.toList());
                request.setAttribute("anneeFiltre", annee);
            }

            // Filtrer par docteur si spécifié
            if (docteurIdStr != null && !docteurIdStr.isEmpty()) {
                Long docteurId = Long.parseLong(docteurIdStr);
                historique = historique.stream()
                        .filter(c -> c.getDocteur().getIdDocteur().equals(docteurId))
                        .collect(Collectors.toList());
                request.setAttribute("docteurIdFiltre", docteurId);
            }

            // Statistiques
            long consultationsTerminees = historique.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                    .count();

            long consultationsAnnulees = historique.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.ANNULEE)
                    .count();

            // Années disponibles pour le filtre
            List<Integer> anneesDisponibles = historique.stream()
                    .map(c -> c.getDate().getYear())
                    .distinct()
                    .sorted((a, b) -> b - a)
                    .collect(Collectors.toList());

            request.setAttribute("historique", historique);
            request.setAttribute("consultationsTerminees", consultationsTerminees);
            request.setAttribute("consultationsAnnulees", consultationsAnnulees);
            request.setAttribute("anneesDisponibles", anneesDisponibles);

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