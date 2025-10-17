package com.othman.clinique.controller.patient;

import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.Patient;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.service.ConsultationService;

import com.othman.clinique.util.JPAUtil;
import jakarta.persistence.EntityManager;
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

@WebServlet(name = "PatientDashboardServlet", urlPatterns = {"/patient/dashboard"})
public class PatientDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PatientDashboardServlet.class.getName());

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        LOGGER.info("PatientDashboardServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Patient patient = (Patient) session.getAttribute("userConnecte");

        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Long patientId = patient.getId();
            
            // Récupérer les statistiques simples
            List<Consultation> toutesConsultations;
            EntityManager em = JPAUtil.getEntityManager();
            try {
                toutesConsultations = em.createQuery(
                        "SELECT c FROM Consultation c WHERE c.patient.id = :patientId",
                        Consultation.class)
                    .setParameter("patientId", patientId)
                    .getResultList();
            } finally {
                em.close();
            }

            // Récupérer la prochaine consultation AVEC les détails
            Consultation prochaineConsultation = consultationService.getProchaineConsultationWithDetails(patientId);

            long consultationsReservees = toutesConsultations.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.RESERVEE)
                    .count();

            long consultationsTerminees = toutesConsultations.stream()
                    .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                    .count();

            request.setAttribute("totalConsultations", toutesConsultations.size());
            request.setAttribute("nombreConsultationsReservees", consultationsReservees);
            request.setAttribute("nombreConsultationsTerminees", consultationsTerminees);
            request.setAttribute("prochaineConsultation", prochaineConsultation);
            request.setAttribute("patient", patient);

            request.getRequestDispatcher("/WEB-INF/views/patient/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "===== ERREUR DASHBOARD =====", e);
            LOGGER.severe("Type: " + e.getClass().getName());
            LOGGER.severe("Message: " + e.getMessage());

            if (e.getCause() != null) {
                LOGGER.severe("Cause: " + e.getCause().getClass().getName());
                LOGGER.severe("Cause Message: " + e.getCause().getMessage());
            }

            e.printStackTrace();

            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error/error.jsp")
                    .forward(request, response);
        }
    }
}