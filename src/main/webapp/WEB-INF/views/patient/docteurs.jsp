<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Docteurs - Clinique</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body>

<!-- Définir la page active pour la sidebar -->
<c:set var="pageParam" value="docteurs" scope="request"/>

<!-- Inclure la sidebar patient -->
<%@ include file="../common/patient-nav.jsp" %>

<div class="max-w-7xl mx-auto">
    <!-- En-tête -->
    <div class="mb-6">
        <h2 class="text-2xl font-bold"><i class="fas fa-user-md text-indigo-600 mr-2"></i> Liste des Docteurs</h2>
        <p class="text-gray-500">Trouvez le médecin qui correspond à vos besoins</p>
    </div>

    <!-- Filtres et Recherche -->
    <div class="bg-white p-4 rounded-lg shadow mb-6">
        <form method="get" action="${pageContext.request.contextPath}/patient/docteurs" class="grid grid-cols-1 md:grid-cols-6 gap-4">
            <div class="md:col-span-2">
                <label class="block text-sm text-gray-600 mb-1">Rechercher</label>
                <input type="text" class="w-full border rounded px-3 py-2" name="search" placeholder="Nom, prénom..." value="${searchTerm}">
            </div>
            <div class="md:col-span-2">
                <label class="block text-sm text-gray-600 mb-1">Département</label>
                <select class="w-full border rounded px-3 py-2" name="departementId">
                    <option value="">Tous les départements</option>
                    <c:forEach items="${departements}" var="dept">
                        <option value="${dept.idDepartement}" ${dept.idDepartement == departementIdFiltre ? 'selected' : ''}>${dept.nom}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="md:col-span-1">
                <label class="block text-sm text-gray-600 mb-1">Spécialité</label>
                <input type="text" class="w-full border rounded px-3 py-2" name="specialite" placeholder="Spécialité..." value="${specialiteFiltre}">
            </div>
            <div class="md:col-span-1 flex items-end">
                <button type="submit" class="w-full px-3 py-2 bg-indigo-600 text-white rounded"> <i class="fas fa-search mr-2"></i> Filtrer</button>
            </div>
        </form>
    </div>

    <!-- Liste des Docteurs -->
    <c:choose>
        <c:when test="${empty docteurs}">
            <div class="bg-blue-50 p-4 rounded text-blue-800"> <i class="fas fa-info-circle mr-2"></i> Aucun docteur trouvé.</div>
        </c:when>
        <c:otherwise>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach items="${docteurs}" var="docteur">
                    <div class="bg-white rounded-lg shadow p-4">
                        <div class="flex items-center gap-4 mb-3">
                            <div class="w-14 h-14 bg-indigo-100 text-indigo-600 rounded-full flex items-center justify-center text-xl">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div>
                                <div class="font-semibold">Dr. ${docteur.prenom} ${docteur.nom}</div>
                                <div class="text-sm text-gray-500">${docteur.specialite}</div>
                            </div>
                        </div>

                        <div class="text-sm text-gray-600 mb-4">
                            <p><i class="fas fa-building mr-2 text-indigo-600"></i><strong>Département:</strong> ${docteur.departement.nom}</p>
                            <p class="mt-1"><i class="fas fa-envelope mr-2 text-indigo-600"></i><strong>Email:</strong> ${docteur.email}</p>
                        </div>

                        <a href="${pageContext.request.contextPath}/patient/reserver?docteurId=${docteur.idDocteur}" class="block w-full text-center px-3 py-2 bg-indigo-600 text-white rounded"> <i class="fas fa-calendar-plus mr-2"></i> Prendre rendez-vous</a>
                    </div>
                </c:forEach>
            </div>

            <!-- Statistiques -->
            <div class="mt-6 text-sm text-gray-600"><i class="fas fa-info-circle text-indigo-600 mr-2"></i><strong>${docteurs.size()}</strong> docteur(s) trouvé(s)</div>
        </c:otherwise>
    </c:choose>
</div>

</main>
</div>

</body>
</html>