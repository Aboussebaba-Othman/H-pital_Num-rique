<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Compte Rendu - Clinique Privée</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes pulse-subtle {
            0%, 100% {
                opacity: 1;
                transform: scale(1);
            }
            50% {
                opacity: 0.9;
                transform: scale(1.02);
            }
        }

        @keyframes shimmer {
            0% {
                background-position: -1000px 0;
            }
            100% {
                background-position: 1000px 0;
            }
        }

        .animate-slide-up {
            animation: slideInUp 0.6s ease-out;
        }

        .animate-pulse-subtle {
            animation: pulse-subtle 3s ease-in-out infinite;
        }

        .shimmer {
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            background-size: 1000px 100%;
            animation: shimmer 2s infinite;
        }

        textarea:focus {
            box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.2);
        }

        .template-card:hover {
            transform: translateY(-2px);
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 via-green-50 to-emerald-50 min-h-screen">

<!-- Navigation -->
<jsp:include page="/WEB-INF/views/common/docteur-nav.jsp" />

<!-- Main Content -->
<div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header -->
    <div class="mb-8 animate-slide-up">
        <div class="bg-white rounded-2xl shadow-2xl p-6 border border-gray-100">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-6">
                <div class="flex items-center gap-4">
                    <div class="w-16 h-16 bg-gradient-to-br from-green-500 to-emerald-600 rounded-2xl flex items-center justify-center shadow-xl">
                        <i class="fas fa-file-medical-alt text-white text-3xl"></i>
                    </div>
                    <div>
                        <h1 class="text-3xl font-bold text-gray-900 mb-1">Rédiger le Compte Rendu</h1>
                        <%
                            com.othman.clinique.model.Consultation cons = (com.othman.clinique.model.Consultation) request.getAttribute("consultation");
                            if (cons != null && cons.getDate() != null) {
                                java.time.LocalDate consultationDate = cons.getDate();
                                String dateFormatee = consultationDate.format(DateTimeFormatter.ofPattern("EEEE d MMMM yyyy", Locale.FRENCH));
                                request.setAttribute("dateCompleteConsultation", dateFormatee);
                            }
                        %>
                        <c:if test="${not empty dateCompleteConsultation}">
                            <p class="text-gray-600 capitalize">${dateCompleteConsultation}</p>
                        </c:if>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/docteur/consultation?id=${consultation.idConsultation}"
                   class="px-6 py-3 bg-gradient-to-r from-gray-600 to-gray-700 text-white rounded-xl hover:from-gray-700 hover:to-gray-800 transition shadow-lg hover:shadow-xl transform hover:scale-105 inline-flex items-center font-semibold">
                    <i class="fas fa-arrow-left mr-2"></i>
                    Retour
                </a>
            </div>

            <!-- Status Alert -->
            <div class="bg-gradient-to-r from-blue-500 to-cyan-500 rounded-xl p-5 flex items-center text-white shadow-lg animate-pulse-subtle">
                <div class="w-12 h-12 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center mr-4 shadow-md">
                    <i class="fas fa-info-circle text-3xl"></i>
                </div>
                <div>
                    <p class="font-bold text-lg">Consultation validée prête à être terminée</p>
                    <p class="text-sm text-blue-100">Veuillez rédiger le compte rendu médical pour finaliser cette consultation</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Patient Info Summary -->
    <div class="bg-white rounded-2xl shadow-xl p-6 mb-6 border border-gray-100 animate-slide-up" style="animation-delay: 0.1s">
        <div class="flex items-center justify-between mb-6 pb-4 border-b-2 border-gray-100">
            <h2 class="text-2xl font-bold text-gray-900 flex items-center">
                <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center mr-3 shadow-md">
                    <i class="fas fa-user-injured text-white"></i>
                </div>
                Informations Patient
            </h2>
            <c:if test="${not empty consultation and not empty consultation.patient}">
                <div class="w-14 h-14 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-xl shadow-lg">
                        ${consultation.patient.prenom.substring(0,1)}${consultation.patient.nom.substring(0,1)}
                </div>
            </c:if>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div class="group bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-4 hover:shadow-lg transition-all duration-300 border-l-4 border-blue-500">
                <div class="flex items-center">
                    <div class="w-12 h-12 bg-blue-500 rounded-lg flex items-center justify-center mr-4 shadow-md group-hover:scale-110 transition-transform">
                        <i class="fas fa-user text-white text-xl"></i>
                    </div>
                    <div>
                        <p class="text-xs text-blue-700 font-semibold uppercase">Patient</p>
                        <p class="font-bold text-gray-900 text-lg">
                            <c:if test="${not empty consultation and not empty consultation.patient}">
                                ${consultation.patient.prenom} ${consultation.patient.nom}
                            </c:if>
                        </p>
                    </div>
                </div>
            </div>

            <div class="group bg-gradient-to-br from-green-50 to-green-100 rounded-xl p-4 hover:shadow-lg transition-all duration-300 border-l-4 border-green-500">
                <div class="flex items-center">
                    <div class="w-12 h-12 bg-green-500 rounded-lg flex items-center justify-center mr-4 shadow-md group-hover:scale-110 transition-transform">
                        <i class="fas fa-calendar text-white text-xl"></i>
                    </div>
                    <div>
                        <p class="text-xs text-green-700 font-semibold uppercase">Date et Heure</p>
                        <%
                            if (cons != null && cons.getDate() != null) {
                                String dateCourte = cons.getDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                                request.setAttribute("dateCourteCons", dateCourte);
                            }
                        %>
                        <p class="font-semibold text-gray-900">
                            <c:if test="${not empty dateCourteCons and not empty consultation.heure}">
                                ${dateCourteCons} à ${consultation.heure}
                            </c:if>
                        </p>
                    </div>
                </div>
            </div>

            <div class="group bg-gradient-to-br from-purple-50 to-purple-100 rounded-xl p-4 hover:shadow-lg transition-all duration-300 border-l-4 border-purple-500">
                <div class="flex items-center">
                    <div class="w-12 h-12 bg-purple-500 rounded-lg flex items-center justify-center mr-4 shadow-md group-hover:scale-110 transition-transform">
                        <i class="fas fa-door-open text-white text-xl"></i>
                    </div>
                    <div>
                        <p class="text-xs text-purple-700 font-semibold uppercase">Salle</p>
                        <p class="font-semibold text-gray-900">
                            <c:if test="${not empty consultation and not empty consultation.salle}">
                                ${consultation.salle.nomSalle}
                            </c:if>
                        </p>
                    </div>
                </div>
            </div>

            <div class="group bg-gradient-to-br from-yellow-50 to-yellow-100 rounded-xl p-4 hover:shadow-lg transition-all duration-300 border-l-4 border-yellow-500">
                <div class="flex items-center">
                    <div class="w-12 h-12 bg-yellow-500 rounded-lg flex items-center justify-center mr-4 shadow-md group-hover:scale-110 transition-transform">
                        <i class="fas fa-notes-medical text-white text-xl"></i>
                    </div>
                    <div class="flex-1 min-w-0">
                        <p class="text-xs text-yellow-700 font-semibold uppercase">Motif</p>
                        <p class="font-semibold text-gray-900 truncate">
                            <c:if test="${not empty consultation and not empty consultation.motifConsultation}">
                                ${consultation.motifConsultation}
                            </c:if>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Compte Rendu Form -->
    <div class="bg-white rounded-2xl shadow-xl p-8 mb-6 border border-gray-100 animate-slide-up" style="animation-delay: 0.2s">
        <div class="flex items-center justify-between mb-6 pb-4 border-b-2 border-gray-100">
            <h2 class="text-2xl font-bold text-gray-900 flex items-center">
                <div class="w-10 h-10 bg-gradient-to-br from-green-500 to-emerald-600 rounded-lg flex items-center justify-center mr-3 shadow-md">
                    <i class="fas fa-file-medical text-white"></i>
                </div>
                Compte Rendu Médical
            </h2>
            <span class="px-4 py-2 bg-green-100 text-green-800 rounded-full text-sm font-bold">
                <i class="fas fa-lock-open mr-1"></i> Édition
            </span>
        </div>

        <form action="${pageContext.request.contextPath}/docteur/compte-rendu" method="post" id="compteRenduForm" onsubmit="return validateForm()">
            <input type="hidden" name="consultationId" value="${consultation.idConsultation}">

            <!-- Instructions -->
            <div class="mb-6 bg-gradient-to-r from-green-50 via-emerald-50 to-green-50 rounded-xl p-5 border-2 border-green-200 shadow-md">
                <h3 class="font-bold text-gray-900 mb-3 flex items-center text-lg">
                    <div class="w-8 h-8 bg-yellow-400 rounded-lg flex items-center justify-center mr-3 shadow-md">
                        <i class="fas fa-lightbulb text-white"></i>
                    </div>
                    Instructions pour le compte rendu
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                    <div class="flex items-start bg-white rounded-lg p-3 shadow-sm">
                        <i class="fas fa-check-circle text-green-600 mr-3 mt-1 text-lg"></i>
                        <span class="text-sm text-gray-700">Décrivez les symptômes observés et les plaintes du patient</span>
                    </div>
                    <div class="flex items-start bg-white rounded-lg p-3 shadow-sm">
                        <i class="fas fa-check-circle text-green-600 mr-3 mt-1 text-lg"></i>
                        <span class="text-sm text-gray-700">Notez les examens effectués et leurs résultats</span>
                    </div>
                    <div class="flex items-start bg-white rounded-lg p-3 shadow-sm">
                        <i class="fas fa-check-circle text-green-600 mr-3 mt-1 text-lg"></i>
                        <span class="text-sm text-gray-700">Indiquez le diagnostic établi</span>
                    </div>
                    <div class="flex items-start bg-white rounded-lg p-3 shadow-sm">
                        <i class="fas fa-check-circle text-green-600 mr-3 mt-1 text-lg"></i>
                        <span class="text-sm text-gray-700">Précisez le traitement prescrit et les recommandations</span>
                    </div>
                </div>
            </div>

            <!-- Textarea -->
            <div class="mb-6">
                <label for="compteRendu" class="block text-sm font-bold text-gray-900 mb-3 flex items-center">
                    <i class="fas fa-edit text-green-600 mr-2 text-lg"></i>
                    Rédigez le compte rendu détaillé
                    <span class="text-red-600 ml-1">*</span>
                </label>
                <div class="relative">
                    <textarea
                            id="compteRendu"
                            name="compteRendu"
                            rows="14"
                            required
                            placeholder="Saisissez ici le compte rendu détaillé de la consultation...&#10;&#10;Exemple:&#10;━━━━━━━━━━━━━━━━━━━━&#10;MOTIF DE CONSULTATION:&#10;[Décrivez le motif]&#10;&#10;SYMPTÔMES:&#10;[Listez les symptômes]&#10;&#10;EXAMEN CLINIQUE:&#10;[Résultats de l'examen]&#10;&#10;DIAGNOSTIC:&#10;[Votre diagnostic]&#10;&#10;TRAITEMENT PRESCRIT:&#10;[Détails du traitement]&#10;&#10;RECOMMANDATIONS:&#10;[Conseils et suivi]"
                            class="w-full px-5 py-4 border-2 border-gray-300 rounded-xl focus:ring-4 focus:ring-green-200 focus:border-green-500 resize-none transition-all duration-300 font-mono text-sm"
                    ><c:if test="${not empty consultation and not empty consultation.compteRendu}">${consultation.compteRendu}</c:if></textarea>
                    <div class="absolute bottom-4 right-4 bg-white/90 backdrop-blur-sm px-3 py-1 rounded-lg shadow-md border border-gray-200">
                        <div id="charCount" class="text-xs font-semibold text-gray-600">
                            0 caractères
                        </div>
                    </div>
                </div>
                <div class="flex items-center justify-between mt-3">
                    <p class="text-xs text-gray-500 flex items-center">
                        <i class="fas fa-info-circle mr-2 text-blue-500"></i>
                        Minimum 20 caractères requis
                    </p>
                </div>
            </div>

            <!-- Quick Templates -->
            <div class="mb-8">
                <p class="text-sm font-bold text-gray-900 mb-4 flex items-center">
                <div class="w-8 h-8 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-lg flex items-center justify-center mr-3 shadow-md">
                    <i class="fas fa-bolt text-white"></i>
                </div>
                Modèles rapides (cliquez pour insérer)
                </p>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                    <button type="button" onclick="insertTemplate('examen')"
                            class="template-card group p-4 bg-gradient-to-br from-blue-50 to-cyan-50 hover:from-blue-100 hover:to-cyan-100 border-2 border-blue-200 rounded-xl text-left transition-all duration-300 shadow-md hover:shadow-xl">
                        <div class="flex items-center">
                            <div class="w-10 h-10 bg-blue-500 rounded-lg flex items-center justify-center mr-3 shadow-md group-hover:scale-110 transition-transform">
                                <i class="fas fa-stethoscope text-white text-lg"></i>
                            </div>
                            <div>
                                <span class="font-bold text-gray-900 block">Examen clinique normal</span>
                                <span class="text-xs text-gray-600">Constantes et auscultation</span>
                            </div>
                        </div>
                    </button>

                    <button type="button" onclick="insertTemplate('diagnostic')"
                            class="template-card group p-4 bg-gradient-to-br from-purple-50 to-pink-50 hover:from-purple-100 hover:to-pink-100 border-2 border-purple-200 rounded-xl text-left transition-all duration-300 shadow-md hover:shadow-xl">
                        <div class="flex items-center">
                            <div class="w-10 h-10 bg-purple-500 rounded-lg flex items-center justify-center mr-3 shadow-md group-hover:scale-110 transition-transform">
                                <i class="fas fa-diagnoses text-white text-lg"></i>
                            </div>
                            <div>
                                <span class="font-bold text-gray-900 block">Section diagnostic</span>
                                <span class="text-xs text-gray-600">Diagnostic principal et associés</span>
                            </div>
                        </div>
                    </button>

                    <button type="button" onclick="insertTemplate('traitement')"
                            class="template-card group p-4 bg-gradient-to-br from-green-50 to-emerald-50 hover:from-green-100 hover:to-emerald-100 border-2 border-green-200 rounded-xl text-left transition-all duration-300 shadow-md hover:shadow-xl">
                        <div class="flex items-center">
                            <div class="w-10 h-10 bg-green-500 rounded-lg flex items-center justify-center mr-3 shadow-md group-hover:scale-110 transition-transform">
                                <i class="fas fa-prescription text-white text-lg"></i>
                            </div>
                            <div>
                                <span class="font-bold text-gray-900 block">Traitement prescrit</span>
                                <span class="text-xs text-gray-600">Médicaments et recommandations</span>
                            </div>
                        </div>
                    </button>

                    <button type="button" onclick="insertTemplate('suivi')"
                            class="template-card group p-4 bg-gradient-to-br from-orange-50 to-amber-50 hover:from-orange-100 hover:to-amber-100 border-2 border-orange-200 rounded-xl text-left transition-all duration-300 shadow-md hover:shadow-xl">
                        <div class="flex items-center">
                            <div class="w-10 h-10 bg-orange-500 rounded-lg flex items-center justify-center mr-3 shadow-md group-hover:scale-110 transition-transform">
                                <i class="fas fa-calendar-check text-white text-lg"></i>
                            </div>
                            <div>
                                <span class="font-bold text-gray-900 block">Recommandations de suivi</span>
                                <span class="text-xs text-gray-600">Contrôle et surveillance</span>
                            </div>
                        </div>
                    </button>
                </div>
            </div>

            <!-- Actions -->
            <div class="flex flex-col sm:flex-row gap-4">
                <button type="submit"
                        class="flex-1 px-8 py-5 bg-gradient-to-r from-green-500 via-emerald-500 to-green-600 text-white rounded-xl hover:from-green-600 hover:via-emerald-600 hover:to-green-700 transition-all duration-300 shadow-xl hover:shadow-2xl transform hover:scale-105 flex items-center justify-center font-bold text-lg group">
                    <i class="fas fa-check-circle mr-3 text-2xl group-hover:scale-110 transition-transform"></i>
                    Terminer la Consultation
                </button>

                <a href="${pageContext.request.contextPath}/docteur/consultation?id=${consultation.idConsultation}"
                   class="flex-1 px-8 py-5 bg-gradient-to-r from-gray-600 to-gray-700 text-white rounded-xl hover:from-gray-700 hover:to-gray-800 transition-all duration-300 shadow-lg hover:shadow-xl text-center font-bold text-lg flex items-center justify-center group">
                    <i class="fas fa-times mr-3 group-hover:scale-110 transition-transform"></i>
                    Annuler
                </a>
            </div>

            <div class="mt-6 p-4 bg-red-50 border-2 border-red-200 rounded-xl">
                <p class="text-sm text-red-800 text-center flex items-center justify-center">
                    <i class="fas fa-exclamation-triangle mr-2 text-lg"></i>
                    <span class="font-semibold">Une fois terminée, cette consultation ne pourra plus être modifiée</span>
                </p>
            </div>
        </form>
    </div>

    <!-- Help Card -->
    <div class="bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 rounded-2xl shadow-xl p-6 border-2 border-indigo-200 animate-slide-up" style="animation-delay: 0.3s">
        <div class="flex items-start">
            <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-xl flex items-center justify-center mr-5 shadow-lg flex-shrink-0">
                <i class="fas fa-question-circle text-white text-3xl"></i>
            </div>
            <div>
                <h3 class="font-bold text-gray-900 mb-3 text-xl">Besoin d'aide ?</h3>
                <p class="text-sm text-gray-700 mb-4 leading-relaxed">
                    Le compte rendu doit être précis et complet. Il servira de référence médicale
                    pour le patient et pourra être consulté lors de futures consultations.
                </p>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
                    <div class="bg-white rounded-lg p-3 shadow-sm">
                        <div class="flex items-start">
                            <i class="fas fa-check text-green-600 mr-2 mt-1"></i>
                            <span class="text-sm text-gray-700">Utilisez un langage médical approprié</span>
                        </div>
                    </div>
                    <div class="bg-white rounded-lg p-3 shadow-sm">
                        <div class="flex items-start">
                            <i class="fas fa-check text-green-600 mr-2 mt-1"></i>
                            <span class="text-sm text-gray-700">Soyez factuel et objectif</span>
                        </div>
                    </div>
                    <div class="bg-white rounded-lg p-3 shadow-sm">
                        <div class="flex items-start">
                            <i class="fas fa-check text-green-600 mr-2 mt-1"></i>
                            <span class="text-sm text-gray-700">Relisez avant de soumettre</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<script>
    // Modèles de texte
    const templates = {
        examen: `━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EXAMEN CLINIQUE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

État général: Bon
Température: 37°C
Tension artérielle: 120/80 mmHg
Fréquence cardiaque: 72 bpm
Auscultation pulmonaire: Claire et symétrique
Auscultation cardiaque: Bruits du cœur réguliers

`,
        diagnostic: `━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DIAGNOSTIC:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Diagnostic principal:
Diagnostics associés:

`,
        traitement: `━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TRAITEMENT PRESCRIT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Médicament 1: [Nom] - [Posologie] - [Durée]
Médicament 2: [Nom] - [Posologie] - [Durée]

RECOMMANDATIONS:
• Repos conseillé
• Hydratation importante
• Éviter les efforts physiques intenses

`,
        suivi: `━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUIVI:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Consultation de contrôle dans: [X jours/semaines]
Examens complémentaires à prévoir:
Surveillance particulière de:
Contact en cas d'aggravation des symptômes

`
    };

    // Fonction pour insérer un modèle
    function insertTemplate(type) {
        const textarea = document.getElementById('compteRendu');
        const template = templates[type];

        if (textarea && template) {
            const cursorPos = textarea.selectionStart;
            const textBefore = textarea.value.substring(0, cursorPos);
            const textAfter = textarea.value.substring(cursorPos);

            textarea.value = textBefore + template + textAfter;
            textarea.focus();

            const newPos = cursorPos + template.length;
            textarea.setSelectionRange(newPos, newPos);

            updateCharCount();

            // Animation feedback
            textarea.style.transform = 'scale(1.01)';
            setTimeout(() => {
                textarea.style.transform = 'scale(1)';
            }, 200);
        }
    }

    // Compteur de caractères
    function updateCharCount() {
        const textarea = document.getElementById('compteRendu');
        const charCount = document.getElementById('charCount');
        const count = textarea.value.length;

        charCount.textContent = count + ' caractères';

        if (count < 20) {
            charCount.classList.add('text-red-600');
            charCount.classList.remove('text-green-600');
        } else {
            charCount.classList.add('text-green-600');
            charCount.classList.remove('text-red-600');
        }
    }

    // Validation du formulaire
    function validateForm() {
        const textarea = document.getElementById('compteRendu');
        const value = textarea.value.trim();

        if (value.length < 20) {
            alert('❌ Le compte rendu doit contenir au moins 20 caractères.');
            textarea.focus();
            return false;
        }

        const confirmation = confirm(
            '✅ Êtes-vous sûr de vouloir terminer cette consultation ?\n\n' +
            'Une fois terminée, elle ne pourra plus être modifiée.'
        );

        return confirmation;
    }

    // Event listeners
    document.addEventListener('DOMContentLoaded', function() {
        const textarea = document.getElementById('compteRendu');

        if (textarea) {
            textarea.addEventListener('input', updateCharCount);
            updateCharCount(); // Initial count

            // Auto-resize textarea
            textarea.addEventListener('input', function() {
                this.style.height = 'auto';
                this.style.height = (this.scrollHeight) + 'px';
            });

            // Smooth transitions
            textarea.style.transition = 'all 0.3s ease';
        }
    });

    // Prévenir la perte de données
    window.addEventListener('beforeunload', function(e) {
        const textarea = document.getElementById('compteRendu');
        if (textarea && textarea.value.trim().length > 0) {
            e.preventDefault();
            e.returnValue = '';
        }
    });
</script>

</body>
</html>