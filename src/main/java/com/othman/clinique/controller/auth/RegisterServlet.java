package com.othman.clinique.controller.auth;

import com.othman.clinique.exception.EmailAlreadyExistsException;
import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.Patient;
import com.othman.clinique.service.AuthenticationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());

    private AuthenticationService authService;

    @Override
    public void init() throws ServletException {
        this.authService = new AuthenticationService();
        LOGGER.info("RegisterServlet initialisé");
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp")
                .forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String poidsStr = request.getParameter("poids");
        String tailleStr = request.getParameter("taille");

        try {
            if (!password.equals(confirmPassword)) {
                throw new ValidationException("Les mots de passe ne correspondent pas");
            }

            Double poids = parseDouble(poidsStr, "poids");
            Double taille = parseDouble(tailleStr, "taille");

            Patient patient = authService.registerPatient(nom, prenom, email, password, poids, taille);

            LOGGER.info("Nouveau patient inscrit - ID: " + patient.getId() + ", Email: " + email);

            response.sendRedirect(request.getContextPath() +
                    "/login?success=" + encodeMessage("Inscription réussie ! Vous pouvez maintenant vous connecter."));

        } catch (ValidationException e) {
            LOGGER.warning("Erreur validation inscription - Email: " + email + " - " + e.getMessage());
            handleError(request, response, e.getMessage(), nom, prenom, email, poidsStr, tailleStr);

        } catch (EmailAlreadyExistsException e) {
            LOGGER.warning("Email déjà existant - Email: " + email);
            handleError(request, response, e.getMessage(), nom, prenom, email, poidsStr, tailleStr);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur inattendue lors de l'inscription", e);
            handleError(request, response, "Une erreur système est survenue. Veuillez réessayer.",
                    nom, prenom, email, poidsStr, tailleStr);
        }
    }

    private Double parseDouble(String value, String fieldName) throws ValidationException {
        if (value == null || value.trim().isEmpty()) {
            throw new ValidationException("Le champ " + fieldName + " est requis");
        }

        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            throw new ValidationException("Le champ " + fieldName + " doit être un nombre valide");
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
                             String errorMessage, String nom, String prenom,
                             String email, String poids, String taille)
            throws ServletException, IOException {

        request.setAttribute("error", errorMessage);
        request.setAttribute("nom", nom);
        request.setAttribute("prenom", prenom);
        request.setAttribute("email", email);
        request.setAttribute("poids", poids);
        request.setAttribute("taille", taille);

        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp")
                .forward(request, response);
    }

    private String encodeMessage(String message) {
        try {
            return java.net.URLEncoder.encode(message, "UTF-8");
        } catch (Exception e) {
            return message;
        }
    }
}