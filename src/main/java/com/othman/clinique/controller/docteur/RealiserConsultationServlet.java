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

@WebServlet(name = "RealiserConsultationServlet", urlPatterns = {"/docteur/consultation"})
public class RealiserConsultationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RealiserConsultationServlet.class.getName());

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        LOGGER.info("RealiserConsultationServlet initialisé");
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
            // Récupérer l'ID de la consultation
            String consultationIdStr = request.getParameter("id");

            if (consultationIdStr == null || consultationIdStr.trim().isEmpty()) {
                throw new ValidationException("ID consultation manquant");
            }

            Long consultationId = Long.parseLong(consultationIdStr);

            // Récupérer la consultation avec tous ses détails
            Consultation consultation = consultationService.getConsultationById(consultationId);

            // Vérifier que c'est bien le docteur de cette consultation
            if (!consultation.getDocteur().getIdDocteur().equals(docteur.getIdDocteur())) {
                throw new ValidationException("Vous n'êtes pas autorisé à consulter cette consultation");
            }

            LOGGER.info("Affichage consultation ID: " + consultationId +
                    ", Docteur: " + docteur.getIdDocteur() +
                    ", Patient: " + consultation.getPatient().getNom() +
                    ", Statut: " + consultation.getStatut());

            // Passer les données à la JSP
            request.setAttribute("consultation", consultation);
            request.setAttribute("docteur", docteur);

            request.getRequestDispatcher("/WEB-INF/views/docteur/consultation-details.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "ID consultation invalide", e);
            session.setAttribute("errorMessage", "❌ ID de consultation invalide");
            response.sendRedirect(request.getContextPath() + "/docteur/dashboard");

        } catch (ValidationException | EntityNotFoundException e) {
            LOGGER.log(Level.WARNING, "Erreur consultation", e);
            session.setAttribute("errorMessage", "❌ " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/docteur/dashboard");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de la récupération de la consultation", e);
            session.setAttribute("errorMessage", "❌ Une erreur est survenue");
            response.sendRedirect(request.getContextPath() + "/docteur/dashboard");
        }
    }
}