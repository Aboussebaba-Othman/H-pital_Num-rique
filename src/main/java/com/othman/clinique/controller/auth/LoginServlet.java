package com.othman.clinique.controller.auth;

import com.othman.clinique.exception.AuthenticationException;
import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.Personne;
import com.othman.clinique.model.Role;
import com.othman.clinique.service.AuthenticationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    private AuthenticationService authService;

    @Override
    public void init() throws ServletException {
        this.authService = new AuthenticationService();
        LOGGER.info("LoginServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userConnecte") != null) {
            Personne user = (Personne) session.getAttribute("userConnecte");
            redirectToDashboard(response, user.getRole(), request.getContextPath());
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp")
                .forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Personne user = authService.login(email, password);

            HttpSession session = request.getSession(true);
            session.setAttribute("userConnecte", user);
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getPrenom() + " " + user.getNom());

            session.setMaxInactiveInterval(30 * 60);

            LOGGER.info("Connexion réussie - User: " + email + ", Role: " + user.getRole());

            redirectToDashboard(response, user.getRole(), request.getContextPath());

        } catch (AuthenticationException e) {
            LOGGER.warning("Échec authentification - Email: " + email);
            request.setAttribute("error", e.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp")
                    .forward(request, response);

        } catch (ValidationException e) {
            LOGGER.warning("Erreur validation login - Email: " + email);
            request.setAttribute("error", e.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur inattendue lors de la connexion", e);
            request.setAttribute("error", "Une erreur système est survenue. Veuillez réessayer.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp")
                    .forward(request, response);
        }
    }
    private void redirectToDashboard(HttpServletResponse response, Role role, String contextPath)
            throws IOException {

        String redirectUrl;

        switch (role) {
            case PATIENT:
                redirectUrl = contextPath + "/patient/dashboard";
                break;
            case DOCTEUR:
                redirectUrl = contextPath + "/docteur/dashboard";
                break;
            case ADMIN:
                redirectUrl = contextPath + "/admin/dashboard";
                break;
            default:
                redirectUrl = contextPath + "/";
                break;
        }

        response.sendRedirect(redirectUrl);
    }
}