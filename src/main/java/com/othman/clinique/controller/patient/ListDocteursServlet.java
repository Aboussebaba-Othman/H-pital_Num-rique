package com.othman.clinique.controller.patient;

import com.othman.clinique.model.Departement;
import com.othman.clinique.model.Docteur;
import com.othman.clinique.model.Patient;
import com.othman.clinique.service.DepartementService;
import com.othman.clinique.service.DocteurService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ListDocteursServlet", urlPatterns = {"/patient/docteurs"})
public class ListDocteursServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ListDocteursServlet.class.getName());

    private DocteurService docteurService;
    private DepartementService departementService;

    @Override
    public void init() throws ServletException {
        this.docteurService = new DocteurService();
        this.departementService = new DepartementService();
        LOGGER.info("ListDocteursServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Patient patient = (Patient) session.getAttribute("userConnecte");

        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String specialite = request.getParameter("specialite");
            String departementIdStr = request.getParameter("departementId");
            String searchTerm = request.getParameter("search");

            List<Docteur> docteurs;

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                docteurs = docteurService.searchDocteurs(searchTerm);
                request.setAttribute("searchTerm", searchTerm);
            } else if (specialite != null && !specialite.trim().isEmpty()) {
                docteurs = docteurService.getDocteursBySpecialite(specialite);
                request.setAttribute("specialiteFiltre", specialite);
            } else if (departementIdStr != null && !departementIdStr.trim().isEmpty()) {
                Long departementId = Long.parseLong(departementIdStr);
                docteurs = docteurService.getDocteursByDepartement(departementId);
                request.setAttribute("departementIdFiltre", departementId);
            } else {
                docteurs = docteurService.getAllDocteurs();
            }

            List<Departement> departements = departementService.getAllDepartements();

            request.setAttribute("docteurs", docteurs);
            request.setAttribute("departements", departements);

            LOGGER.info("Liste docteurs chargée - " + docteurs.size() + " docteurs");

            request.getRequestDispatcher("/WEB-INF/views/patient/docteurs.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement de la liste des docteurs", e);
            request.setAttribute("error", "Erreur lors du chargement de la liste des docteurs");
            request.getRequestDispatcher("/WEB-INF/views/error/error.jsp")
                    .forward(request, response);
        }
    }
}