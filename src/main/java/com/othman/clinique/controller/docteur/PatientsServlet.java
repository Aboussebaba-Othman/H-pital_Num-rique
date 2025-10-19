package com.othman.clinique.controller.docteur;

import com.othman.clinique.model.Consultation;
import com.othman.clinique.model.Docteur;
import com.othman.clinique.model.Patient;
import com.othman.clinique.model.StatutConsultation;
import com.othman.clinique.service.ConsultationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet(name = "PatientsServlet", urlPatterns = {"/docteur/patients"})
public class PatientsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PatientsServlet.class.getName());

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        this.consultationService = new ConsultationService();
        LOGGER.info("PatientsServlet initialisé");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Docteur docteur = (Docteur) session.getAttribute("userConnecte");

        if (docteur == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Long docteurId = docteur.getIdDocteur();

            // Récupérer les paramètres de filtre et recherche
            String searchParam = request.getParameter("search");
            String sortParam = request.getParameter("sort");

            // Récupérer toutes les consultations du docteur
            List<Consultation> toutesConsultations = consultationService.getConsultationsByDocteur(docteurId);

            // Extraire les patients uniques avec leurs statistiques
            Map<Long, PatientInfo> patientsMap = new HashMap<>();

            for (Consultation consultation : toutesConsultations) {
                Patient patient = consultation.getPatient();
                Long patientId = patient.getIdPatient();

                PatientInfo info = patientsMap.computeIfAbsent(patientId,
                        k -> new PatientInfo(patient));

                info.addConsultation(consultation);
            }

            // Convertir en liste
            List<PatientInfo> patientsInfo = new ArrayList<>(patientsMap.values());

            // Appliquer la recherche
            if (searchParam != null && !searchParam.trim().isEmpty()) {
                String search = searchParam.toLowerCase().trim();
                patientsInfo = patientsInfo.stream()
                        .filter(p -> {
                            String nomComplet = (p.getPatient().getNom() + " " +
                                    p.getPatient().getPrenom()).toLowerCase();
                            String email = p.getPatient().getEmail().toLowerCase();
                            return nomComplet.contains(search) || email.contains(search);
                        })
                        .collect(Collectors.toList());
            }

            // Appliquer le tri
            patientsInfo = applySorting(patientsInfo, sortParam);

            // Calculer les statistiques globales
            long totalPatients = patientsInfo.size();
            long patientsActifs = patientsInfo.stream()
                    .filter(p -> p.hasConsultationRecente())
                    .count();
            long totalConsultations = patientsInfo.stream()
                    .mapToLong(PatientInfo::getTotalConsultations)
                    .sum();

            // Passer les données à la JSP
            request.setAttribute("docteur", docteur);
            request.setAttribute("patientsInfo", patientsInfo);
            request.setAttribute("totalPatients", totalPatients);
            request.setAttribute("patientsActifs", patientsActifs);
            request.setAttribute("totalConsultations", totalConsultations);
            request.setAttribute("filtreSearch", searchParam);
            request.setAttribute("filtreSort", sortParam);

            LOGGER.info("Patients chargés pour docteur ID: " + docteurId +
                    ", Total patients: " + totalPatients +
                    ", Patients actifs: " + patientsActifs);

            request.getRequestDispatcher("/WEB-INF/views/docteur/patients.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors du chargement des patients", e);
            request.setAttribute("error", "Erreur lors du chargement des patients");
            request.getRequestDispatcher("/WEB-INF/views/error/error.jsp")
                    .forward(request, response);
        }
    }

    // Tri des patients
    private List<PatientInfo> applySorting(List<PatientInfo> patients, String sortParam) {
        if (sortParam == null || sortParam.trim().isEmpty()) {
            sortParam = "nom_asc"; // Tri par défaut
        }

        switch (sortParam) {
            case "nom_asc":
                return patients.stream()
                        .sorted(Comparator.comparing(p -> p.getPatient().getNom()))
                        .collect(Collectors.toList());

            case "nom_desc":
                return patients.stream()
                        .sorted(Comparator.comparing((PatientInfo p) -> p.getPatient().getNom())
                                .reversed())
                        .collect(Collectors.toList());

            case "consultations_asc":
                return patients.stream()
                        .sorted(Comparator.comparing(PatientInfo::getTotalConsultations))
                        .collect(Collectors.toList());

            case "consultations_desc":
                return patients.stream()
                        .sorted(Comparator.comparing(PatientInfo::getTotalConsultations)
                                .reversed())
                        .collect(Collectors.toList());

            case "derniere_asc":
                return patients.stream()
                        .sorted(Comparator.comparing(PatientInfo::getDerniereConsultationDate,
                                Comparator.nullsLast(Comparator.naturalOrder())))
                        .collect(Collectors.toList());

            case "derniere_desc":
                return patients.stream()
                        .sorted(Comparator.comparing(PatientInfo::getDerniereConsultationDate,
                                Comparator.nullsFirst(Comparator.reverseOrder())))
                        .collect(Collectors.toList());

            default:
                return patients.stream()
                        .sorted(Comparator.comparing(p -> p.getPatient().getNom()))
                        .collect(Collectors.toList());
        }
    }

    // Classe interne pour stocker les informations du patient avec ses stats
    public static class PatientInfo {
        private final Patient patient;
        private final List<Consultation> consultations;
        private long consultationsTerminees;
        private long consultationsEnCours;
        private java.time.LocalDate derniereConsultationDate;

        public PatientInfo(Patient patient) {
            this.patient = patient;
            this.consultations = new ArrayList<>();
            this.consultationsTerminees = 0;
            this.consultationsEnCours = 0;
            this.derniereConsultationDate = null;
        }

        public void addConsultation(Consultation consultation) {
            consultations.add(consultation);

            if (consultation.getStatut() == StatutConsultation.TERMINEE) {
                consultationsTerminees++;
            }

            if (consultation.getStatut() == StatutConsultation.VALIDEE ||
                    consultation.getStatut() == StatutConsultation.RESERVEE) {
                consultationsEnCours++;
            }

            // Mettre à jour la dernière consultation
            if (derniereConsultationDate == null ||
                    consultation.getDate().isAfter(derniereConsultationDate)) {
                derniereConsultationDate = consultation.getDate();
            }
        }

        public Patient getPatient() {
            return patient;
        }

        public long getTotalConsultations() {
            return consultations.size();
        }

        public long getConsultationsTerminees() {
            return consultationsTerminees;
        }

        public long getConsultationsEnCours() {
            return consultationsEnCours;
        }

        public java.time.LocalDate getDerniereConsultationDate() {
            return derniereConsultationDate;
        }

        public boolean hasConsultationRecente() {
            if (derniereConsultationDate == null) {
                return false;
            }
            // Patient actif = consultation dans les 6 derniers mois
            return derniereConsultationDate.isAfter(
                    java.time.LocalDate.now().minusMonths(6)
            );
        }

        public List<Consultation> getConsultations() {
            return consultations;
        }
    }
}