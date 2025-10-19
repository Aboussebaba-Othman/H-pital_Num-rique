<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Consultations - Clinique Privée</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script>
        function buildUrl(baseParam, baseValue) {
            let url = '?' + baseParam + '=' + baseValue;
            const params = new URLSearchParams(window.location.search);
            params.forEach((value, key) => {
                if (key !== baseParam && key !== 'page') {
                    url += '&' + key + '=' + encodeURIComponent(value);
                }
            });
            return url;
        }
        
        function changePageSize(value) {
            window.location.href = buildUrl('pageSize', value);
        }
    </script>
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen">

<!-- Navigation -->
<jsp:include page="/WEB-INF/views/common/docteur-nav.jsp" />

<!-- Main Content -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Mes Consultations</h1>
        <p class="text-gray-600">Gérez et consultez l'historique de toutes vos consultations</p>
    </div>

    <!-- Statistiques -->
    <div class="grid grid-cols-2 md:grid-cols-5 gap-4 mb-8">
        <div class="bg-white rounded-lg shadow-md p-4 border-l-4 border-gray-500">
            <p class="text-xs text-gray-600 mb-1">Total</p>
            <p class="text-2xl font-bold text-gray-900">${totalConsultations}</p>
        </div>
        <div class="bg-white rounded-lg shadow-md p-4 border-l-4 border-yellow-500">
            <p class="text-xs text-gray-600 mb-1">Réservées</p>
            <p class="text-2xl font-bold text-gray-900">${reservees}</p>
        </div>
        <div class="bg-white rounded-lg shadow-md p-4 border-l-4 border-blue-500">
            <p class="text-xs text-gray-600 mb-1">Validées</p>
            <p class="text-2xl font-bold text-gray-900">${validees}</p>
        </div>
        <div class="bg-white rounded-lg shadow-md p-4 border-l-4 border-green-500">
            <p class="text-xs text-gray-600 mb-1">Terminées</p>
            <p class="text-2xl font-bold text-gray-900">${terminees}</p>
        </div>
        <div class="bg-white rounded-lg shadow-md p-4 border-l-4 border-red-500">
            <p class="text-xs text-gray-600 mb-1">Annulées</p>
            <p class="text-2xl font-bold text-gray-900">${annulees}</p>
        </div>
    </div>

    <!-- Filtres -->
    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
        <div class="flex items-center justify-between mb-4">
            <h2 class="text-lg font-bold text-gray-900 flex items-center">
                <i class="fas fa-filter text-blue-600 mr-2"></i>
                Filtres et Recherche
            </h2>
            <a href="${pageContext.request.contextPath}/docteur/consultations"
               class="text-sm text-blue-600 hover:text-blue-800 font-semibold">
                <i class="fas fa-redo mr-1"></i>
                Réinitialiser
            </a>
        </div>

        <form method="get" action="${pageContext.request.contextPath}/docteur/consultations"
              class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">

            <!-- Recherche -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-search mr-1"></i> Recherche
                </label>
                <input type="text"
                       name="search"
                       value="${filtreSearch}"
                       placeholder="Patient, motif, salle..."
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
            </div>

            <!-- Statut -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-info-circle mr-1"></i> Statut
                </label>
                <select name="statut"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    <option value="TOUS" ${filtreStatut == null || filtreStatut == 'TOUS' ? 'selected' : ''}>Tous</option>
                    <option value="RESERVEE" ${filtreStatut == 'RESERVEE' ? 'selected' : ''}>Réservées</option>
                    <option value="VALIDEE" ${filtreStatut == 'VALIDEE' ? 'selected' : ''}>Validées</option>
                    <option value="TERMINEE" ${filtreStatut == 'TERMINEE' ? 'selected' : ''}>Terminées</option>
                    <option value="ANNULEE" ${filtreStatut == 'ANNULEE' ? 'selected' : ''}>Annulées</option>
                </select>
            </div>

            <!-- Date Début -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-calendar-alt mr-1"></i> Date début
                </label>
                <input type="date"
                       name="dateDebut"
                       value="${filtreDateDebut}"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
            </div>

            <!-- Date Fin -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-calendar-alt mr-1"></i> Date fin
                </label>
                <input type="date"
                       name="dateFin"
                       value="${filtreDateFin}"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
            </div>

            <!-- Boutons -->
            <div class="md:col-span-2 lg:col-span-4 flex gap-3">
                <button type="submit"
                        class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition shadow-md flex items-center">
                    <i class="fas fa-search mr-2"></i>
                    Appliquer les filtres
                </button>
                <a href="${pageContext.request.contextPath}/docteur/consultations"
                   class="px-6 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition shadow-md flex items-center">
                    <i class="fas fa-times mr-2"></i>
                    Effacer
                </a>
            </div>
        </form>
    </div>

    <!-- Liste des Consultations -->
    <div class="bg-white rounded-xl shadow-lg p-6">
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold text-gray-900 flex items-center">
                <i class="fas fa-list text-green-600 mr-3"></i>
                Liste des Consultations (${totalConsultations})
            </h2>

            <!-- Tri -->
            <div class="flex items-center">
                <label class="text-sm font-medium text-gray-700 mr-2">Trier par:</label>
                <select onchange="window.location.href = buildUrl('sort', this.value)"
                        class="px-3 py-1 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500">
                    <option value="date_desc" ${filtreSort == 'date_desc' || filtreSort == null ? 'selected' : ''}>Date (récente)</option>
                    <option value="date_asc" ${filtreSort == 'date_asc' ? 'selected' : ''}>Date (ancienne)</option>
                    <option value="patient_asc" ${filtreSort == 'patient_asc' ? 'selected' : ''}>Patient (A-Z)</option>
                    <option value="patient_desc" ${filtreSort == 'patient_desc' ? 'selected' : ''}>Patient (Z-A)</option>
                    <option value="statut_asc" ${filtreSort == 'statut_asc' ? 'selected' : ''}>Statut (A-Z)</option>
                </select>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty consultations}">
                <div class="text-center py-12 bg-gray-50 rounded-xl border-2 border-dashed border-gray-300">
                    <i class="fas fa-inbox text-gray-400 text-6xl mb-4"></i>
                    <p class="text-gray-600 text-lg font-medium">Aucune consultation trouvée</p>
                    <p class="text-gray-500 text-sm mt-2">Essayez de modifier vos filtres de recherche</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Date & Heure
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Patient
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Motif
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Salle
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Statut
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Actions
                            </th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach var="consultation" items="${consultations}">
                            <tr class="hover:bg-gray-50 transition">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex flex-col">
                                            <span class="text-sm font-semibold text-gray-900">
                                                    ${consultation.dateCourte}
                                            </span>
                                        <span class="text-xs text-gray-500">
                                                <i class="fas fa-clock mr-1"></i>${consultation.heure}
                                            </span>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="w-10 h-10 bg-gradient-to-br from-blue-400 to-blue-600 rounded-full flex items-center justify-center text-white font-bold mr-3">
                                                ${consultation.patient.prenom.substring(0,1)}${consultation.patient.nom.substring(0,1)}
                                        </div>
                                        <div>
                                            <div class="text-sm font-semibold text-gray-900">
                                                    ${consultation.patient.prenom} ${consultation.patient.nom}
                                            </div>
                                            <div class="text-xs text-gray-500">
                                                    ${consultation.patient.email}
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="text-sm text-gray-900 max-w-xs truncate" title="${consultation.motifConsultation}">
                                            ${consultation.motifConsultation}
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="text-sm text-gray-700 flex items-center">
                                            <i class="fas fa-door-open text-gray-400 mr-2"></i>
                                            ${consultation.salle.nomSalle}
                                        </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <c:choose>
                                        <c:when test="${consultation.statut == 'RESERVEE'}">
                                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                                    <i class="fas fa-hourglass-half mr-1"></i> Réservée
                                                </span>
                                        </c:when>
                                        <c:when test="${consultation.statut == 'VALIDEE'}">
                                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                                                    <i class="fas fa-check-circle mr-1"></i> Validée
                                                </span>
                                        </c:when>
                                        <c:when test="${consultation.statut == 'TERMINEE'}">
                                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                    <i class="fas fa-check-double mr-1"></i> Terminée
                                                </span>
                                        </c:when>
                                        <c:when test="${consultation.statut == 'ANNULEE'}">
                                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                                    <i class="fas fa-times-circle mr-1"></i> Annulée
                                                </span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                    <div class="flex items-center space-x-3">
                                        <!-- Voir détails (toujours disponible) -->
                                        <a href="${pageContext.request.contextPath}/docteur/consultation?id=${consultation.idConsultation}"
                                           class="text-blue-600 hover:text-blue-900 transition"
                                           title="Voir les détails">
                                            <i class="fas fa-eye text-lg"></i>
                                        </a>

                                        <!-- Actions pour consultations RESERVEE -->
                                        <c:if test="${consultation.statut == 'RESERVEE'}">
                                            <!-- Valider -->
                                            <form action="${pageContext.request.contextPath}/docteur/valider" method="post" class="inline">
                                                <input type="hidden" name="consultationId" value="${consultation.idConsultation}">
                                                <button type="submit"
                                                        class="text-green-600 hover:text-green-900 transition"
                                                        onclick="return confirm('Êtes-vous sûr de vouloir valider cette consultation ?');"
                                                        title="Valider la consultation">
                                                    <i class="fas fa-check text-lg"></i>
                                                </button>
                                            </form>
                                            
                                            <!-- Refuser -->
                                            <form action="${pageContext.request.contextPath}/docteur/refuser" method="post" class="inline">
                                                <input type="hidden" name="consultationId" value="${consultation.idConsultation}">
                                                <button type="submit"
                                                        class="text-red-600 hover:text-red-900 transition"
                                                        onclick="return confirm('Êtes-vous sûr de vouloir refuser cette consultation ?');"
                                                        title="Refuser la consultation">
                                                    <i class="fas fa-times text-lg"></i>
                                                </button>
                                            </form>
                                        </c:if>

                                        <!-- Action pour consultations VALIDEE -->
                                        <c:if test="${consultation.statut == 'VALIDEE'}">
                                            <!-- Terminer -->
                                            <a href="${pageContext.request.contextPath}/docteur/compte-rendu?id=${consultation.idConsultation}"
                                               class="text-purple-600 hover:text-purple-900 transition"
                                               title="Terminer la consultation">
                                                <i class="fas fa-file-medical text-lg"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Pagination -->
        <c:if test="${not empty consultations && totalPages > 1}">
            <div class="mt-6 flex items-center justify-between border-t border-gray-200 pt-6">
                <!-- Info de pagination -->
                <div class="flex-1 flex justify-between sm:hidden">
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}${filtreStatut != null ? '&statut='.concat(filtreStatut) : ''}${filtreSearch != null ? '&search='.concat(filtreSearch) : ''}${filtreDateDebut != null ? '&dateDebut='.concat(filtreDateDebut) : ''}${filtreDateFin != null ? '&dateFin='.concat(filtreDateFin) : ''}${filtreSort != null ? '&sort='.concat(filtreSort) : ''}"
                           class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                            Précédent
                        </a>
                    </c:if>
                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}${filtreStatut != null ? '&statut='.concat(filtreStatut) : ''}${filtreSearch != null ? '&search='.concat(filtreSearch) : ''}${filtreDateDebut != null ? '&dateDebut='.concat(filtreDateDebut) : ''}${filtreDateFin != null ? '&dateFin='.concat(filtreDateFin) : ''}${filtreSort != null ? '&sort='.concat(filtreSort) : ''}"
                           class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                            Suivant
                        </a>
                    </c:if>
                </div>
                
                <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                    <div>
                        <p class="text-sm text-gray-700">
                            Affichage de
                            <span class="font-medium">${(currentPage - 1) * pageSize + 1}</span>
                            à
                            <span class="font-medium">${currentPage * pageSize > totalConsultations ? totalConsultations : currentPage * pageSize}</span>
                            sur
                            <span class="font-medium">${totalConsultations}</span>
                            résultats
                        </p>
                    </div>
                    
                    <div>
                        <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                            <!-- Bouton Précédent -->
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="?page=${currentPage - 1}${filtreStatut != null ? '&statut='.concat(filtreStatut) : ''}${filtreSearch != null ? '&search='.concat(filtreSearch) : ''}${filtreDateDebut != null ? '&dateDebut='.concat(filtreDateDebut) : ''}${filtreDateFin != null ? '&dateFin='.concat(filtreDateFin) : ''}${filtreSort != null ? '&sort='.concat(filtreSort) : ''}"
                                       class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-gray-100 text-sm font-medium text-gray-300 cursor-not-allowed">
                                        <i class="fas fa-chevron-left"></i>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                            
                            <!-- Numéros de pages -->
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="z-10 bg-blue-600 border-blue-600 text-white relative inline-flex items-center px-4 py-2 border text-sm font-medium">
                                            ${i}
                                        </span>
                                    </c:when>
                                    <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                        <a href="?page=${i}${filtreStatut != null ? '&statut='.concat(filtreStatut) : ''}${filtreSearch != null ? '&search='.concat(filtreSearch) : ''}${filtreDateDebut != null ? '&dateDebut='.concat(filtreDateDebut) : ''}${filtreDateFin != null ? '&dateFin='.concat(filtreDateFin) : ''}${filtreSort != null ? '&sort='.concat(filtreSort) : ''}"
                                           class="bg-white border-gray-300 text-gray-500 hover:bg-gray-50 relative inline-flex items-center px-4 py-2 border text-sm font-medium">
                                            ${i}
                                        </a>
                                    </c:when>
                                    <c:when test="${(i == currentPage - 3 && i > 1) || (i == currentPage + 3 && i < totalPages)}">
                                        <span class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700">
                                            ...
                                        </span>
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                            
                            <!-- Bouton Suivant -->
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}${filtreStatut != null ? '&statut='.concat(filtreStatut) : ''}${filtreSearch != null ? '&search='.concat(filtreSearch) : ''}${filtreDateDebut != null ? '&dateDebut='.concat(filtreDateDebut) : ''}${filtreDateFin != null ? '&dateFin='.concat(filtreDateFin) : ''}${filtreSort != null ? '&sort='.concat(filtreSort) : ''}"
                                       class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-gray-100 text-sm font-medium text-gray-300 cursor-not-allowed">
                                        <i class="fas fa-chevron-right"></i>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </nav>
                    </div>
                    
                    <!-- Sélecteur de taille de page -->
                    <div class="flex items-center ml-4">
                        <label for="pageSize" class="text-sm text-gray-700 mr-2">Par page:</label>
                        <select id="pageSize" 
                                onchange="changePageSize(this.value)"
                                class="px-3 py-1 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500">
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="25" ${pageSize == 25 ? 'selected' : ''}>25</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                            <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                        </select>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

</div>

</body>
</html>