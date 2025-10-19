<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Patients - Clinique Privée</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .modal-content {
            animation: slideIn 0.3s ease-out;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen">

<!-- Navigation -->
<jsp:include page="/WEB-INF/views/common/docteur-nav.jsp" />

<!-- Main Content -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Mes Patients</h1>
        <p class="text-gray-600">Consultez la liste de vos patients et leur historique médical</p>
    </div>

    <!-- Statistiques -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl shadow-lg p-6 text-white">
            <div class="flex items-center justify-between mb-4">
                <div class="w-14 h-14 bg-white/20 rounded-full flex items-center justify-center">
                    <i class="fas fa-users text-3xl"></i>
                </div>
                <span class="text-xs font-semibold bg-white/20 px-3 py-1 rounded-full">Total</span>
            </div>
            <p class="text-4xl font-bold mb-2">${totalPatients}</p>
            <p class="text-sm text-blue-100">Patients suivis</p>
        </div>

        <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-xl shadow-lg p-6 text-white">
            <div class="flex items-center justify-between mb-4">
                <div class="w-14 h-14 bg-white/20 rounded-full flex items-center justify-center">
                    <i class="fas fa-user-check text-3xl"></i>
                </div>
                <span class="text-xs font-semibold bg-white/20 px-3 py-1 rounded-full">Actifs</span>
            </div>
            <p class="text-4xl font-bold mb-2">${patientsActifs}</p>
            <p class="text-sm text-green-100">Consultation récente (6 mois)</p>
        </div>

        <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl shadow-lg p-6 text-white">
            <div class="flex items-center justify-between mb-4">
                <div class="w-14 h-14 bg-white/20 rounded-full flex items-center justify-center">
                    <i class="fas fa-clipboard-list text-3xl"></i>
                </div>
                <span class="text-xs font-semibold bg-white/20 px-3 py-1 rounded-full">Total</span>
            </div>
            <p class="text-4xl font-bold mb-2">${totalConsultations}</p>
            <p class="text-sm text-purple-100">Consultations réalisées</p>
        </div>
    </div>

    <!-- Recherche et Tri -->
    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <!-- Recherche -->
            <form method="get" action="${pageContext.request.contextPath}/docteur/patients" class="flex-1">
                <div class="relative">
                    <input type="text"
                           name="search"
                           value="${filtreSearch}"
                           placeholder="Rechercher un patient (nom, email)..."
                           class="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    <i class="fas fa-search absolute left-4 top-4 text-gray-400"></i>
                </div>
            </form>

            <!-- Tri -->
            <div class="flex items-center gap-2">
                <label class="text-sm font-medium text-gray-700 whitespace-nowrap">Trier par:</label>
                <select onchange="window.location.href='?sort=' + this.value + '${filtreSearch != null ? "&search=" += filtreSearch : ""}'"
                        class="px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                    <option value="nom_asc" ${filtreSort == 'nom_asc' || filtreSort == null ? 'selected' : ''}>Nom (A-Z)</option>
                    <option value="nom_desc" ${filtreSort == 'nom_desc' ? 'selected' : ''}>Nom (Z-A)</option>
                    <option value="consultations_desc" ${filtreSort == 'consultations_desc' ? 'selected' : ''}>Plus de consultations</option>
                    <option value="consultations_asc" ${filtreSort == 'consultations_asc' ? 'selected' : ''}>Moins de consultations</option>
                    <option value="derniere_desc" ${filtreSort == 'derniere_desc' ? 'selected' : ''}>Dernière consultation (récente)</option>
                    <option value="derniere_asc" ${filtreSort == 'derniere_asc' ? 'selected' : ''}>Dernière consultation (ancienne)</option>
                </select>
            </div>
        </div>
    </div>

    <!-- Liste des Patients -->
    <div class="bg-white rounded-xl shadow-lg p-6">
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold text-gray-900 flex items-center">
                <i class="fas fa-list text-green-600 mr-3"></i>
                Liste des Patients (${totalPatients})
            </h2>
        </div>

        <c:choose>
            <c:when test="${empty patientsInfo}">
                <div class="text-center py-12 bg-gray-50 rounded-xl border-2 border-dashed border-gray-300">
                    <i class="fas fa-user-slash text-gray-400 text-6xl mb-4"></i>
                    <p class="text-gray-600 text-lg font-medium">Aucun patient trouvé</p>
                    <p class="text-gray-500 text-sm mt-2">Essayez de modifier votre recherche</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:forEach var="patientInfo" items="${patientsInfo}">
                        <div class="group bg-gradient-to-br from-white to-gray-50 rounded-xl shadow-md hover:shadow-xl transition-all duration-300 p-6 border border-gray-200 hover:border-blue-300">
                            <!-- Header Patient -->
                            <div class="flex items-start justify-between mb-4">
                                <div class="flex items-center">
                                    <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-xl mr-4 shadow-lg group-hover:scale-110 transition-transform">
                                            ${patientInfo.patient.prenom.substring(0,1)}${patientInfo.patient.nom.substring(0,1)}
                                    </div>
                                    <div>
                                        <h3 class="font-bold text-gray-900 text-lg">
                                                ${patientInfo.patient.prenom} ${patientInfo.patient.nom}
                                        </h3>
                                        <c:if test="${patientInfo.hasConsultationRecente()}">
                                            <span class="inline-flex items-center px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs font-semibold">
                                                <i class="fas fa-check-circle mr-1"></i> Actif
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <!-- Informations -->
                            <div class="space-y-3 mb-4">
                                <div class="flex items-center text-sm text-gray-600">
                                    <i class="fas fa-envelope text-blue-500 w-5 mr-2"></i>
                                    <span class="truncate">${patientInfo.patient.email}</span>
                                </div>

                                <c:if test="${patientInfo.patient.poids != null}">
                                    <div class="flex items-center text-sm text-gray-600">
                                        <i class="fas fa-weight text-purple-500 w-5 mr-2"></i>
                                        <span>${patientInfo.patient.poids} kg</span>
                                    </div>
                                </c:if>

                                <c:if test="${patientInfo.patient.taille != null}">
                                    <div class="flex items-center text-sm text-gray-600">
                                        <i class="fas fa-ruler-vertical text-purple-500 w-5 mr-2"></i>
                                        <span>${patientInfo.patient.taille} m</span>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Statistiques -->
                            <div class="grid grid-cols-3 gap-3 mb-4 p-3 bg-white/60 rounded-lg border border-gray-200">
                                <div class="text-center">
                                    <p class="text-2xl font-bold text-blue-600">${patientInfo.totalConsultations}</p>
                                    <p class="text-xs text-gray-600">Total</p>
                                </div>
                                <div class="text-center">
                                    <p class="text-2xl font-bold text-green-600">${patientInfo.consultationsTerminees}</p>
                                    <p class="text-xs text-gray-600">Terminées</p>
                                </div>
                                <div class="text-center">
                                    <p class="text-2xl font-bold text-yellow-600">${patientInfo.consultationsEnCours}</p>
                                    <p class="text-xs text-gray-600">En cours</p>
                                </div>
                            </div>

                            <!-- Dernière consultation -->
                            <c:if test="${patientInfo.derniereConsultationDate != null}">
                                <div class="mb-4 p-3 bg-blue-50 rounded-lg border border-blue-200">
                                    <p class="text-xs text-gray-600 mb-1">Dernière consultation</p>
                                    <p class="text-sm font-semibold text-gray-900">
                                        <i class="fas fa-calendar text-blue-600 mr-1"></i>
                                            ${patientInfo.derniereConsultationDate}
                                    </p>
                                </div>
                            </c:if>

                            <!-- Actions -->
                            <div class="flex gap-2">
                                <button onclick="showPatientHistory(${patientInfo.patient.idPatient})"
                                        class="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition shadow-md hover:shadow-lg text-sm font-semibold">
                                    <i class="fas fa-history mr-1"></i> Historique
                                </button>
                                <button onclick="showPatientDetails(${patientInfo.patient.idPatient}, '${patientInfo.patient.prenom}', '${patientInfo.patient.nom}')"
                                        data-patient-id="${patientInfo.patient.idPatient}"
                                        data-total="${patientInfo.totalConsultations}"
                                        data-terminees="${patientInfo.consultationsTerminees}"
                                        data-encours="${patientInfo.consultationsEnCours}"
                                        class="px-4 py-2 bg-gradient-to-r from-purple-600 to-blue-600 text-white rounded-lg hover:from-purple-700 hover:to-blue-700 transition shadow-md text-sm font-semibold">
                                    <i class="fas fa-info-circle"></i>
                                </button>
                            </div>

                            <!-- Détails cachés (données pour le modal) -->
                            <div id="consultations-data-${patientInfo.patient.idPatient}" class="hidden">
                                <c:forEach var="consultation" items="${patientInfo.consultations}" end="9" varStatus="status">
                                    <div class="consultation-item"
                                         data-id="${consultation.idConsultation}"
                                         data-date="${consultation.dateCourte}"
                                         data-heure="${consultation.heureFormatee}"
                                         data-motif="${consultation.motifConsultation}"
                                         data-statut="${consultation.statut}"></div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<!-- Modal Détails Patient -->
<div id="detailsModal" class="hidden fixed inset-0 bg-black bg-opacity-60 z-50 flex items-center justify-center p-4 backdrop-blur-sm">
    <div class="bg-white rounded-2xl shadow-2xl max-w-3xl w-full max-h-[85vh] overflow-hidden modal-content">
        <!-- Header Modal -->
        <div class="bg-gradient-to-r from-purple-600 via-blue-600 to-purple-600 p-6 text-white relative overflow-hidden">
            <div class="absolute inset-0 bg-white opacity-10"></div>
            <div class="relative z-10 flex items-center justify-between">
                <div class="flex items-center">
                    <div class="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center text-2xl font-bold mr-4 shadow-lg">
                        <span id="modalInitials"></span>
                    </div>
                    <div>
                        <h3 class="text-2xl font-bold" id="modalPatientName"></h3>
                        <p class="text-blue-100 text-sm">Détails des consultations</p>
                    </div>
                </div>
                <button onclick="closeDetailsModal()" class="text-white hover:text-gray-200 transition hover:rotate-90 transform duration-300">
                    <i class="fas fa-times text-3xl"></i>
                </button>
            </div>
        </div>

        <!-- Body Modal -->
        <div id="modalDetailsContent" class="p-6 overflow-y-auto max-h-[calc(85vh-120px)]">
            <!-- Section Statistiques -->
            <div class="grid grid-cols-3 gap-4 mb-6">
                <div class="bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-4 border-l-4 border-blue-600">
                    <div class="flex items-center justify-between mb-2">
                        <i class="fas fa-clipboard-list text-blue-600 text-2xl"></i>
                        <span class="text-xs font-semibold text-blue-600 uppercase">Total</span>
                    </div>
                    <p class="text-3xl font-bold text-blue-700" id="modalTotalConsultations">0</p>
                    <p class="text-xs text-gray-600 mt-1">Consultations</p>
                </div>
                <div class="bg-gradient-to-br from-green-50 to-green-100 rounded-xl p-4 border-l-4 border-green-600">
                    <div class="flex items-center justify-between mb-2">
                        <i class="fas fa-check-circle text-green-600 text-2xl"></i>
                        <span class="text-xs font-semibold text-green-600 uppercase">Terminées</span>
                    </div>
                    <p class="text-3xl font-bold text-green-700" id="modalTerminees">0</p>
                    <p class="text-xs text-gray-600 mt-1">Complétées</p>
                </div>
                <div class="bg-gradient-to-br from-yellow-50 to-yellow-100 rounded-xl p-4 border-l-4 border-yellow-600">
                    <div class="flex items-center justify-between mb-2">
                        <i class="fas fa-clock text-yellow-600 text-2xl"></i>
                        <span class="text-xs font-semibold text-yellow-600 uppercase">En cours</span>
                    </div>
                    <p class="text-3xl font-bold text-yellow-700" id="modalEnCours">0</p>
                    <p class="text-xs text-gray-600 mt-1">Active</p>
                </div>
            </div>

            <!-- Section Consultations -->
            <div class="mb-4">
                <h4 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-list-ul text-purple-600 mr-2"></i>
                    Historique des Consultations
                </h4>
                <div id="consultationsList" class="space-y-3">
                    <!-- Les consultations seront insérées ici -->
                </div>
            </div>
        </div>

        <!-- Footer Modal -->
        <div class="bg-gray-50 px-6 py-4 border-t border-gray-200 flex justify-end gap-3">
            <button onclick="closeDetailsModal()"
                    class="px-6 py-2.5 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition shadow-md font-semibold">
                <i class="fas fa-times mr-2"></i>Fermer
            </button>
            <button onclick="viewFullHistory()"
                    class="px-6 py-2.5 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-lg hover:from-blue-700 hover:to-purple-700 transition shadow-md font-semibold">
                <i class="fas fa-history mr-2"></i>Historique complet
            </button>
        </div>
    </div>
</div>

<!-- Modal Historique Patient (existant) -->
<div id="historyModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-hidden">
        <div class="bg-gradient-to-r from-blue-600 to-purple-600 p-6 text-white">
            <div class="flex items-center justify-between">
                <h3 class="text-2xl font-bold flex items-center">
                    <i class="fas fa-history mr-3"></i>
                    Historique Complet
                </h3>
                <button onclick="closeModal()" class="text-white hover:text-gray-200 transition">
                    <i class="fas fa-times text-2xl"></i>
                </button>
            </div>
        </div>
        <div id="modalContent" class="p-6 overflow-y-auto max-h-[calc(90vh-100px)]">
            <!-- Contenu chargé dynamiquement -->
        </div>
    </div>
</div>

<script>
    // Variable pour stocker l'ID du patient actuel
    let currentPatientId = null;

    function showPatientDetails(patientId, prenom, nom) {
        currentPatientId = patientId;

        // Mettre à jour le nom et les initiales
        document.getElementById('modalPatientName').textContent = prenom + ' ' + nom;
        document.getElementById('modalInitials').textContent = prenom.substring(0,1) + nom.substring(0,1);

        // Récupérer les statistiques depuis le bouton
        var button = document.querySelector('[data-patient-id="' + patientId + '"]');
        var total = button.getAttribute('data-total') || '0';
        var terminees = button.getAttribute('data-terminees') || '0';
        var encours = button.getAttribute('data-encours') || '0';

        document.getElementById('modalTotalConsultations').textContent = total;
        document.getElementById('modalTerminees').textContent = terminees;
        document.getElementById('modalEnCours').textContent = encours;

        // Charger les vraies consultations
        loadConsultations(patientId);

        // Afficher le modal
        document.getElementById('detailsModal').classList.remove('hidden');
        document.body.style.overflow = 'hidden';
    }

    function loadConsultations(patientId) {
        var consultationsContainer = document.getElementById('consultations-data-' + patientId);
        var consultationsList = document.getElementById('consultationsList');

        console.log('Loading consultations for patient:', patientId);
        console.log('Container found:', consultationsContainer);

        if (!consultationsContainer) {
            consultationsList.innerHTML = `
                <div class="text-center py-12 bg-gradient-to-r from-gray-50 to-gray-100 rounded-xl border-2 border-dashed border-gray-300">
                    <i class="fas fa-calendar-times text-5xl text-gray-300 mb-4"></i>
                    <p class="text-gray-600 font-bold text-lg">Aucune consultation</p>
                    <p class="text-gray-500 text-sm mt-2">Ce patient n'a pas encore de consultations enregistrées</p>
                </div>
            `;
            return;
        }

        var consultations = consultationsContainer.querySelectorAll('.consultation-item');
        console.log('Number of consultations found:', consultations.length);

        if (consultations.length === 0) {
            consultationsList.innerHTML = `
                <div class="text-center py-12 bg-gradient-to-r from-gray-50 to-gray-100 rounded-xl border-2 border-dashed border-gray-300">
                    <i class="fas fa-calendar-times text-5xl text-gray-300 mb-4"></i>
                    <p class="text-gray-600 font-bold text-lg">Aucune consultation</p>
                    <p class="text-gray-500 text-sm mt-2">Ce patient n'a pas encore de consultations enregistrées</p>
                </div>
            `;
            return;
        }

        var html = '';
        for (var i = 0; i < consultations.length; i++) {
            var consultation = consultations[i];
            var id = consultation.getAttribute('data-id') || '';
            var date = consultation.getAttribute('data-date') || 'Date non disponible';
            var heure = consultation.getAttribute('data-heure') || '';
            var motif = consultation.getAttribute('data-motif') || 'Aucun motif spécifié';
            var statut = consultation.getAttribute('data-statut') || '';

            console.log('Consultation ' + (i+1) + ':', {id: id, date: date, heure: heure, motif: motif, statut: statut});

            var statusClass, statusIcon, statusText, borderColor;

            if (statut === 'TERMINEE') {
                statusClass = 'bg-green-100 text-green-800 border-green-300';
                statusIcon = 'fa-check-circle';
                statusText = 'Terminée';
                borderColor = 'border-green-600';
            } else if (statut === 'VALIDEE') {
                statusClass = 'bg-blue-100 text-blue-800 border-blue-300';
                statusIcon = 'fa-check';
                statusText = 'Validée';
                borderColor = 'border-blue-600';
            } else if (statut === 'RESERVEE') {
                statusClass = 'bg-yellow-100 text-yellow-800 border-yellow-300';
                statusIcon = 'fa-hourglass-half';
                statusText = 'Réservée';
                borderColor = 'border-yellow-600';
            } else {
                statusClass = 'bg-gray-100 text-gray-800 border-gray-300';
                statusIcon = 'fa-info-circle';
                statusText = statut || 'Statut inconnu';
                borderColor = 'border-gray-600';
            }

            html += `
                <div class="bg-gradient-to-r from-gray-50 to-white rounded-xl p-4 border-l-4 ` + borderColor + ` hover:shadow-lg transition-all duration-300 cursor-pointer group"
                     onclick="window.location.href='${pageContext.request.contextPath}/docteur/consultation?id=` + id + `'">
                    <div class="flex items-start justify-between">
                        <div class="flex items-center flex-1">
                            <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold mr-3 shadow-md group-hover:scale-110 transition-transform">
                                ` + (i + 1) + `
                            </div>
                            <div class="flex-1">
                                <div class="flex items-center gap-2 mb-2">
                                    <p class="font-bold text-gray-900 text-base flex items-center">
                                        <i class="fas fa-calendar-day text-blue-600 mr-2"></i>
                                        ` + date + `
                                    </p>
                                    ` + (heure ? `<span class="text-sm text-purple-600 font-semibold flex items-center">
                                        <i class="fas fa-clock mr-1"></i>` + heure + `
                                    </span>` : '') + `
                                </div>
                                <p class="text-sm text-gray-600 flex items-start">
                                    <i class="fas fa-stethoscope text-purple-500 mr-2 mt-0.5 flex-shrink-0"></i>
                                    <span class="flex-1">` + motif + `</span>
                                </p>
                            </div>
                        </div>
                        <span class="text-xs px-3 py-1.5 ` + statusClass + ` rounded-full font-semibold border flex items-center whitespace-nowrap ml-2">
                            <i class="fas ` + statusIcon + ` mr-1"></i>
                            ` + statusText + `
                        </span>
                    </div>
                    <div class="flex items-center justify-end mt-2 opacity-0 group-hover:opacity-100 transition-opacity">
                        <span class="text-xs text-blue-600 font-semibold flex items-center">
                            Voir détails
                            <i class="fas fa-arrow-right ml-1 group-hover:translate-x-1 transition-transform"></i>
                        </span>
                    </div>
                </div>
            `;
        }

        consultationsList.innerHTML = html;
        console.log('Consultations loaded successfully');
    }

    function closeDetailsModal() {
        document.getElementById('detailsModal').classList.add('hidden');
        document.body.style.overflow = 'auto';
    }

    function viewFullHistory() {
        closeDetailsModal();
        showPatientHistory(currentPatientId);
    }

    function showPatientHistory(patientId) {
        window.location.href = '${pageContext.request.contextPath}/docteur/consultations?patientId=' + patientId;
    }

    function closeModal() {
        document.getElementById('historyModal').classList.add('hidden');
    }

    // Fermer les modals en cliquant à l'extérieur
    document.getElementById('detailsModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeDetailsModal();
        }
    });

    document.getElementById('historyModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });

    // Fermer avec la touche Échap
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeDetailsModal();
            closeModal();
        }
    });
</script>

</body>
</html>