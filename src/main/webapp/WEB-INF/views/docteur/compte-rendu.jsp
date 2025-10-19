<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Compte Rendu - Clinique Privée</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen">

<!-- Navigation -->
<jsp:include page="/WEB-INF/views/common/docteur-nav.jsp" />

<!-- Main Content -->
<div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header -->
    <div class="mb-8">
        <div class="flex items-center justify-between mb-4">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 mb-2">Rédiger le Compte Rendu</h1>
                <p class="text-gray-600">Consultation du ${consultation.dateFormatee}</p>
            </div>
            <a href="${pageContext.request.contextPath}/docteur/consultation?id=${consultation.idConsultation}"
               class="px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition inline-flex items-center">
                <i class="fas fa-arrow-left mr-2"></i>
                Retour
            </a>
        </div>

        <!-- Status Alert -->
        <div class="bg-blue-100 border-l-4 border-blue-500 text-blue-700 p-4 rounded-lg flex items-center">
            <i class="fas fa-info-circle text-2xl mr-3"></i>
            <div>
                <p class="font-semibold">Consultation validée prête à être terminée</p>
                <p class="text-sm">Veuillez rédiger le compte rendu médical pour finaliser cette consultation</p>
            </div>
        </div>
    </div>

    <!-- Patient Info Summary -->
    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
        <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center border-b pb-3">
            <i class="fas fa-user-injured text-blue-600 mr-3"></i>
            Informations Patient
        </h2>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div class="flex items-center p-3 bg-blue-50 rounded-lg">
                <i class="fas fa-user text-blue-600 text-xl mr-3"></i>
                <div>
                    <p class="text-xs text-gray-600">Patient</p>
                    <p class="font-bold text-gray-900">
                        ${consultation.patient.prenom} ${consultation.patient.nom}
                    </p>
                </div>
            </div>

            <div class="flex items-center p-3 bg-green-50 rounded-lg">
                <i class="fas fa-calendar text-green-600 text-xl mr-3"></i>
                <div>
                    <p class="text-xs text-gray-600">Date et Heure</p>
                    <p class="font-semibold text-gray-900">
                        ${consultation.dateCourte} à ${consultation.heure}
                    </p>
                </div>
            </div>

            <div class="flex items-center p-3 bg-purple-50 rounded-lg">
                <i class="fas fa-door-open text-purple-600 text-xl mr-3"></i>
                <div>
                    <p class="text-xs text-gray-600">Salle</p>
                    <p class="font-semibold text-gray-900">${consultation.salle.nomSalle}</p>
                </div>
            </div>

            <div class="flex items-center p-3 bg-yellow-50 rounded-lg">
                <i class="fas fa-notes-medical text-yellow-600 text-xl mr-3"></i>
                <div>
                    <p class="text-xs text-gray-600">Motif</p>
                    <p class="font-semibold text-gray-900">${consultation.motifConsultation}</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Compte Rendu Form -->
    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
        <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center border-b pb-3">
            <i class="fas fa-file-medical text-green-600 mr-3"></i>
            Compte Rendu Médical
        </h2>

        <form action="${pageContext.request.contextPath}/docteur/compte-rendu" method="post" id="compteRenduForm" onsubmit="return validateForm()">
            <input type="hidden" name="consultationId" value="${consultation.idConsultation}">

            <!-- Instructions -->
            <div class="mb-6 bg-gradient-to-r from-green-50 to-emerald-50 rounded-lg p-4 border border-green-200">
                <h3 class="font-semibold text-gray-900 mb-2 flex items-center">
                    <i class="fas fa-lightbulb text-yellow-500 mr-2"></i>
                    Instructions pour le compte rendu
                </h3>
                <ul class="text-sm text-gray-700 space-y-1 ml-6">
                    <li class="flex items-start">
                        <i class="fas fa-check text-green-600 mr-2 mt-1"></i>
                        <span>Décrivez les symptômes observés et les plaintes du patient</span>
                    </li>
                    <li class="flex items-start">
                        <i class="fas fa-check text-green-600 mr-2 mt-1"></i>
                        <span>Notez les examens effectués et leurs résultats</span>
                    </li>
                    <li class="flex items-start">
                        <i class="fas fa-check text-green-600 mr-2 mt-1"></i>
                        <span>Indiquez le diagnostic établi</span>
                    </li>
                    <li class="flex items-start">
                        <i class="fas fa-check text-green-600 mr-2 mt-1"></i>
                        <span>Précisez le traitement prescrit et les recommandations</span>
                    </li>
                </ul>
            </div>

            <!-- Textarea -->
            <div class="mb-6">
                <label for="compteRendu" class="block text-sm font-semibold text-gray-700 mb-2">
                    <i class="fas fa-edit text-gray-600 mr-2"></i>
                    Rédigez le compte rendu détaillé *
                </label>
                <textarea
                        id="compteRendu"
                        name="compteRendu"
                        rows="12"
                        required
                        placeholder="Saisissez ici le compte rendu détaillé de la consultation...&#10;&#10;Exemple:&#10;- Symptômes: ...&#10;- Examen clinique: ...&#10;- Diagnostic: ...&#10;- Traitement prescrit: ...&#10;- Recommandations: ..."
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent resize-none"
                >${consultation.compteRendu != null ? consultation.compteRendu : ''}</textarea>
                <p class="text-xs text-gray-500 mt-2">
                    <i class="fas fa-info-circle mr-1"></i>
                    Minimum 20 caractères requis
                </p>
                <div id="charCount" class="text-xs text-gray-600 mt-1">
                    0 caractères
                </div>
            </div>

            <!-- Quick Templates -->
            <div class="mb-6">
                <p class="text-sm font-semibold text-gray-700 mb-3">
                    <i class="fas fa-bolt text-yellow-500 mr-2"></i>
                    Modèles rapides (cliquez pour insérer)
                </p>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                    <button type="button" onclick="insertTemplate('examen')"
                            class="p-3 bg-blue-50 hover:bg-blue-100 border border-blue-200 rounded-lg text-left transition text-sm">
                        <i class="fas fa-stethoscope text-blue-600 mr-2"></i>
                        <span class="font-semibold">Examen clinique normal</span>
                    </button>
                    <button type="button" onclick="insertTemplate('diagnostic')"
                            class="p-3 bg-purple-50 hover:bg-purple-100 border border-purple-200 rounded-lg text-left transition text-sm">
                        <i class="fas fa-diagnoses text-purple-600 mr-2"></i>
                        <span class="font-semibold">Section diagnostic</span>
                    </button>
                    <button type="button" onclick="insertTemplate('traitement')"
                            class="p-3 bg-green-50 hover:bg-green-100 border border-green-200 rounded-lg text-left transition text-sm">
                        <i class="fas fa-prescription text-green-600 mr-2"></i>
                        <span class="font-semibold">Traitement prescrit</span>
                    </button>
                    <button type="button" onclick="insertTemplate('suivi')"
                            class="p-3 bg-orange-50 hover:bg-orange-100 border border-orange-200 rounded-lg text-left transition text-sm">
                        <i class="fas fa-calendar-check text-orange-600 mr-2"></i>
                        <span class="font-semibold">Recommandations de suivi</span>
                    </button>
                </div>
            </div>

            <!-- Actions -->
            <div class="flex flex-col sm:flex-row gap-3">
                <button type="submit"
                        class="flex-1 px-6 py-4 bg-gradient-to-r from-green-600 to-emerald-600 text-white rounded-lg hover:from-green-700 hover:to-emerald-700 transition shadow-lg hover:shadow-xl transform hover:scale-105 flex items-center justify-center font-semibold">
                    <i class="fas fa-check-circle mr-2 text-xl"></i>
                    Terminer la Consultation
                </button>

                <a href="${pageContext.request.contextPath}/docteur/consultation?id=${consultation.idConsultation}"
                   class="flex-1 px-6 py-4 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition shadow-md text-center font-semibold flex items-center justify-center">
                    <i class="fas fa-times mr-2"></i>
                    Annuler
                </a>
            </div>

            <p class="text-xs text-gray-500 text-center mt-4">
                <i class="fas fa-shield-alt mr-1"></i>
                Une fois terminée, cette consultation ne pourra plus être modifiée
            </p>
        </form>
    </div>

    <!-- Help Card -->
    <div class="bg-gradient-to-br from-blue-50 to-indigo-50 rounded-xl shadow-md p-6 border border-blue-200">
        <div class="flex items-start">
            <i class="fas fa-question-circle text-blue-600 text-3xl mr-4"></i>
            <div>
                <h3 class="font-bold text-gray-900 mb-2">Besoin d'aide ?</h3>
                <p class="text-sm text-gray-700 mb-3">
                    Le compte rendu doit être précis et complet. Il servira de référence médicale
                    pour le patient et pourra être consulté lors de futures consultations.
                </p>
                <ul class="text-sm text-gray-700 space-y-1">
                    <li class="flex items-start">
                        <i class="fas fa-chevron-right text-blue-600 mr-2 mt-1 text-xs"></i>
                        <span>Utilisez un langage médical approprié</span>
                    </li>
                    <li class="flex items-start">
                        <i class="fas fa-chevron-right text-blue-600 mr-2 mt-1 text-xs"></i>
                        <span>Soyez factuel et objectif dans vos observations</span>
                    </li>
                    <li class="flex items-start">
                        <i class="fas fa-chevron-right text-blue-600 mr-2 mt-1 text-xs"></i>
                        <span>Relisez avant de soumettre</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>

