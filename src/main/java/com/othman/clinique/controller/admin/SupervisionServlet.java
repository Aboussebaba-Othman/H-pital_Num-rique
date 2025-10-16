package com.othman.clinique.controller.admin;

import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.service.ConsultationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet(name = "SupervisionServlet", urlPatterns = {"/admin/consultations"})
public class SupervisionServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SupervisionServlet.class.getName());

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        LOGGER.info("SupervisionServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("filter".equals(action)) {
                filterConsultations(request, response);
            } else {
                listAllConsultations(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement des consultations", e);
            request.setAttribute("error", "Erreur lors du chargement des consultations");
            request.getRequestDispatcher("/WEB-INF/views/admin/supervision.jsp")
                    .forward(request, response);
        }
    }

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException {

                String action = request.getParameter("action");
                String idParam = request.getParameter("consultationId");

                try {
                        Long consultationId = Long.parseLong(idParam);

                        if ("annuler".equals(action)) {
                                // Admin can cancel any consultation
                                consultationService.annulerConsultation(consultationId, null, null);
                                request.getSession().setAttribute("successMessage", "Consultation annulée avec succès");
                        } else if ("terminer".equals(action)) {
                                // Admin terminate
                                String compteRendu = request.getParameter("compteRendu");
                                // Assuming admin id is not required here; pass null
                                consultationService.terminerConsultationByAdmin(consultationId, null, compteRendu);
                                request.getSession().setAttribute("successMessage", "Consultation marquée comme terminée");
                        }

                        response.sendRedirect(request.getContextPath() + "/admin/consultations");

                } catch (Exception e) {
                        LOGGER.log(Level.SEVERE, "Erreur action supervision", e);
                        request.getSession().setAttribute("errorMessage", e.getMessage() == null ? "Erreur système" : e.getMessage());
                        response.sendRedirect(request.getContextPath() + "/admin/consultations");
                }
        }

    private void listAllConsultations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Consultation> consultations = consultationService.getAllConsultations();

        consultations = consultations.stream()
                .sorted(Comparator.comparing(Consultation::getDate).reversed()
                        .thenComparing(Comparator.comparing(Consultation::getHeure).reversed()))
                .collect(Collectors.toList());

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

        LocalDate today = LocalDate.now();
        long aujourdhui = consultations.stream()
                .filter(c -> c.getDate().equals(today))
                .filter(c -> c.getStatut() != StatutConsultation.ANNULEE)
                .count();

        request.setAttribute("consultations", consultations);
        request.setAttribute("total", consultations.size());
        request.setAttribute("reservees", reservees);
        request.setAttribute("validees", validees);
        request.setAttribute("terminees", terminees);
        request.setAttribute("annulees", annulees);
        request.setAttribute("aujourdhui", aujourdhui);

        LOGGER.info("Supervision: " + consultations.size() + " consultations chargées");

        request.getRequestDispatcher("/WEB-INF/views/admin/supervision.jsp")
                .forward(request, response);
    }

    private void filterConsultations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String statutParam = request.getParameter("statut");
        String dateParam = request.getParameter("date");

        List<Consultation> consultations;

        if (dateParam != null && !dateParam.isEmpty()) {
            LocalDate date = LocalDate.parse(dateParam, DateTimeFormatter.ISO_DATE);
            consultations = consultationService.getConsultationsByDate(date);
        } else if (statutParam != null && !statutParam.isEmpty()) {
            StatutConsultation statut = StatutConsultation.valueOf(statutParam);
            consultations = consultationService.getConsultationsByStatut(statut);
        } else {
            consultations = consultationService.getAllConsultations();
        }

        // Trier
        consultations = consultations.stream()
                .sorted(Comparator.comparing(Consultation::getDate).reversed()
                        .thenComparing(Comparator.comparing(Consultation::getHeure).reversed()))
                .collect(Collectors.toList());

        request.setAttribute("consultations", consultations);
        request.setAttribute("total", consultations.size());
        request.setAttribute("selectedStatut", statutParam);
        request.setAttribute("selectedDate", dateParam);

        request.getRequestDispatcher("/WEB-INF/views/admin/supervision.jsp")
                .forward(request, response);
    }
}