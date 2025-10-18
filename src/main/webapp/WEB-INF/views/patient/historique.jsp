<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique & Statistiques - Clinique</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body class="bg-gray-50">

<c:set var="pageParam" value="historique" scope="request"/>
<%@ include file="../common/patient-nav.jsp" %>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- En-tête -->
    <div class="mb-8">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 flex items-center">
                    <i class="fas fa-chart-line text-indigo-600 mr-3"></i>
                    Analyse & Historique Médical
                </h1>
                <p class="mt-2 text-gray-600">Vue d'ensemble de votre parcours de soins</p>
            </div>
            <div class="mt-4 md:mt-0 flex gap-3">
                <a href="${pageContext.request.contextPath}/patient/consultations"
                   class="inline-flex items-center px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg transition">
                    <i class="fas fa-calendar-check mr-2"></i>
                    Mes Consultations
                </a>
            </div>
        </div>
    </div>

    <!-- Statistiques Globales -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Total -->
        <div class="bg-gradient-to-br from-indigo-500 to-purple-600 rounded-2xl shadow-xl overflow-hidden text-white transform hover:scale-105 transition duration-200">
            <div class="p-6">
                <div class="flex items-center justify-between mb-2">
                    <i class="fas fa-calendar-alt text-3xl opacity-80"></i>
                    <div class="text-right">
                        <div class="text-4xl font-bold">${fn:length(historique)}</div>
                        <div class="text-sm opacity-90 font-medium">Total</div>
                    </div>
                </div>
                <div class="text-xs opacity-75 mt-2">Consultations enregistrées</div>
            </div>
        </div>

        <!-- Terminées -->
        <div class="bg-gradient-to-br from-green-500 to-emerald-600 rounded-2xl shadow-xl overflow-hidden text-white transform hover:scale-105 transition duration-200">
            <div class="p-6">
                <div class="flex items-center justify-between mb-2">
                    <i class="fas fa-check-circle text-3xl opacity-80"></i>
                    <div class="text-right">
                        <div class="text-4xl font-bold">${consultationsTerminees}</div>
                        <div class="text-sm opacity-90 font-medium">Terminées</div>
                    </div>
                </div>
                <c:set var="tauxTerminees" value="${fn:length(historique) > 0 ? (consultationsTerminees * 100 / fn:length(historique)) : 0}" />
                <div class="text-xs opacity-75 mt-2">
                    ${String.format("%.0f", tauxTerminees)}% du total
                </div>
            </div>
        </div>

        <!-- Annulées -->
        <div class="bg-gradient-to-br from-red-500 to-rose-600 rounded-2xl shadow-xl overflow-hidden text-white transform hover:scale-105 transition duration-200">
            <div class="p-6">
                <div class="flex items-center justify-between mb-2">
                    <i class="fas fa-times-circle text-3xl opacity-80"></i>
                    <div class="text-right">
                        <div class="text-4xl font-bold">${consultationsAnnulees}</div>
                        <div class="text-sm opacity-90 font-medium">Annulées</div>
                    </div>
                </div>
                <c:set var="tauxAnnulees" value="${fn:length(historique) > 0 ? (consultationsAnnulees * 100 / fn:length(historique)) : 0}" />
                <div class="text-xs opacity-75 mt-2">
                    ${String.format("%.0f", tauxAnnulees)}% du total
                </div>
            </div>
        </div>

        <!-- Validées -->
        <div class="bg-gradient-to-br from-blue-500 to-cyan-600 rounded-2xl shadow-xl overflow-hidden text-white transform hover:scale-105 transition duration-200">
            <div class="p-6">
                <div class="flex items-center justify-between mb-2">
                    <i class="fas fa-clipboard-check text-3xl opacity-80"></i>
                    <div class="text-right">
                        <div class="text-4xl font-bold">${consultationsValidees}</div>
                        <div class="text-sm opacity-90 font-medium">Validées</div>
                    </div>
                </div>
                <div class="text-xs opacity-75 mt-2">Consultations confirmées</div>
            </div>
        </div>
    </div>

    <!-- Graphiques et Analyses -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        
        <!-- Statistiques par Spécialité -->
        <div class="bg-white rounded-2xl shadow-lg p-6">
            <h3 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
                <i class="fas fa-stethoscope text-indigo-600 mr-2"></i>
                Par Spécialité Médicale
            </h3>
            <c:choose>
                <c:when test="${empty consultationsParSpecialite}">
                    <p class="text-gray-500 text-sm text-center py-8">Aucune donnée disponible</p>
                </c:when>
                <c:otherwise>
                    <div class="space-y-3">
                        <c:forEach items="${consultationsParSpecialite}" var="entry">
                            <div>
                                <div class="flex justify-between items-center mb-1">
                                    <span class="text-sm font-medium text-gray-700">${entry.key}</span>
                                    <span class="text-sm font-bold text-indigo-600">${entry.value}</span>
                                </div>
                                <c:set var="pourcentage" value="${(entry.value * 100) / fn:length(historique)}" />
                                <div class="w-full bg-gray-200 rounded-full h-2.5">
                                    <div class="bg-indigo-600 h-2.5 rounded-full transition-all duration-500" 
                                         style="width: ${pourcentage}%"></div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Statistiques par Docteur -->
        <div class="bg-white rounded-2xl shadow-lg p-6">
            <h3 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
                <i class="fas fa-user-md text-indigo-600 mr-2"></i>
                Par Médecin
            </h3>
            <c:choose>
                <c:when test="${empty consultationsParDocteur}">
                    <p class="text-gray-500 text-sm text-center py-8">Aucune donnée disponible</p>
                </c:when>
                <c:otherwise>
                    <div class="space-y-3 max-h-80 overflow-y-auto">
                        <c:forEach items="${consultationsParDocteur}" var="entry">
                            <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 bg-indigo-100 rounded-full flex items-center justify-center">
                                        <i class="fas fa-user-md text-indigo-600"></i>
                                    </div>
                                    <span class="text-sm font-medium text-gray-800">${entry.key}</span>
                                </div>
                                <span class="px-3 py-1 bg-indigo-600 text-white text-sm font-bold rounded-full">
                                    ${entry.value}
                                </span>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Statistiques par Mois -->
    <div class="bg-white rounded-2xl shadow-lg p-6 mb-8">
        <h3 class="text-lg font-bold text-gray-900 mb-6 flex items-center">
            <i class="fas fa-chart-bar text-indigo-600 mr-2"></i>
            Évolution Mensuelle
        </h3>
        <c:choose>
            <c:when test="${empty consultationsParMois}">
                <p class="text-gray-500 text-sm text-center py-8">Aucune donnée disponible</p>
            </c:when>
            <c:otherwise>
                <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
                    <c:forEach items="${consultationsParMois}" var="entry">
                        <div class="text-center">
                            <div class="bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl p-4 text-white mb-2 transform hover:scale-110 transition duration-200 shadow-lg">
                                <div class="text-3xl font-bold mb-1">${entry.value}</div>
                                <div class="text-xs opacity-90">${entry.key}</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Filtres et Recherche -->
    <div class="bg-white rounded-2xl shadow-lg p-6 mb-8">
        <h3 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
            <i class="fas fa-filter text-indigo-600 mr-2"></i>
            Filtres & Recherche
        </h3>
        <form method="get" class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-calendar mr-1"></i>
                    Année
                </label>
                <select class="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:ring-2 focus:ring-indigo-500 transition" 
                        name="annee" 
                        onchange="this.form.submit()">
                    <option value="">Toutes les années</option>
                    <c:forEach items="${anneesDisponibles}" var="annee">
                        <option value="${annee}" ${annee == anneeFiltre ? 'selected' : ''}>${annee}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-user-md mr-1"></i>
                    Médecin
                </label>
                <select class="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:ring-2 focus:ring-indigo-500 transition" 
                        name="docteurId" 
                        onchange="this.form.submit()">
                    <option value="">Tous les médecins</option>
                    <c:forEach items="${docteursConsultes}" var="docteur">
                        <option value="${docteur.idDocteur}" ${docteur.idDocteur == docteurIdFiltre ? 'selected' : ''}>
                            Dr. ${docteur.prenom} ${docteur.nom}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-search mr-1"></i>
                    Recherche
                </label>
                <input type="text" 
                       id="searchInput"
                       placeholder="Rechercher..." 
                       class="w-full border border-gray-300 rounded-lg px-4 py-2.5 focus:ring-2 focus:ring-indigo-500 transition">
            </div>
        </form>
    </div>

    <!-- Liste des Consultations -->
    <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
        <div class="bg-gradient-to-r from-indigo-600 to-purple-600 px-6 py-4">
            <h3 class="text-xl font-bold text-white flex items-center justify-between">
                <span>
                    <i class="fas fa-list mr-2"></i>
                    Historique Détaillé
                </span>
                <span class="text-sm font-normal opacity-90">
                    ${fn:length(historique)} consultation(s)
                </span>
            </h3>
        </div>
        <div class="p-6">
            <c:choose>
                <c:when test="${empty historique}">
                    <div class="text-center py-16">
                        <div class="inline-flex items-center justify-center w-24 h-24 bg-gray-100 rounded-full mb-6">
                            <i class="fas fa-inbox text-gray-400 text-4xl"></i>
                        </div>
                        <h3 class="text-xl font-semibold text-gray-700 mb-2">Aucune consultation</h3>
                        <p class="text-gray-500 mb-6">Votre historique médical est vide</p>
                        <a href="${pageContext.request.contextPath}/patient/reserver"
                           class="inline-flex items-center px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg transition">
                            <i class="fas fa-plus mr-2"></i>
                            Réserver une consultation
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div id="consultationsList" class="space-y-3">
                        <c:forEach items="${historique}" var="consultation">
                            <div class="consultation-item border border-gray-200 rounded-xl p-5 hover:shadow-md hover:border-indigo-300 transition duration-200"
                                 data-search="${consultation.docteur.nom} ${consultation.docteur.prenom} ${consultation.docteur.specialite} ${consultation.motifConsultation}">
                                <div class="flex flex-col lg:flex-row lg:items-center gap-4">
                                    <!-- Date Badge -->
                                    <div class="flex-shrink-0">
                                        <div class="w-16 h-16 ${consultation.statut == 'TERMINEE' ? 'bg-green-50 border-green-200' :
                                                                 (consultation.statut == 'ANNULEE' ? 'bg-red-50 border-red-200' : 'bg-gray-50 border-gray-200')}
                                             border-2 rounded-xl flex flex-col items-center justify-center">
                                            <span class="text-xs ${consultation.statut == 'TERMINEE' ? 'text-green-600' :
                                                                   (consultation.statut == 'ANNULEE' ? 'text-red-600' : 'text-gray-600')} font-semibold">
                                                ${consultation.date.toString().substring(5, 7)}/${consultation.date.toString().substring(2, 4)}
                                            </span>
                                            <span class="text-xl font-bold ${consultation.statut == 'TERMINEE' ? 'text-green-700' :
                                                                            (consultation.statut == 'ANNULEE' ? 'text-red-700' : 'text-gray-700')}">
                                                ${consultation.date.toString().substring(8, 10)}
                                            </span>
                                        </div>
                                    </div>

                                    <!-- Informations -->
                                    <div class="flex-1 min-w-0">
                                        <div class="flex items-start justify-between gap-3 mb-2">
                                            <div>
                                                <h4 class="font-bold text-gray-900 text-lg">
                                                    Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom}
                                                </h4>
                                                <p class="text-sm text-indigo-600 font-medium">
                                                    <i class="fas fa-stethoscope mr-1"></i>
                                                    ${consultation.docteur.specialite}
                                                </p>
                                            </div>
                                            <div class="flex flex-col items-end gap-2">
                                                <c:choose>
                                                    <c:when test="${consultation.statut == 'TERMINEE'}">
                                                        <span class="px-3 py-1 bg-green-100 text-green-800 text-xs font-semibold rounded-full">
                                                            <i class="fas fa-check-circle mr-1"></i>TERMINÉE
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${consultation.statut == 'ANNULEE'}">
                                                        <span class="px-3 py-1 bg-red-100 text-red-800 text-xs font-semibold rounded-full">
                                                            <i class="fas fa-times-circle mr-1"></i>ANNULÉE
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${consultation.statut == 'VALIDEE'}">
                                                        <span class="px-3 py-1 bg-blue-100 text-blue-800 text-xs font-semibold rounded-full">
                                                            <i class="fas fa-check mr-1"></i>VALIDÉE
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="px-3 py-1 bg-yellow-100 text-yellow-800 text-xs font-semibold rounded-full">
                                                            <i class="fas fa-clock mr-1"></i>RÉSERVÉE
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="text-xs text-gray-500 font-mono">#${consultation.idConsultation}</span>
                                            </div>
                                        </div>

                                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-2 text-sm text-gray-600 mb-3">
                                            <div class="flex items-center">
                                                <i class="fas fa-calendar text-gray-400 mr-2 w-4"></i>
                                                <span>${consultation.date}</span>
                                            </div>
                                            <div class="flex items-center">
                                                <i class="fas fa-clock text-gray-400 mr-2 w-4"></i>
                                                <span>${consultation.heure}</span>
                                            </div>
                                        </div>

                                        <div class="bg-gray-50 rounded-lg p-3">
                                            <p class="text-sm text-gray-700">
                                                <i class="fas fa-notes-medical text-indigo-600 mr-2"></i>
                                                <strong>Motif:</strong> ${consultation.motifConsultation}
                                            </p>
                                        </div>

                                        <c:if test="${consultation.statut == 'TERMINEE' && not empty consultation.compteRendu}">
                                            <div class="mt-3">
                                                <button type="button"
                                                        data-consultation-id="${consultation.idConsultation}"
                                                        class="btn-toggle-cr text-sm text-sky-600 hover:text-sky-800 font-medium">
                                                    <i class="fas fa-file-medical mr-1"></i>
                                                    Voir le compte-rendu
                                                    <i class="fas fa-chevron-down ml-1"></i>
                                                </button>
                                            </div>

                                            <!-- Compte-rendu caché -->
                                            <div id="cr-${consultation.idConsultation}" class="hidden mt-4 p-4 bg-sky-50 border-l-4 border-sky-500 rounded-lg">
                                                <h5 class="font-bold text-gray-900 mb-3 flex items-center">
                                                    <i class="fas fa-file-medical text-sky-600 mr-2"></i>
                                                    Compte-rendu médical
                                                </h5>
                                                <div class="bg-white rounded-lg p-4 text-sm text-gray-700 leading-relaxed whitespace-pre-line">
                                                    ${consultation.compteRendu}
                                                </div>
                                            </div>
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
</div>
    </div>

    <!-- Vue Tableau (compacte) -->
    <div id="tableView" class="hidden bg-white rounded-2xl shadow-lg p-6 mb-8">
        <h3 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
            <i class="fas fa-table mr-2 text-indigo-600"></i>
            Vue compacte
        </h3>
        <c:choose>
            <c:when test="${empty historique}">
                <div class="text-center py-12 text-gray-500">
                    <i class="fas fa-inbox text-4xl mb-3"></i>
                    <p>Aucune consultation dans l'historique</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="space-y-2">
                    <c:forEach items="${historique}" var="consultation">
                        <div class="flex items-center justify-between p-4 border border-gray-200 rounded-xl hover:bg-gray-50 transition">
                            <div class="flex-1">
                                <div class="font-semibold text-gray-800">
                                    <span class="text-gray-500 font-mono text-sm">#${consultation.idConsultation}</span> —
                                    ${consultation.date} <span class="text-gray-500">à ${consultation.heure}</span>
                                </div>
                                <div class="text-sm text-gray-600 mt-1">
                                    Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom} · ${consultation.docteur.specialite}
                                </div>
                            </div>
                            <div class="flex items-center gap-3 ml-4">
                                <span class="px-3 py-1 rounded-full text-xs font-medium
                                    ${consultation.statut == 'TERMINEE' ? 'bg-green-100 text-green-800' :
                                      (consultation.statut == 'ANNULEE' ? 'bg-red-100 text-red-800' :
                                       (consultation.statut == 'VALIDEE' ? 'bg-blue-100 text-blue-800' :
                                        'bg-yellow-100 text-yellow-800'))}">
                                    ${consultation.statut}
                                </span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>


