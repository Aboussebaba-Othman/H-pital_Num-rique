package com.othman.clinique.controller.patient;

import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.Patient;
import com.othman.clinique.model.Role;
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
import java.util.Comparator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet(name = "ConsultationsPatientServlet", urlPatterns = {"/patient/consultations"})
public class ConsultationsPatientServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ConsultationsPatientServlet.class.getName());

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        LOGGER.info("ConsultationsPatientServlet initialisé");
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
            String statutFilter = request.getParameter("statut");

            List<Consultation> consultations = consultationService.getConsultationsByPatient(patientId);

            // Filtrer par statut si demandé
            if (statutFilter != null && !statutFilter.isEmpty()) {
                StatutConsultation statut = StatutConsultation.valueOf(statutFilter);
                consultations = consultations.stream()
                        .filter(c -> c.getStatut() == statut)
                        .collect(Collectors.toList());
                request.setAttribute("statutFiltre", statutFilter);
            }

            // Séparer les consultations futures et passées
            LocalDate aujourdhui = LocalDate.now();

            List<Consultation> consultationsFutures = consultations.stream()
                    .filter(c -> c.getDate().isAfter(aujourdhui) || c.getDate().equals(aujourdhui))
                    .sorted(Comparator.comparing(Consultation::getDate)
                            .thenComparing(Consultation::getHeure))
                    .collect(Collectors.toList());

            List<Consultation> consultationsPassees = consultations.stream()
                    .filter(c -> c.getDate().isBefore(aujourdhui))
                    .sorted(Comparator.comparing(Consultation::getDate)
                            .thenComparing(Consultation::getHeure).reversed())
                    .collect(Collectors.toList());

            request.setAttribute("consultationsFutures", consultationsFutures);
            request.setAttribute("consultationsPassees", consultationsPassees);
            request.setAttribute("totalConsultations", consultations.size());

            LOGGER.info("Consultations chargées pour patient ID: " + patientId);

            request.getRequestDispatcher("/WEB-INF/views/patient/consultations.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement des consultations", e);
            request.setAttribute("error", "Erreur lors du chargement des consultations");
            request.getRequestDispatcher("/WEB-INF/views/error/error.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("userConnecte");

        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String action = request.getParameter("action");
            Long consultationId = Long.parseLong(request.getParameter("consultationId"));

            if ("annuler".equals(action)) {
                consultationService.annulerConsultation(
                        consultationId,
                        patient.getIdPatient(),
                        Role.PATIENT
                );
                session.setAttribute("successMessage", "Consultation annulée avec succès");
            }

            response.sendRedirect(request.getContextPath() + "/patient/consultations");

        } catch (ValidationException e) {
            LOGGER.warning("Échec action consultation: " + e.getMessage());
            session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/consultations");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de l'action sur la consultation", e);
            session.setAttribute("errorMessage", "Erreur système");
            response.sendRedirect(request.getContextPath() + "/patient/consultations");
        }
    }
}