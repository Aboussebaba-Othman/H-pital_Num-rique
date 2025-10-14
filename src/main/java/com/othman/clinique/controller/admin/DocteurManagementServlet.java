package com.othman.clinique.controller.admin;

import com.othman.clinique.exception.EmailAlreadyExistsException;
import com.othman.clinique.exception.EntityNotFoundException;
import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.Departement;
import com.othman.clinique.model.Docteur;
import com.othman.clinique.service.DepartementService;
import com.othman.clinique.service.DocteurService;
import com.othman.clinique.service.AuthenticationService;

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


@WebServlet(name = "DocteurManagementServlet", urlPatterns = {"/admin/docteurs"})
public class DocteurManagementServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DocteurManagementServlet.class.getName());

    private DocteurService docteurService;
    private DepartementService departementService;

    @Override
    public void init() throws ServletException {
        this.docteurService = new DocteurService();
        this.departementService = new DepartementService();
        LOGGER.info("DocteurManagementServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("search".equals(action)) {
                searchDocteurs(request, response);
            } else {
                listDocteurs(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement des docteurs", e);
            request.setAttribute("error", "Erreur lors du chargement des docteurs");
            request.getRequestDispatcher("/WEB-INF/views/admin/docteurs.jsp")
                    .forward(request, response);
        }
    }

    private void listDocteurs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Docteur> docteurs = docteurService.getAllDocteurs();
        List<Departement> departements = departementService.getAllDepartements();

        // Calculer statistiques pour chaque docteur
        for (Docteur docteur : docteurs) {
            Docteur withPlanning = docteurService.getDocteurWithPlanning(docteur.getIdDocteur());
            int consultationsFutures = docteurService.getConsultationsFutures(docteur.getIdDocteur()).size();
            docteur.setPlanning(withPlanning.getPlanning());
        }

        request.setAttribute("docteurs", docteurs);
        request.setAttribute("departements", departements);

        LOGGER.info("Liste des docteurs chargée: " + docteurs.size() + " docteur(s)");

        request.getRequestDispatcher("/WEB-INF/views/admin/docteurs.jsp")
                .forward(request, response);
    }

    private void searchDocteurs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchTerm = request.getParameter("search");
        String specialite = request.getParameter("specialite");
        String departementId = request.getParameter("departementId");

        List<Docteur> docteurs;

        if (departementId != null && !departementId.isEmpty()) {
            docteurs = docteurService.getDocteursByDepartement(Long.parseLong(departementId));
        } else if (specialite != null && !specialite.isEmpty()) {
            docteurs = docteurService.getDocteursBySpecialite(specialite);
        } else if (searchTerm != null && !searchTerm.isEmpty()) {
            docteurs = docteurService.searchDocteurs(searchTerm);
        } else {
            docteurs = docteurService.getAllDocteurs();
        }

        List<Departement> departements = departementService.getAllDepartements();

        request.setAttribute("docteurs", docteurs);
        request.setAttribute("departements", departements);
        request.setAttribute("searchTerm", searchTerm);

        request.getRequestDispatcher("/WEB-INF/views/admin/docteurs.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createDocteur(request, response);
                    break;
                case "update":
                    updateDocteur(request, response);
                    break;
                case "delete":
                    deleteDocteur(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/docteurs");
                    break;
            }
        } catch (ValidationException e) {
            LOGGER.warning("Erreur validation: " + e.getMessage());
            redirectWithError(request, response, e.getMessage());
        } catch (EntityNotFoundException e) {
            LOGGER.warning("Entité non trouvée: " + e.getMessage());
            redirectWithError(request, response, e.getMessage());
        } catch (EmailAlreadyExistsException e) {
            LOGGER.warning("Email déjà existant: " + e.getMessage());
            redirectWithError(request, response, "Cet email est déjà utilisé");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de l'action: " + action, e);
            redirectWithError(request, response, "Erreur système. Veuillez réessayer.");
        }
    }

    private void createDocteur(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String specialite = request.getParameter("specialite");
        Long departementId = Long.parseLong(request.getParameter("departementId"));

        // Utiliser AuthenticationService pour créer le docteur
        AuthenticationService authService = new AuthenticationService();

        authService.registerDocteur(nom, prenom, email, password, specialite, departementId);

        LOGGER.info("Docteur créé: " + nom + " " + prenom);
        redirectWithSuccess(request, response, "Docteur créé avec succès");
    }

    private void updateDocteur(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String specialite = request.getParameter("specialite");
        Long departementId = Long.parseLong(request.getParameter("departementId"));

        docteurService.updateDocteur(id, nom, prenom, email, specialite, departementId);

        LOGGER.info("Docteur mis à jour: " + nom + " " + prenom);
        redirectWithSuccess(request, response, "Docteur modifié avec succès");
    }

    private void deleteDocteur(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        docteurService.deleteDocteur(id);

        LOGGER.info("Docteur supprimé: " + id);
        redirectWithSuccess(request, response, "Docteur supprimé avec succès");
    }

    private void redirectWithSuccess(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/docteurs?success=" +
                URLEncoder.encode(message, "UTF-8"));
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/docteurs?error=" +
                URLEncoder.encode(message, "UTF-8"));
    }
}