<script>
    // Recherche en temps réel
    document.getElementById('searchInput')?.addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        const items = document.querySelectorAll('.consultation-item');
        
        items.forEach(item => {
            const searchData = item.getAttribute('data-search').toLowerCase();
            if (searchData.includes(searchTerm)) {
                item.style.display = '';
            } else {
                item.style.display = 'none';
            }
        });
    });

    // Toggle compte-rendu
    document.querySelectorAll('.btn-toggle-cr').forEach(btn => {
        btn.addEventListener('click', function() {
            const consultationId = this.getAttribute('data-consultation-id');
            const crDiv = document.getElementById('cr-' + consultationId);
            const icon = this.querySelector('.fa-chevron-down, .fa-chevron-up');
            
            if (crDiv) {
                if (crDiv.classList.contains('hidden')) {
                    crDiv.classList.remove('hidden');
                    icon.classList.remove('fa-chevron-down');
                    icon.classList.add('fa-chevron-up');
                    this.innerHTML = '<i class="fas fa-file-medical mr-1"></i>Masquer le compte-rendu<i class="fas fa-chevron-up ml-1"></i>';
                } else {
                    crDiv.classList.add('hidden');
                    icon.classList.remove('fa-chevron-up');
                    icon.classList.add('fa-chevron-down');
                    this.innerHTML = '<i class="fas fa-file-medical mr-1"></i>Voir le compte-rendu<i class="fas fa-chevron-down ml-1"></i>';
                }
            }
        });
    });

    // Animation au chargement
    document.addEventListener('DOMContentLoaded', function() {
        const items = document.querySelectorAll('.consultation-item');
        items.forEach((item, index) => {
            setTimeout(() => {
                item.style.opacity = '0';
                item.style.transform = 'translateY(20px)';
                item.style.transition = 'all 0.3s ease';
                
                setTimeout(() => {
                    item.style.opacity = '1';
                    item.style.transform = 'translateY(0)';
                }, 50);
            }, index * 50);
        });
    });
</script>
</body>
</html>