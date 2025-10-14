package com.othman.clinique.controller.admin;

import com.othman.clinique.exception.EntityNotFoundException;
import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.Salle;
import com.othman.clinique.service.SalleService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "SalleServlet", urlPatterns = {"/admin/salles"})
public class SalleServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SalleServlet.class.getName());

    private SalleService salleService;

    @Override
    public void init() throws ServletException {
        this.salleService = new SalleService();
        LOGGER.info("SalleServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Salle> salles = salleService.getAllSalles();

            Map<Long, Double> tauxOccupation = new HashMap<>();
            LocalDate today = LocalDate.now();

            for (Salle salle : salles) {
                double taux = salleService.getTauxOccupation(salle.getIdSalle(), today);
                tauxOccupation.put(salle.getIdSalle(), taux);
            }

            request.setAttribute("salles", salles);
            request.setAttribute("tauxOccupation", tauxOccupation);

            LOGGER.info("Liste des salles chargée: " + salles.size() + " salle(s)");

            request.getRequestDispatcher("/WEB-INF/views/admin/salles.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement des salles", e);
            request.setAttribute("error", "Erreur lors du chargement des salles");
            request.getRequestDispatcher("/WEB-INF/views/admin/salles.jsp")
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
                    createSalle(request, response);
                    break;
                case "update":
                    updateSalle(request, response);
                    break;
                case "delete":
                    deleteSalle(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/salles");
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

    private void createSalle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String nomSalle = request.getParameter("nomSalle");
        Integer capacite = Integer.parseInt(request.getParameter("capacite"));

        Salle salle = salleService.createSalle(nomSalle, capacite);

        LOGGER.info("Salle créée: " + salle.getNomSalle());
        redirectWithSuccess(request, response, "Salle créée avec succès");
    }

    private void updateSalle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        String nomSalle = request.getParameter("nomSalle");
        Integer capacite = Integer.parseInt(request.getParameter("capacite"));

        Salle salle = salleService.updateSalle(id, nomSalle, capacite);

        LOGGER.info("Salle mise à jour: " + salle.getNomSalle());
        redirectWithSuccess(request, response, "Salle modifiée avec succès");
    }

    private void deleteSalle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        salleService.deleteSalle(id);

        LOGGER.info("Salle supprimée: " + id);
        redirectWithSuccess(request, response, "Salle supprimée avec succès");
    }

    private void redirectWithSuccess(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/salles?success=" +
                URLEncoder.encode(message, "UTF-8"));
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/salles?error=" +
                URLEncoder.encode(message, "UTF-8"));
    }
}