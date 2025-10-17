<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique des Consultations - Clinique</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">

<c:set var="pageParam" value="historique" scope="request"/>
<%@ include file="../common/patient-nav.jsp" %>

<div class="max-w-7xl mx-auto p-6">
    <!-- En-tête -->
    <div class="mb-6">
        <h2 class="text-2xl font-bold">
            <i class="fas fa-history text-indigo-600 mr-2"></i>
            Historique des Consultations
        </h2>
        <p class="text-gray-500">Consultez votre historique médical complet</p>
    </div>

    <!-- Statistiques -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <div class="p-4 bg-white rounded-lg shadow text-center">
            <i class="fas fa-check-circle text-green-500 text-2xl mb-2"></i>
            <div class="text-xl font-semibold">${consultationsTerminees}</div>
            <div class="text-sm text-gray-500">Consultations terminées</div>
        </div>
        <div class="p-4 bg-white rounded-lg shadow text-center">
            <i class="fas fa-times-circle text-red-500 text-2xl mb-2"></i>
            <div class="text-xl font-semibold">${consultationsAnnulees}</div>
            <div class="text-sm text-gray-500">Consultations annulées</div>
        </div>
        <div class="p-4 bg-white rounded-lg shadow text-center">
            <i class="fas fa-calendar-alt text-indigo-600 text-2xl mb-2"></i>
            <div class="text-xl font-semibold">${historique.size()}</div>
            <div class="text-sm text-gray-500">Total consultations</div>
        </div>
    </div>

    <!-- Filtres -->
    <div class="bg-white p-4 rounded-lg shadow mb-6">
        <form method="get" class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <label class="block text-sm text-gray-600 mb-1">Filtrer par année</label>
                <select class="w-full border rounded px-3 py-2" name="annee" onchange="this.form.submit()">
                    <option value="">Toutes les années</option>
                    <c:forEach items="${anneesDisponibles}" var="annee">
                        <option value="${annee}" ${annee == anneeFiltre ? 'selected' : ''}>${annee}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label class="block text-sm text-gray-600 mb-1">Affichage</label>
                <select class="w-full border rounded px-3 py-2" id="viewMode">
                    <option value="table">Vue tableau</option>
                    <option value="timeline">Vue chronologique</option>
                </select>
            </div>
        </form>
    </div>

    <!-- Vue Tableau -->
    <div id="tableView" class="bg-white rounded-lg shadow p-4 mb-6">
        <h3 class="font-semibold mb-3">Historique détaillé</h3>
        <c:choose>
            <c:when test="${empty historique}">
                <div class="text-center py-8 text-gray-500">
                    <i class="fas fa-inbox text-3xl mb-3"></i>
                    <p>Aucune consultation dans l'historique</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="space-y-3">
                    <c:forEach items="${historique}" var="consultation">
                        <div class="flex items-center justify-between p-4 border border-gray-200 rounded-lg hover:bg-gray-50">
                            <div class="flex-1">
                                <div class="font-semibold text-gray-800 mb-1">
                                    #${consultation.idConsultation} — ${consultation.date}
                                    <span class="text-gray-500">à ${consultation.heure}</span>
                                </div>
                                <div class="text-sm text-gray-600 mb-1">
                                    Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom} ·
                                        ${consultation.docteur.specialite}
                                </div>
                                <div class="text-sm text-gray-500 truncate max-w-xl" title="${consultation.motifConsultation}">
                                        ${consultation.motifConsultation}
                                </div>
                            </div>
                            <div class="flex flex-col items-end gap-2 ml-4">
                                <span class="px-3 py-1 rounded-full text-xs font-medium
                                    ${consultation.statut == 'TERMINEE' ? 'bg-green-100 text-green-800' :
                                      (consultation.statut == 'ANNULEE' ? 'bg-red-100 text-red-800' :
                                       (consultation.statut == 'VALIDEE' ? 'bg-blue-100 text-blue-800' :
                                        'bg-yellow-100 text-yellow-800'))}">
                                    <c:choose>
                                        <c:when test="${consultation.statut == 'RESERVEE'}">Réservée</c:when>
                                        <c:when test="${consultation.statut == 'VALIDEE'}">Validée</c:when>
                                        <c:when test="${consultation.statut == 'TERMINEE'}">Terminée</c:when>
                                        <c:when test="${consultation.statut == 'ANNULEE'}">Annulée</c:when>
                                        <c:otherwise>${consultation.statut}</c:otherwise>
                                    </c:choose>
                                </span>
                                <c:if test="${consultation.statut == 'TERMINEE' && not empty consultation.compteRendu}">
                                    <button type="button"
                                            class="px-3 py-1 text-sky-700 border border-sky-200 rounded hover:bg-sky-50"
                                            onclick="openCompteRendu('${consultation.idConsultation}')">
                                        <i class="fas fa-file-alt mr-1"></i> Compte-rendu
                                    </button>
                                </c:if>
                            </div>
                        </div>

                        <!-- Modal Compte-rendu -->
                        <c:if test="${consultation.statut == 'TERMINEE' && not empty consultation.compteRendu}">
                            <div id="compteRenduModal${consultation.idConsultation}"
                                 class="hidden fixed inset-0 flex items-center justify-center z-50">
                                <div class="fixed inset-0 bg-black opacity-30"
                                     onclick="closeCompteRendu('${consultation.idConsultation}')"></div>
                                <div class="bg-white rounded-lg shadow-lg max-w-2xl w-full p-6 z-10 relative">
                                    <div class="flex justify-between items-center mb-4">
                                        <h5 class="text-lg font-semibold">Compte-rendu de consultation</h5>
                                        <button class="text-gray-600 hover:text-gray-800"
                                                onclick="closeCompteRendu('${consultation.idConsultation}')">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4 text-sm">
                                        <div>
                                            <p><strong>Référence:</strong> #${consultation.idConsultation}</p>
                                            <p><strong>Date:</strong> ${consultation.date}</p>
                                        </div>
                                        <div>
                                            <p><strong>Docteur:</strong> Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom}</p>
                                            <p><strong>Spécialité:</strong> ${consultation.docteur.specialite}</p>
                                        </div>
                                    </div>
                                    <hr class="my-3">
                                    <div class="text-sm text-gray-700 bg-gray-50 p-4 rounded">
                                            ${consultation.compteRendu}
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Vue Chronologique (Timeline) -->
    <div id="timelineView" class="hidden bg-white rounded-lg shadow p-4 mb-6">
        <h3 class="font-semibold mb-4">Vue chronologique</h3>
        <c:choose>
            <c:when test="${empty historique}">
                <div class="text-center py-8 text-gray-500">
                    <i class="fas fa-inbox text-3xl mb-3"></i>
                    <p>Aucune consultation dans l'historique</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="space-y-4">
                    <c:forEach items="${historique}" var="consultation">
                        <div class="flex items-start gap-4">
                            <div class="flex-shrink-0 mt-1">
                                <div class="w-3 h-3 rounded-full
                                    ${consultation.statut == 'TERMINEE' ? 'bg-green-500' :
                                      (consultation.statut == 'ANNULEE' ? 'bg-red-500' : 'bg-gray-400')}">
                                </div>
                            </div>
                            <div class="flex-1 bg-gray-50 border border-gray-200 rounded-lg p-4">
                                <div class="flex justify-between items-start mb-2">
                                    <div>
                                        <div class="font-medium text-gray-800">
                                                ${consultation.date} à ${consultation.heure}
                                        </div>
                                        <div class="text-sm text-gray-600">
                                            Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom} —
                                                ${consultation.docteur.specialite}
                                        </div>
                                    </div>
                                    <div class="text-sm font-medium
                                        ${consultation.statut == 'TERMINEE' ? 'text-green-600' :
                                          (consultation.statut == 'ANNULEE' ? 'text-red-600' : 'text-gray-600')}">
                                        <c:choose>
                                            <c:when test="${consultation.statut == 'TERMINEE'}">Terminée</c:when>
                                            <c:when test="${consultation.statut == 'ANNULEE'}">Annulée</c:when>
                                            <c:when test="${consultation.statut == 'VALIDEE'}">Validée</c:when>
                                            <c:otherwise>${consultation.statut}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="text-sm text-gray-700">${consultation.motifConsultation}</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    // Switch entre vue tableau et vue chronologique
    document.getElementById('viewMode').addEventListener('change', function() {
        const tableView = document.getElementById('tableView');
        const timelineView = document.getElementById('timelineView');
        if (this.value === 'timeline') {
            tableView.classList.add('hidden');
            timelineView.classList.remove('hidden');
        } else {
            tableView.classList.remove('hidden');
            timelineView.classList.add('hidden');
        }
    });

    // Ouvrir le modal de compte-rendu
    function openCompteRendu(id) {
        const modal = document.getElementById('compteRenduModal' + id);
        if (modal) {
            modal.classList.remove('hidden');
            document.body.style.overflow = 'hidden';
        }
    }

    // Fermer le modal de compte-rendu
    function closeCompteRendu(id) {
        const modal = document.getElementById('compteRenduModal' + id);
        if (modal) {
            modal.classList.add('hidden');
            document.body.style.overflow = 'auto';
        }
    }
</script>
</body>
</html>