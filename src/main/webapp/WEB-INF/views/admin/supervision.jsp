<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supervision Consultations - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- Définir la page active pour la sidebar -->
<c:set var="pageParam" value="consultations" scope="request"/>

<!-- Inclure la sidebar -->
<%@ include file="../common/admin-nav.jsp" %>

    <!-- Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Supervision des Consultations</h1>
        <p class="text-gray-600 mt-1">Vue d'ensemble de toutes les consultations de la clinique</p>
    </div>

    <!-- Statistiques rapides -->
    <c:if test="${aujourdhui != null}">
        <div class="grid grid-cols-2 md:grid-cols-6 gap-4 mb-8">
            <div class="bg-white rounded-lg shadow p-4 border-l-4 border-indigo-500">
                <p class="text-sm text-gray-600 mb-1">Total</p>
                <p class="text-2xl font-bold text-gray-900">${total}</p>
            </div>
            <div class="bg-white rounded-lg shadow p-4 border-l-4 border-blue-500">
                <p class="text-sm text-gray-600 mb-1">Aujourd'hui</p>
                <p class="text-2xl font-bold text-gray-900">${aujourdhui}</p>
            </div>
            <div class="bg-white rounded-lg shadow p-4 border-l-4 border-yellow-500">
                <p class="text-sm text-gray-600 mb-1">Réservées</p>
                <p class="text-2xl font-bold text-gray-900">${reservees}</p>
            </div>
            <div class="bg-white rounded-lg shadow p-4 border-l-4 border-green-500">
                <p class="text-sm text-gray-600 mb-1">Validées</p>
                <p class="text-2xl font-bold text-gray-900">${validees}</p>
            </div>
            <div class="bg-white rounded-lg shadow p-4 border-l-4 border-cyan-500">
                <p class="text-sm text-gray-600 mb-1">Terminées</p>
                <p class="text-2xl font-bold text-gray-900">${terminees}</p>
            </div>
            <div class="bg-white rounded-lg shadow p-4 border-l-4 border-red-500">
                <p class="text-sm text-gray-600 mb-1">Annulées</p>
                <p class="text-2xl font-bold text-gray-900">${annulees}</p>
            </div>
        </div>
    </c:if>

    <!-- Filtres -->
    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
        <form method="get" action="${pageContext.request.contextPath}/admin/consultations" class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <input type="hidden" name="action" value="filter">

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Statut</label>
                <select name="statut" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500">
                    <option value="">Tous les statuts</option>
                    <option value="RESERVEE" ${selectedStatut == 'RESERVEE' ? 'selected' : ''}>Réservée</option>
                    <option value="VALIDEE" ${selectedStatut == 'VALIDEE' ? 'selected' : ''}>Validée</option>
                    <option value="TERMINEE" ${selectedStatut == 'TERMINEE' ? 'selected' : ''}>Terminée</option>
                    <option value="ANNULEE" ${selectedStatut == 'ANNULEE' ? 'selected' : ''}>Annulée</option>
                </select>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Date</label>
                <input type="date"
                       name="date"
                       value="${selectedDate}"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500">
            </div>

            <div class="flex items-end space-x-2">
                <button type="submit" class="flex-1 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">
                    <i class="fas fa-filter mr-2"></i>Filtrer
                </button>
                <a href="${pageContext.request.contextPath}/admin/consultations"
                   class="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400">
                    <i class="fas fa-times"></i>
                </a>
            </div>
        </form>
    </div>

    <!-- Liste des consultations -->
    <div class="bg-white rounded-xl shadow-lg overflow-hidden">
        <div class="p-6 border-b border-gray-200">
            <h2 class="text-xl font-bold text-gray-900">
                <i class="fas fa-calendar-check mr-2 text-indigo-600"></i>
                Consultations (${consultations.size()})
            </h2>
        </div>

        <c:choose>
            <c:when test="${empty consultations}">
                <div class="p-12 text-center">
                    <i class="fas fa-calendar-times text-gray-300 text-6xl mb-4"></i>
                    <p class="text-gray-500 text-lg">Aucune consultation trouvée</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date & Heure</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Patient</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Docteur</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Salle</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Motif</th>
                            <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">Statut</th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach var="consult" items="${consultations}">
                            <tr class="hover:bg-gray-50 transition">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="text-sm">
                                        <div class="font-medium text-gray-900">
                                            <i class="fas fa-calendar text-indigo-600 mr-2"></i>
                                            <fmt:formatDate value="${consult.date}" pattern="dd/MM/yyyy"/>
                                        </div>
                                        <div class="text-gray-500">
                                            <i class="fas fa-clock text-gray-400 mr-2"></i>
                                            <fmt:formatDate value="${consult.heure}" pattern="HH:mm"/>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10 bg-blue-100 rounded-full flex items-center justify-center">
                                            <i class="fas fa-user text-blue-600"></i>
                                        </div>
                                        <div class="ml-3">
                                            <div class="text-sm font-medium text-gray-900">
                                                    ${consult.patient.nom} ${consult.patient.prenom}
                                            </div>
                                            <div class="text-xs text-gray-500">${consult.patient.email}</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10 bg-green-100 rounded-full flex items-center justify-center">
                                            <i class="fas fa-user-md text-green-600"></i>
                                        </div>
                                        <div class="ml-3">
                                            <div class="text-sm font-medium text-gray-900">
                                                Dr. ${consult.docteur.nom}
                                            </div>
                                            <div class="text-xs text-gray-500">${consult.docteur.specialite}</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    <i class="fas fa-door-open text-orange-600 mr-2"></i>
                                        ${consult.salle.nomSalle}
                                </td>
                                <td class="px-6 py-4">
                                    <div class="text-sm text-gray-900 max-w-xs truncate">
                                            ${consult.motifConsultation}
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-center">
                                    <c:choose>
                                        <c:when test="${consult.statut == 'RESERVEE'}">
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                                <i class="fas fa-hourglass-half mr-1"></i> Réservée
                                            </span>
                                        </c:when>
                                        <c:when test="${consult.statut == 'VALIDEE'}">
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                <i class="fas fa-check-circle mr-1"></i> Validée
                                            </span>
                                        </c:when>
                                        <c:when test="${consult.statut == 'TERMINEE'}">
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                                                <i class="fas fa-flag-checkered mr-1"></i> Terminée
                                            </span>
                                        </c:when>
                                        <c:when test="${consult.statut == 'ANNULEE'}">
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                                <i class="fas fa-times-circle mr-1"></i> Annulée
                                            </span>
                                        </c:when>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

</main>
</div>

</body>
</html>