package com.othman.clinique.filter;

import com.othman.clinique.model.Personne;
import com.othman.clinique.model.Role;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Logger;

@WebFilter(filterName = "RoleFilter", urlPatterns = {"/*"})
public class RoleFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(RoleFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOGGER.info("RoleFilter initialisé");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Exclure les ressources publiques
        if (isPublicResource(requestURI, contextPath)) {
            chain.doFilter(request, response);
            return;
        }

        // Récupérer l'utilisateur connecté
        Personne userConnecte = (session != null)
                ? (Personne) session.getAttribute("userConnecte")
                : null;

        // Si pas connecté, laisser AuthenticationFilter gérer
        if (userConnecte == null) {
            chain.doFilter(request, response);
            return;
        }

        // Vérifier le rôle selon l'URL
        Role userRole = userConnecte.getRole();

        if (requestURI.startsWith(contextPath + "/patient/")) {
            if (userRole != Role.PATIENT) {
                LOGGER.warning("Accès refusé: " + userConnecte.getEmail() +
                        " (Role: " + userRole + ") a tenté d'accéder à /patient/");
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Vous n'avez pas les droits pour accéder à cette page");
                return;
            }
        } else if (requestURI.startsWith(contextPath + "/docteur/")) {
            if (userRole != Role.DOCTEUR) {
                LOGGER.warning("Accès refusé: " + userConnecte.getEmail() +
                        " (Role: " + userRole + ") a tenté d'accéder à /docteur/");
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Vous n'avez pas les droits pour accéder à cette page");
                return;
            }
        } else if (requestURI.startsWith(contextPath + "/admin/")) {
            if (userRole != Role.ADMIN) {
                LOGGER.warning("Accès refusé: " + userConnecte.getEmail() +
                        " (Role: " + userRole + ") a tenté d'accéder à /admin/");
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Vous n'avez pas les droits pour accéder à cette page");
                return;
            }
        }

        // Rôle correct - Continuer la requête
        chain.doFilter(request, response);
    }

    /**
     * Vérifie si la ressource est publique (pas besoin de vérification de rôle)
     */
    private boolean isPublicResource(String requestURI, String contextPath) {
        // Pages publiques
        if (requestURI.equals(contextPath + "/") ||
                requestURI.equals(contextPath + "/index.jsp") ||
                requestURI.equals(contextPath + "/login") ||
                requestURI.equals(contextPath + "/register") ||
                requestURI.equals(contextPath + "/logout")) {
            return true;
        }

        // Ressources statiques
        if (requestURI.contains("/css/") ||
                requestURI.contains("/js/") ||
                requestURI.contains("/images/") ||
                requestURI.contains("/assets/")) {
            return true;
        }

        return false;
    }

    @Override
    public void destroy() {
        LOGGER.info("RoleFilter détruit");
    }
}