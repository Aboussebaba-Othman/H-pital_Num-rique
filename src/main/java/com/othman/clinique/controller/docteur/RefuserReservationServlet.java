package com.othman.clinique.controller.docteur;

import com.othman.clinique.exception.EntityNotFoundException;
import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.Docteur;
import com.othman.clinique.service.ConsultationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "RefuserReservationServlet", urlPatterns = {"/docteur/refuser"})
public class RefuserReservationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RefuserReservationServlet.class.getName());

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        LOGGER.info("RefuserReservationServlet initialisé");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Docteur docteur = (Docteur) session.getAttribute("userConnecte");

        if (docteur == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Récupérer les paramètres
            String consultationIdStr = request.getParameter("consultationId");
            String motif = request.getParameter("motif");

            if (consultationIdStr == null || consultationIdStr.trim().isEmpty()) {
                throw new ValidationException("ID consultation manquant");
            }

            Long consultationId = Long.parseLong(consultationIdStr);
            Long docteurId = docteur.getIdDocteur();

            // Refuser la consultation
            Consultation consultation = consultationService.refuserConsultation(
                    consultationId,
                    docteurId,
                    motif
            );

            LOGGER.info("Consultation refusée - ID: " + consultationId +
                    ", Docteur: " + docteurId +
                    ", Patient: " + consultation.getPatient().getNom() +
                    ", Motif: " + (motif != null && !motif.isEmpty() ? motif : "Non spécifié"));

            // Message de succès
            session.setAttribute("successMessage",
                    "✅ Consultation refusée pour " +
                            consultation.getPatient().getPrenom() + " " + consultation.getPatient().getNom());

            // Rediriger vers le dashboard
            String referer = request.getHeader("Referer");
            if (referer != null && referer.contains("/docteur/")) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/docteur/dashboard");
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "ID consultation invalide", e);
            session.setAttribute("errorMessage", "❌ ID de consultation invalide");
            response.sendRedirect(request.getContextPath() + "/docteur/dashboard");

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.log(Level.WARNING, "Erreur refus consultation", e);
            session.setAttribute("errorMessage", "❌ " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/docteur/dashboard");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du refus", e);
            session.setAttribute("errorMessage", "❌ Une erreur est survenue lors du refus");
            response.sendRedirect(request.getContextPath() + "/docteur/dashboard");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Rediriger GET vers dashboard
        response.sendRedirect(request.getContextPath() + "/docteur/dashboard");
    }
}