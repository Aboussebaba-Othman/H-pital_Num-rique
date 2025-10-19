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
                                <button onclick="toggleDetails(${patientInfo.patient.idPatient})"
                                        class="px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition shadow-md text-sm">
                                    <i class="fas fa-chevron-down"></i>
                                </button>
                            </div>

                            <!-- Détails cachés -->
                            <div id="details-${patientInfo.patient.idPatient}" class="hidden mt-4 pt-4 border-t border-gray-200">
                                <h4 class="font-semibold text-gray-900 mb-3 flex items-center">
                                    <i class="fas fa-clipboard-list text-green-600 mr-2"></i>
                                    Dernières consultations
                                </h4>
                                <div class="space-y-2 max-h-48 overflow-y-auto">
                                    <c:forEach var="consultation" items="${patientInfo.consultations}" end="4">
                                        <div class="p-2 bg-gray-50 rounded-lg text-sm">
                                            <div class="flex items-center justify-between">
                                                <span class="font-semibold text-gray-900">${consultation.dateCourte}</span>
                                                <c:choose>
                                                    <c:when test="${consultation.statut == 'TERMINEE'}">
                                                        <span class="text-xs px-2 py-1 bg-green-100 text-green-800 rounded-full">Terminée</span>
                                                    </c:when>
                                                    <c:when test="${consultation.statut == 'VALIDEE'}">
                                                        <span class="text-xs px-2 py-1 bg-blue-100 text-blue-800 rounded-full">Validée</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-xs px-2 py-1 bg-gray-100 text-gray-800 rounded-full">${consultation.statut}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <p class="text-xs text-gray-600 mt-1">${consultation.motifConsultation}</p>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<!-- Modal Historique Patient -->
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
    function toggleDetails(patientId) {
        const details = document.getElementById('details-' + patientId);
        details.classList.toggle('hidden');
    }

    function showPatientHistory(patientId) {
        // Cette fonction pourrait charger l'historique complet via AJAX
        // Pour l'instant, redirection vers les consultations filtrées
        window.location.href = '${pageContext.request.contextPath}/docteur/consultations?patientId=' + patientId;
    }

    function closeModal() {
        document.getElementById('historyModal').classList.add('hidden');
    }

    // Fermer le modal en cliquant à l'extérieur
    document.getElementById('historyModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });
</script>

</body>
</html>