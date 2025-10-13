package com.othman.clinique.filter;

import com.othman.clinique.model.Personne;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Logger;


@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
        "/patient/*",
        "/docteur/*",
        "/admin/*"
})
public class AuthenticationFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(AuthenticationFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOGGER.info("AuthenticationFilter initialisé");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Récupérer la session (sans en créer une nouvelle)
        HttpSession session = httpRequest.getSession(false);

        // Vérifier si l'utilisateur est connecté
        Personne userConnecte = (session != null)
                ? (Personne) session.getAttribute("userConnecte")
                : null;

        // Récupérer l'URI demandée
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        if (userConnecte == null) {
            // Utilisateur non connecté - Rediriger vers login
            LOGGER.warning("Tentative d'accès non autorisé: " + requestURI);

            // Sauvegarder l'URL demandée pour redirection après login
            session = httpRequest.getSession(true);
            session.setAttribute("redirectAfterLogin", requestURI);

            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // Utilisateur connecté - Continuer la requête
        LOGGER.fine("Accès autorisé pour: " + userConnecte.getEmail() + " - URI: " + requestURI);
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        LOGGER.info("AuthenticationFilter détruit");
    }
}