</div>

<script>
    // Modèles de texte
    const templates = {
        examen: `EXAMEN CLINIQUE:
- État général: Bon
- Température: 37°C
- Tension artérielle: 120/80 mmHg
- Fréquence cardiaque: 72 bpm
- Auscultation pulmonaire: Claire et symétrique
- Auscultation cardiaque: Bruits du cœur réguliers

`,
        diagnostic: `DIAGNOSTIC:
- Diagnostic principal:
- Diagnostics associés:

`,
        traitement: `TRAITEMENT PRESCRIT:
- Médicament 1: [Nom] - [Posologie] - [Durée]
- Médicament 2: [Nom] - [Posologie] - [Durée]

RECOMMANDATIONS:
- Repos conseillé
- Hydratation importante
- Éviter les efforts physiques intenses

`,
        suivi: `SUIVI:
- Consultation de contrôle dans: [X jours/semaines]
- Examens complémentaires à prévoir:
- Surveillance particulière de:
- Contact en cas d'aggravation des symptômes

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

            // Placer le curseur après le texte inséré
            const newPos = cursorPos + template.length;
            textarea.setSelectionRange(newPos, newPos);

            updateCharCount();
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

        // Confirmation
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

<style>
    @keyframes pulse-subtle {
        0%, 100% {
            opacity: 1;
        }
        50% {
            opacity: 0.8;
        }
    }

    .animate-pulse-subtle {
        animation: pulse-subtle 2s ease-in-out infinite;
    }
</style>

</body>
</html>