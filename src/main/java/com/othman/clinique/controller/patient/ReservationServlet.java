package com.othman.clinique.controller.patient;

import com.othman.clinique.exception.CreneauOccupeException;
import com.othman.clinique.exception.SalleNonDisponibleException;
import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.Docteur;
import com.othman.clinique.model.Patient;
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
import java.time.LocalTime;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ReservationServlet", urlPatterns = {"/patient/reserver"})
public class ReservationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ReservationServlet.class.getName());

    private ConsultationService consultationService;
    private DocteurService docteurService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        this.docteurService = new DocteurService();
        LOGGER.info("ReservationServlet initialisé");
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
            String docteurIdStr = request.getParameter("docteurId");

            if (docteurIdStr != null) {
                Long docteurId = Long.parseLong(docteurIdStr);
                Docteur docteur = docteurService.getDocteurById(docteurId);
                request.setAttribute("docteurSelectionne", docteur);
            }

            List<Docteur> docteurs = docteurService.getAllDocteurs();
            request.setAttribute("docteurs", docteurs);

            request.getRequestDispatcher("/WEB-INF/views/patient/reserver.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement du formulaire de réservation", e);
            request.setAttribute("error", "Erreur lors du chargement du formulaire");
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
            Long patientId = patient.getIdPatient();
            Long docteurId = Long.parseLong(request.getParameter("docteurId"));
            LocalDate date = LocalDate.parse(request.getParameter("date"));
            LocalTime heure = LocalTime.parse(request.getParameter("heure"));
            String motif = request.getParameter("motif");

            Consultation consultation = consultationService.reserverConsultation(
                    patientId, docteurId, date, heure, motif
            );

            session.setAttribute("successMessage",
                    "Consultation réservée avec succès ! Référence: #" + consultation.getIdConsultation());

            response.sendRedirect(request.getContextPath() + "/patient/consultations");

        } catch (ValidationException | CreneauOccupeException | SalleNonDisponibleException e) {
            LOGGER.warning("Échec réservation: " + e.getMessage());
            request.setAttribute("errorMessage", e.getMessage());
            doGet(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la réservation", e);
            request.setAttribute("errorMessage", "Erreur système lors de la réservation");
            doGet(request, response);
        }
    }
}