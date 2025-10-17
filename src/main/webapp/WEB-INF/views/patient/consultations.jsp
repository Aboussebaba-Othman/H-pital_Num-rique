<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://clinique.othman.com/functions" prefix="df" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Consultations - Clinique</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">

<!-- Définir la page active pour la sidebar -->
<c:set var="pageParam" value="consultations" scope="request"/>

<!-- Inclure la sidebar patient -->
<%@ include file="../common/patient-nav.jsp" %>

<!-- Contenu principal -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    
    <!-- En-tête -->
    <div class="mb-8">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between">
            <div class="mb-4 md:mb-0">
                <h1 class="text-3xl font-bold text-gray-900 flex items-center">
                    <i class="fas fa-calendar-check text-indigo-600 mr-3"></i>
                    Mes Consultations
                </h1>
                <p class="mt-2 text-gray-600">Gérez vos rendez-vous médicaux</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/patient/reserver" 
                   class="inline-flex items-center px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-lg hover:shadow-xl transition duration-200">
                    <i class="fas fa-plus mr-2"></i>
                    Nouvelle consultation
                </a>
            </div>
        </div>
    </div>

    <!-- Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="mb-6 bg-green-50 border-l-4 border-green-500 p-4 rounded-r-lg shadow">
            <div class="flex items-center">
                <i class="fas fa-check-circle text-green-500 text-xl mr-3"></i>
                <p class="text-green-800 font-medium">${sessionScope.successMessage}</p>
            </div>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 rounded-r-lg shadow">
            <div class="flex items-center">
                <i class="fas fa-exclamation-circle text-red-500 text-xl mr-3"></i>
                <p class="text-red-800 font-medium">${sessionScope.errorMessage}</p>
            </div>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <!-- Consultations à venir -->
    <div class="mb-8 bg-white rounded-2xl shadow-lg overflow-hidden">
        <div class="bg-gradient-to-r from-indigo-600 to-purple-600 px-6 py-4">
            <h2 class="text-xl font-bold text-white flex items-center">
                <i class="fas fa-calendar-alt mr-3"></i>
                Consultations à venir
            </h2>
        </div>
        <div class="p-6">
            <c:choose>
                <c:when test="${empty consultationsFutures}">
                    <div class="text-center py-12">
                        <div class="inline-flex items-center justify-center w-20 h-20 bg-gray-100 rounded-full mb-4">
                            <i class="fas fa-calendar-times text-gray-400 text-3xl"></i>
                        </div>
                        <p class="text-gray-500 text-lg">Aucune consultation à venir</p>
                        <a href="${pageContext.request.contextPath}/patient/reserver" 
                           class="inline-block mt-4 text-indigo-600 hover:text-indigo-800 font-medium">
                            Réserver une consultation →
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="space-y-4">
                        <c:forEach items="${consultationsFutures}" var="consultation">
                            <div class="border border-gray-200 rounded-xl p-6 hover:shadow-md transition duration-200">
                                <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                                    <!-- Info principale -->
                                    <div class="flex-1">
                                        <div class="flex items-start gap-4">
                                            <!-- Icône calendrier -->
                                            <div class="flex-shrink-0">
                                                <div class="w-16 h-16 bg-indigo-100 rounded-xl flex flex-col items-center justify-center">
                                                    <span class="text-xs text-indigo-600 font-semibold uppercase">
                                                        ${df:formatDate(consultation.date).substring(3, 6)}
                                                    </span>
                                                    <span class="text-2xl font-bold text-indigo-600">
                                                        ${df:formatDate(consultation.date).substring(0, 2)}
                                                    </span>
                                                </div>
                                            </div>
                                            
                                            <!-- Détails -->
                                            <div class="flex-1 min-w-0">
                                                <div class="flex items-center gap-3 mb-2">
                                                    <h3 class="text-lg font-semibold text-gray-900">
                                                        Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom}
                                                    </h3>
                                                    <c:choose>
                                                        <c:when test="${consultation.statut == 'RESERVEE'}">
                                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-yellow-100 text-yellow-800">
                                                                <i class="fas fa-clock mr-1.5"></i>Réservée
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${consultation.statut == 'VALIDEE'}">
                                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800">
                                                                <i class="fas fa-check mr-1.5"></i>Validée
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${consultation.statut == 'TERMINEE'}">
                                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
                                                                <i class="fas fa-check-circle mr-1.5"></i>Terminée
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${consultation.statut == 'ANNULEE'}">
                                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-800">
                                                                <i class="fas fa-times-circle mr-1.5"></i>Annulée
                                                            </span>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                                <p class="text-sm text-indigo-600 font-medium mb-2">
                                                    <i class="fas fa-stethoscope mr-1"></i>
                                                    ${consultation.docteur.specialite}
                                                </p>
                                                <div class="flex flex-wrap items-center gap-4 text-sm text-gray-600">
                                                    <span class="flex items-center">
                                                        <i class="fas fa-clock mr-2 text-gray-400"></i>
                                                        ${df:formatTime(consultation.heure)}
                                                    </span>
                                                    <span class="flex items-center">
                                                        <i class="fas fa-notes-medical mr-2 text-gray-400"></i>
                                                        <span class="truncate max-w-xs" title="${consultation.motifConsultation}">
                                                            ${consultation.motifConsultation}
                                                        </span>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Actions -->
                                    <div class="flex-shrink-0">
                                        <c:if test="${consultation.statut == 'RESERVEE' || consultation.statut == 'VALIDEE'}">
                                            <button type="button" 
                                                    data-consultation-id="${consultation.idConsultation}"
                                                    class="btn-annuler inline-flex items-center px-4 py-2 bg-red-50 hover:bg-red-100 text-red-700 font-medium rounded-lg transition duration-200">
                                                <i class="fas fa-times mr-2"></i>
                                                Annuler
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Consultations passées -->
    <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
        <div class="bg-gradient-to-r from-gray-700 to-gray-900 px-6 py-4">
            <h2 class="text-xl font-bold text-white flex items-center">
                <i class="fas fa-history mr-3"></i>
                Consultations passées
            </h2>
        </div>
        <div class="p-6">
            <c:choose>
                <c:when test="${empty consultationsPassees}">
                    <div class="text-center py-12">
                        <div class="inline-flex items-center justify-center w-20 h-20 bg-gray-100 rounded-full mb-4">
                            <i class="fas fa-inbox text-gray-400 text-3xl"></i>
                        </div>
                        <p class="text-gray-500 text-lg">Aucune consultation passée</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="space-y-4">
                        <c:forEach items="${consultationsPassees}" var="consultation">
                            <div class="border border-gray-200 rounded-xl p-6 hover:shadow-md transition duration-200 bg-gray-50">
                                <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                                    <!-- Info principale -->
                                    <div class="flex-1">
                                        <div class="flex items-start gap-4">
                                            <!-- Icône calendrier -->
                                            <div class="flex-shrink-0">
                                                <div class="w-16 h-16 bg-gray-200 rounded-xl flex flex-col items-center justify-center">
                                                    <span class="text-xs text-gray-600 font-semibold uppercase">
                                                        ${df:formatDate(consultation.date).substring(3, 6)}
                                                    </span>
                                                    <span class="text-2xl font-bold text-gray-700">
                                                        ${df:formatDate(consultation.date).substring(0, 2)}
                                                    </span>
                                                </div>
                                            </div>
                                            
                                            <!-- Détails -->
                                            <div class="flex-1 min-w-0">
                                                <div class="flex items-center gap-3 mb-2">
                                                    <h3 class="text-lg font-semibold text-gray-900">
                                                        Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom}
                                                    </h3>
                                                    <c:choose>
                                                        <c:when test="${consultation.statut == 'TERMINEE'}">
                                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
                                                                <i class="fas fa-check-circle mr-1.5"></i>Terminée
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${consultation.statut == 'ANNULEE'}">
                                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-800">
                                                                <i class="fas fa-times-circle mr-1.5"></i>Annulée
                                                            </span>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                                <p class="text-sm text-gray-600 font-medium mb-2">
                                                    <i class="fas fa-stethoscope mr-1"></i>
                                                    ${consultation.docteur.specialite}
                                                </p>
                                                <div class="flex flex-wrap items-center gap-4 text-sm text-gray-600">
                                                    <span class="flex items-center">
                                                        <i class="fas fa-clock mr-2 text-gray-400"></i>
                                                        ${df:formatTime(consultation.heure)}
                                                    </span>
                                                    <span class="flex items-center">
                                                        <i class="fas fa-notes-medical mr-2 text-gray-400"></i>
                                                        <span class="truncate max-w-xs" title="${consultation.motifConsultation}">
                                                            ${consultation.motifConsultation}
                                                        </span>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Actions -->
                                    <div class="flex-shrink-0">
                                        <c:if test="${consultation.statut == 'TERMINEE' && not empty consultation.compteRendu}">
                                            <button type="button" 
                                                    data-consultation-id="${consultation.idConsultation}"
                                                    class="btn-compte-rendu inline-flex items-center px-4 py-2 bg-sky-50 hover:bg-sky-100 text-sky-700 font-medium rounded-lg transition duration-200">
                                                <i class="fas fa-file-alt mr-2"></i>
                                                Compte-rendu
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <!-- Modal Compte-rendu (inline, caché par défaut) -->
                                <c:if test="${consultation.statut == 'TERMINEE' && not empty consultation.compteRendu}">
                                    <div id="modal-${consultation.idConsultation}" class="hidden mt-4 p-4 bg-white border-t-2 border-sky-200 rounded-lg">
                                        <h4 class="font-bold text-gray-900 mb-3 flex items-center">
                                            <i class="fas fa-file-medical text-sky-600 mr-2"></i>
                                            Compte-rendu de consultation
                                        </h4>
                                        <div class="space-y-2 text-sm">
                                            <p><strong class="text-gray-700">Date:</strong> ${df:formatDate(consultation.date)}</p>
                                            <p><strong class="text-gray-700">Docteur:</strong> Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom}</p>
                                        </div>
                                        <hr class="my-3">
                                        <div class="prose prose-sm max-w-none">
                                            <p class="text-gray-700 whitespace-pre-line">${consultation.compteRendu}</p>
                                        </div>
                                        <div class="mt-4">
                                            <button data-consultation-id="${consultation.idConsultation}"
                                                    class="btn-close-cr px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg transition">
                                                Fermer
                                            </button>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Modal de confirmation d'annulation -->
