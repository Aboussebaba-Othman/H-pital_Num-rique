package com.othman.clinique.controller.admin;

import com.othman.clinique.exception.EntityNotFoundException;
import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.Departement;
import com.othman.clinique.service.DepartementService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet de gestion des départements (CRUD complet)
 *
 * @author Othman
 * @version 1.0
 */
@WebServlet(name = "GererDepartementServlet", urlPatterns = {"/admin/departements"})
public class GererDepartementServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(GererDepartementServlet.class.getName());

    private DepartementService departementService;

    @Override
    public void init() throws ServletException {
        this.departementService = new DepartementService();
        LOGGER.info("GererDepartementServlet initialisé");
    }

    /**
     * GET : Affiche la liste des départements
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Récupérer tous les départements
            List<Departement> departements = departementService.getAllDepartements();

            // Calculer le nombre de docteurs pour chaque département
            for (Departement dept : departements) {
                int nbDocteurs = departementService.countDocteursInDepartement(dept.getIdDepartement());
                dept.setDocteurs(new java.util.ArrayList<>()); // Initialiser pour éviter lazy loading
            }

            request.setAttribute("departements", departements);

            LOGGER.info("Liste des départements chargée: " + departements.size() + " département(s)");

            request.getRequestDispatcher("/WEB-INF/views/admin/departements.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement des départements", e);
            request.setAttribute("error", "Erreur lors du chargement des départements");
            request.getRequestDispatcher("/WEB-INF/views/admin/departements.jsp")
                    .forward(request, response);
        }
    }

    /**
     * POST : Traite les actions CRUD (create, update, delete)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createDepartement(request, response);
                    break;
                case "update":
                    updateDepartement(request, response);
                    break;
                case "delete":
                    deleteDepartement(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/departements");
                    break;
            }
        } catch (ValidationException e) {
            LOGGER.warning("Erreur validation: " + e.getMessage());
            redirectWithError(request, response, e.getMessage());
        } catch (EntityNotFoundException e) {
            LOGGER.warning("Entité non trouvée: " + e.getMessage());
            redirectWithError(request, response, e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de l'action: " + action, e);
            redirectWithError(request, response, "Erreur système. Veuillez réessayer.");
        }
    }

    /**
     * Créer un nouveau département
     */
    private void createDepartement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String nom = request.getParameter("nom");

        Departement departement = departementService.createDepartement(nom);

        LOGGER.info("Département créé: " + departement.getNom());
        redirectWithSuccess(request, response, "Département créé avec succès");
    }

    /**
     * Mettre à jour un département
     */
    private void updateDepartement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        String nom = request.getParameter("nom");

        Departement departement = departementService.updateDepartement(id, nom);

        LOGGER.info("Département mis à jour: " + departement.getNom());
        redirectWithSuccess(request, response, "Département modifié avec succès");
    }

    /**
     * Supprimer un département
     */
    private void deleteDepartement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));

        departementService.deleteDepartement(id);

        LOGGER.info("Département supprimé: " + id);
        redirectWithSuccess(request, response, "Département supprimé avec succès");
    }

    /**
     * Redirection avec message de succès
     */
    private void redirectWithSuccess(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/departements?success=" +
                URLEncoder.encode(message, "UTF-8"));
    }

    /**
     * Redirection avec message d'erreur
     */
    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/departements?error=" +
                URLEncoder.encode(message, "UTF-8"));
    }
}