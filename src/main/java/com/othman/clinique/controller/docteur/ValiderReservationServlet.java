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

@WebServlet(name = "ValiderReservationServlet", urlPatterns = {"/docteur/valider"})
public class ValiderReservationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ValiderReservationServlet.class.getName());

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        LOGGER.info("ValiderReservationServlet initialisé");
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
            // Récupérer l'ID de la consultation
            String consultationIdStr = request.getParameter("consultationId");

            if (consultationIdStr == null || consultationIdStr.trim().isEmpty()) {
                throw new ValidationException("ID consultation manquant");
            }

            Long consultationId = Long.parseLong(consultationIdStr);
            Long docteurId = docteur.getIdDocteur();

            // Valider la consultation
            Consultation consultation = consultationService.validerConsultation(consultationId, docteurId);

            LOGGER.info("Consultation validée - ID: " + consultationId +
                    ", Docteur: " + docteurId +
                    ", Patient: " + consultation.getPatient().getNom());

            // Message de succès
            session.setAttribute("successMessage",
                    "✅ Consultation validée avec succès pour " +
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
            LOGGER.log(Level.WARNING, "Erreur validation consultation", e);
            session.setAttribute("errorMessage", "❌ " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/docteur/dashboard");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la validation", e);
            session.setAttribute("errorMessage", "❌ Une erreur est survenue lors de la validation");
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