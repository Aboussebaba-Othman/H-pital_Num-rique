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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "GererDepartementServlet", urlPatterns = {"/admin/departements"})
public class GererDepartementServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(GererDepartementServlet.class.getName());

    private DepartementService departementService;

    @Override
    public void init() throws ServletException {
        this.departementService = new DepartementService();
        LOGGER.info("GererDepartementServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Departement> departements = departementService.getAllDepartements();

            Map<Long, Integer> docteursCount = new HashMap<>();

            for (Departement dept : departements) {
                int nbDocteurs = departementService.countDocteursInDepartement(dept.getIdDepartement());
                docteursCount.put(dept.getIdDepartement(), nbDocteurs);
            }

            request.setAttribute("departements", departements);
            request.setAttribute("docteursCount", docteursCount);

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

    private void createDepartement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String nom = request.getParameter("nom");

        Departement departement = departementService.createDepartement(nom);

        LOGGER.info("Département créé: " + departement.getNom());
        redirectWithSuccess(request, response, "Département créé avec succès");
    }

    private void updateDepartement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        String nom = request.getParameter("nom");

        Departement departement = departementService.updateDepartement(id, nom);

        LOGGER.info("Département mis à jour: " + departement.getNom());
        redirectWithSuccess(request, response, "Département modifié avec succès");
    }

    private void deleteDepartement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));

        departementService.deleteDepartement(id);

        LOGGER.info("Département supprimé: " + id);
        redirectWithSuccess(request, response, "Département supprimé avec succès");
    }

    private void redirectWithSuccess(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/departements?success=" +
                URLEncoder.encode(message, "UTF-8"));
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/departements?error=" +
                URLEncoder.encode(message, "UTF-8"));
    }
}