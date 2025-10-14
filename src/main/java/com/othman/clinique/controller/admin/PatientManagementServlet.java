package com.othman.clinique.controller.admin;

import com.othman.clinique.exception.EmailAlreadyExistsException;
import com.othman.clinique.exception.EntityNotFoundException;
import com.othman.clinique.exception.ValidationException;
import com.othman.clinique.model.Patient;
import com.othman.clinique.service.PatientService;

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


@WebServlet(name = "PatientManagementServlet", urlPatterns = {"/admin/patients"})
public class PatientManagementServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PatientManagementServlet.class.getName());

    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        this.patientService = new PatientService();
        LOGGER.info("PatientManagementServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("search".equals(action)) {
                searchPatients(request, response);
            } else {
                listPatients(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement des patients", e);
            request.setAttribute("error", "Erreur lors du chargement des patients");
            request.getRequestDispatcher("/WEB-INF/views/admin/patients.jsp")
                    .forward(request, response);
        }
    }

    private void listPatients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Patient> patients = patientService.getAllPatients();

        for (Patient patient : patients) {
            Patient withConsultations = patientService.getPatientWithConsultations(patient.getIdPatient());
            patient.setConsultations(withConsultations.getConsultations());

            if (patient.getPoids() != null && patient.getTaille() != null && patient.getTaille() > 0) {
                double imc = patient.getPoids() / (patient.getTaille() * patient.getTaille());
                patient.setImc(Math.round(imc * 10.0) / 10.0);
            }
        }

        request.setAttribute("patients", patients);

        LOGGER.info("Liste des patients chargée: " + patients.size() + " patient(s)");

        request.getRequestDispatcher("/WEB-INF/views/admin/patients.jsp")
                .forward(request, response);
    }

    private void searchPatients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchTerm = request.getParameter("search");

        List<Patient> patients;

        if (searchTerm != null && !searchTerm.isEmpty()) {
            patients = patientService.searchPatients(searchTerm);
        } else {
            patients = patientService.getAllPatients();
        }

        for (Patient patient : patients) {
            Patient withConsultations = patientService.getPatientWithConsultations(patient.getIdPatient());
            patient.setConsultations(withConsultations.getConsultations());
        }

        request.setAttribute("patients", patients);
        request.setAttribute("searchTerm", searchTerm);

        request.getRequestDispatcher("/WEB-INF/views/admin/patients.jsp")
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
                    createPatient(request, response);
                    break;
                case "update":
                    updatePatient(request, response);
                    break;
                case "updateMesures":
                    updateMesures(request, response);
                    break;
                case "delete":
                    deletePatient(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/patients");
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

    private void createPatient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        Double poids = Double.parseDouble(request.getParameter("poids"));
        Double taille = Double.parseDouble(request.getParameter("taille"));

        com.othman.clinique.service.AuthenticationService authService =
                new com.othman.clinique.service.AuthenticationService();

        authService.registerPatient(nom, prenom, email, password, poids, taille);

        LOGGER.info("Patient créé: " + nom + " " + prenom);
        redirectWithSuccess(request, response, "Patient créé avec succès");
    }

    private void updatePatient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        Double poids = Double.parseDouble(request.getParameter("poids"));
        Double taille = Double.parseDouble(request.getParameter("taille"));

        patientService.updatePatient(id, nom, prenom, email, poids, taille);

        LOGGER.info("Patient mis à jour: " + nom + " " + prenom);
        redirectWithSuccess(request, response, "Patient modifié avec succès");
    }

    private void updateMesures(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        Double poids = Double.parseDouble(request.getParameter("poids"));
        Double taille = Double.parseDouble(request.getParameter("taille"));

        patientService.updatePatientMesures(id, poids, taille);

        LOGGER.info("Mesures patient mises à jour: " + id);
        redirectWithSuccess(request, response, "Mesures mises à jour avec succès");
    }

    private void deletePatient(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        patientService.deletePatient(id);

        LOGGER.info("Patient supprimé: " + id);
        redirectWithSuccess(request, response, "Patient supprimé avec succès");
    }

    private void redirectWithSuccess(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/patients?success=" +
                URLEncoder.encode(message, "UTF-8"));
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/patients?error=" +
                URLEncoder.encode(message, "UTF-8"));
    }
}