<div id="annulerModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-2xl shadow-2xl max-w-md w-full overflow-hidden">
        <div class="bg-gradient-to-r from-red-500 to-red-600 px-6 py-4">
            <h3 class="text-xl font-bold text-white flex items-center">
                <i class="fas fa-exclamation-triangle mr-3"></i>
                Confirmer l'annulation
            </h3>
        </div>
        <div class="p-6">
            <p class="text-gray-700 mb-4">Êtes-vous sûr de vouloir annuler cette consultation ?</p>
            <div class="bg-amber-50 border-l-4 border-amber-400 p-3 rounded">
                <p class="text-sm text-amber-800 flex items-start">
                    <i class="fas fa-info-circle mr-2 mt-0.5"></i>
                    <span>Cette action est irréversible et doit être effectuée au moins 24h avant la consultation.</span>
                </p>
            </div>
        </div>
        <div class="px-6 pb-6 flex gap-3">
            <button type="button" onclick="closeAnnulerModal()" 
                    class="flex-1 px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 font-medium rounded-lg transition">
                Non, garder
            </button>
            <form id="annulerForm" method="post" class="flex-1">
                <input type="hidden" name="action" value="annuler">
                <input type="hidden" name="consultationId" id="consultationIdToCancel">
                <button type="submit" 
                        class="w-full px-4 py-2 bg-red-600 hover:bg-red-700 text-white font-medium rounded-lg transition">
                    <i class="fas fa-times mr-2"></i>Oui, annuler
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    // Gestion des boutons d'annulation
    document.querySelectorAll('.btn-annuler').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const consultationId = this.getAttribute('data-consultation-id');
            document.getElementById('consultationIdToCancel').value = consultationId;
            document.getElementById('annulerModal').classList.remove('hidden');
        });
    });
    
    function closeAnnulerModal() {
        document.getElementById('annulerModal').classList.add('hidden');
    }
    
    // Gestion des boutons compte-rendu (ouvrir)
    document.querySelectorAll('.btn-compte-rendu').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const consultationId = this.getAttribute('data-consultation-id');
            document.getElementById('modal-' + consultationId).classList.remove('hidden');
        });
    });
    
    // Gestion des boutons compte-rendu (fermer)
    document.querySelectorAll('.btn-close-cr').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const consultationId = this.getAttribute('data-consultation-id');
            document.getElementById('modal-' + consultationId).classList.add('hidden');
        });
    });
    
    // Fermer le modal d'annulation en cliquant à l'extérieur
    document.getElementById('annulerModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeAnnulerModal();
        }
    });
</script>

</body>
</html>