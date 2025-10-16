package com.othman.clinique.controller.admin;

import com.othman.clinique.model.Administrateur;
import com.othman.clinique.service.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());

    private PatientService patientService;
    private DocteurService docteurService;
    private DepartementService departementService;
    private SalleService salleService;
    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        this.patientService = new PatientService();
        this.docteurService = new DocteurService();
        this.departementService = new DepartementService();
        this.salleService = new SalleService();
        this.consultationService = new ConsultationService();
        LOGGER.info("AdminDashboardServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Administrateur admin = (Administrateur) session.getAttribute("userConnecte");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Long nombrePatients = patientService.countPatients();
            Long nombreDocteurs = docteurService.countDocteurs();
            Long nombreDepartements = departementService.countDepartements();
            Long nombreSalles = salleService.countSalles();

            java.time.LocalDate aujourdhui = java.time.LocalDate.now();
            int consultationsDuJour = consultationService.getConsultationsByDate(aujourdhui).size();

            int consultationsReservees = consultationService.getConsultationsByStatut(
                    com.othman.clinique.model.StatutConsultation.RESERVEE).size();
            int consultationsValidees = consultationService.getConsultationsByStatut(
                    com.othman.clinique.model.StatutConsultation.VALIDEE).size();
            int consultationsTerminees = consultationService.getConsultationsByStatut(
                    com.othman.clinique.model.StatutConsultation.TERMINEE).size();

            // Passer les données à la JSP
            request.setAttribute("nombrePatients", nombrePatients);
            request.setAttribute("nombreDocteurs", nombreDocteurs);
            request.setAttribute("nombreDepartements", nombreDepartements);
            request.setAttribute("nombreSalles", nombreSalles);
            request.setAttribute("consultationsDuJour", consultationsDuJour);
            request.setAttribute("consultationsReservees", consultationsReservees);
            request.setAttribute("consultationsValidees", consultationsValidees);
            request.setAttribute("consultationsTerminees", consultationsTerminees);
            request.setAttribute("admin", admin);

            LOGGER.info("Dashboard admin chargé");

            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement du dashboard admin", e);
            request.setAttribute("error", "Erreur lors du chargement du dashboard");
            request.getRequestDispatcher("/WEB-INF/views/error/403.jsp")
                    .forward(request, response);
        }
    }
}