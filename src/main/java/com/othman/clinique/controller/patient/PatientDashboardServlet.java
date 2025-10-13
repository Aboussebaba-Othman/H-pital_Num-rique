package com.othman.clinique.controller.patient;

import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.Patient;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.service.ConsultationService;
import com.othman.clinique.service.PatientService;

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

@WebServlet(name = "PatientDashboardServlet", urlPatterns = {"/patient/dashboard"})
public class PatientDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PatientDashboardServlet.class.getName());

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        PatientService patientService = new PatientService();
        LOGGER.info("PatientDashboardServlet initialisé");
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

            List<Consultation> toutesConsultations = consultationService.getConsultationsByPatient(patientId);

            List<Consultation> consultationsAvenir = toutesConsultations.stream()
                    .filter(c -> (c.getStatut() == StatutConsultation.RESERVEE ||
                            c.getStatut() == StatutConsultation.VALIDEE) &&
                            c.getDate().isAfter(LocalDate.now().minusDays(1)))
                    .sorted(Comparator.comparing(Consultation::getDate).thenComparing(Consultation::getHeure))
                    .collect(Collectors.toList());

            List<Consultation> consultationsEnAttente = toutesConsultations.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.RESERVEE)
                    .collect(Collectors.toList());

            long consultationsTerminees = toutesConsultations.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                    .count();

            Consultation prochaineConsultation = consultationsAvenir.isEmpty()
                    ? null
                    : consultationsAvenir.get(0);

            request.setAttribute("totalConsultations", toutesConsultations.size());
            request.setAttribute("consultationsAvenir", consultationsAvenir);
            request.setAttribute("consultationsEnAttente", consultationsEnAttente);
            request.setAttribute("nombreConsultationsTerminees", consultationsTerminees);
            request.setAttribute("prochaineConsultation", prochaineConsultation);
            request.setAttribute("patient", patient);

            LOGGER.info("Dashboard chargé pour patient ID: " + patientId);

            request.getRequestDispatcher("/WEB-INF/views/patient/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement du dashboard patient", e);
            request.setAttribute("error", "Erreur lors du chargement du dashboard");
            request.getRequestDispatcher("/WEB-INF/views/error/error.jsp")
                    .forward(request, response);
        }
    }
}