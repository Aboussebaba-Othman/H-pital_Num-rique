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

@WebServlet(name = "CompteRenduServlet", urlPatterns = {"/docteur/compte-rendu"})
public class CompteRenduServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CompteRenduServlet.class.getName());

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        LOGGER.info("CompteRenduServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Docteur docteur = (Docteur) session.getAttribute("userConnecte");

        if (docteur == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String consultationIdStr = request.getParameter("id");

            if (consultationIdStr == null || consultationIdStr.trim().isEmpty()) {
                throw new ValidationException("ID consultation manquant");
            }

            Long consultationId = Long.parseLong(consultationIdStr);
            Consultation consultation = consultationService.getConsultationById(consultationId);

            // Vérifier que c'est bien le docteur de cette consultation
            if (!consultation.getDocteur().getIdDocteur().equals(docteur.getIdDocteur())) {
                throw new ValidationException("Vous n'êtes pas autorisé à accéder à cette consultation");
            }

            request.setAttribute("consultation", consultation);
            request.setAttribute("docteur", docteur);

            request.getRequestDispatcher("/WEB-INF/views/docteur/compte-rendu.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur affichage compte rendu", e);
            session.setAttribute("errorMessage", "❌ " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/docteur/dashboard");
        }
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
            String consultationIdStr = request.getParameter("consultationId");
            String compteRendu = request.getParameter("compteRendu");

            if (consultationIdStr == null || consultationIdStr.trim().isEmpty()) {
                throw new ValidationException("ID consultation manquant");
            }

            if (compteRendu == null || compteRendu.trim().isEmpty()) {
                throw new ValidationException("Le compte rendu est requis");
            }

            Long consultationId = Long.parseLong(consultationIdStr);
            Long docteurId = docteur.getIdDocteur();

            // Terminer la consultation avec le compte rendu
            Consultation consultation = consultationService.terminerConsultation(
                    consultationId,
                    docteurId,
                    compteRendu
            );

            LOGGER.info("Consultation terminée avec compte rendu - ID: " + consultationId +
                    ", Docteur: " + docteurId +
                    ", Patient: " + consultation.getPatient().getNom());

            session.setAttribute("successMessage",
                    "✅ Consultation terminée avec succès pour " +
                            consultation.getPatient().getPrenom() + " " + consultation.getPatient().getNom());

            response.sendRedirect(request.getContextPath() + "/docteur/dashboard");

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "ID consultation invalide", e);
            session.setAttribute("errorMessage", "❌ ID de consultation invalide");
            response.sendRedirect(request.getContextPath() + "/docteur/dashboard");

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.log(Level.WARNING, "Erreur terminaison consultation", e);
            session.setAttribute("errorMessage", "❌ " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/docteur/dashboard");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la terminaison", e);
            session.setAttribute("errorMessage", "❌ Une erreur est survenue lors de la terminaison");
            response.sendRedirect(request.getContextPath() + "/docteur/dashboard");
        }
    }
}