<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">

<!-- Définir la page active pour la sidebar -->
<c:set var="pageParam" value="dashboard" scope="request"/>

<!-- Inclure la sidebar -->
<%@ include file="../common/admin-nav.jsp" %>

<!-- ===================== CONTENU DU DASHBOARD ===================== -->

<!-- Header -->
<div class="mb-8">
    <h1 class="text-3xl font-bold text-gray-900 mb-2">
        Tableau de Bord Administrateur 🔧
    </h1>
    <p class="text-gray-600">Vue d'ensemble de la clinique</p>
</div>

<!-- Statistiques Principales -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">

    <!-- Patients -->
    <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl shadow-lg p-6 text-white transform hover:scale-105 transition">
        <div class="flex items-center justify-between mb-4">
            <div>
                <p class="text-blue-100 text-sm mb-1">Patients</p>
                <p class="text-4xl font-bold">${nombrePatients}</p>
            </div>
            <div class="w-16 h-16 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                <i class="fas fa-users text-3xl"></i>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/patients"
           class="text-sm text-blue-100 hover:text-white flex items-center">
            Gérer les patients
            <i class="fas fa-arrow-right ml-2"></i>
        </a>
    </div>

    <!-- Docteurs -->
    <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-xl shadow-lg p-6 text-white transform hover:scale-105 transition">
        <div class="flex items-center justify-between mb-4">
            <div>
                <p class="text-green-100 text-sm mb-1">Docteurs</p>
                <p class="text-4xl font-bold">${nombreDocteurs}</p>
            </div>
            <div class="w-16 h-16 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                <i class="fas fa-user-md text-3xl"></i>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/docteurs"
           class="text-sm text-green-100 hover:text-white flex items-center">
            Gérer les docteurs
            <i class="fas fa-arrow-right ml-2"></i>
        </a>
    </div>

    <!-- Départements -->
    <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl shadow-lg p-6 text-white transform hover:scale-105 transition">
        <div class="flex items-center justify-between mb-4">
            <div>
                <p class="text-purple-100 text-sm mb-1">Départements</p>
                <p class="text-4xl font-bold">${nombreDepartements}</p>
            </div>
            <div class="w-16 h-16 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                <i class="fas fa-building text-3xl"></i>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/departements"
           class="text-sm text-purple-100 hover:text-white flex items-center">
            Gérer les départements
            <i class="fas fa-arrow-right ml-2"></i>
        </a>
    </div>

    <!-- Salles -->
    <div class="bg-gradient-to-br from-orange-500 to-orange-600 rounded-xl shadow-lg p-6 text-white transform hover:scale-105 transition">
        <div class="flex items-center justify-between mb-4">
            <div>
                <p class="text-orange-100 text-sm mb-1">Salles</p>
                <p class="text-4xl font-bold">${nombreSalles}</p>
            </div>
            <div class="w-16 h-16 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                <i class="fas fa-door-open text-3xl"></i>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/salles"
           class="text-sm text-orange-100 hover:text-white flex items-center">
            Gérer les salles
            <i class="fas fa-arrow-right ml-2"></i>
        </a>
    </div>

</div>

<!-- Statistiques Consultations -->
<div class="bg-white rounded-xl shadow-lg p-6 mb-8">
    <h2 class="text-2xl font-bold text-gray-900 mb-6 flex items-center">
        <i class="fas fa-chart-line text-indigo-600 mr-3"></i>
        Statistiques Consultations
    </h2>

    <div class="grid grid-cols-1 md:grid-cols-4 gap-6">

        <!-- Consultations du jour -->
        <div class="text-center p-6 bg-gradient-to-br from-indigo-50 to-purple-50 rounded-lg border-2 border-indigo-200">
            <i class="fas fa-calendar-day text-indigo-600 text-4xl mb-3"></i>
            <p class="text-3xl font-bold text-gray-900 mb-1">${consultationsDuJour}</p>
            <p class="text-sm text-gray-600">Aujourd'hui</p>
        </div>

        <!-- Réservées -->
        <div class="text-center p-6 bg-gradient-to-br from-yellow-50 to-amber-50 rounded-lg border-2 border-yellow-200">
            <i class="fas fa-hourglass-half text-yellow-600 text-4xl mb-3"></i>
            <p class="text-3xl font-bold text-gray-900 mb-1">${consultationsReservees}</p>
            <p class="text-sm text-gray-600">Réservées</p>
        </div>

        <!-- Validées -->
        <div class="text-center p-6 bg-gradient-to-br from-green-50 to-emerald-50 rounded-lg border-2 border-green-200">
            <i class="fas fa-check-circle text-green-600 text-4xl mb-3"></i>
            <p class="text-3xl font-bold text-gray-900 mb-1">${consultationsValidees}</p>
            <p class="text-sm text-gray-600">Validées</p>
        </div>

        <!-- Terminées -->
        <div class="text-center p-6 bg-gradient-to-br from-blue-50 to-cyan-50 rounded-lg border-2 border-blue-200">
            <i class="fas fa-flag-checkered text-blue-600 text-4xl mb-3"></i>
            <p class="text-3xl font-bold text-gray-900 mb-1">${consultationsTerminees}</p>
            <p class="text-sm text-gray-600">Terminées</p>
        </div>

    </div>
</div>

<!-- Actions de Gestion -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">

    <!-- Gérer Patients -->
    <div class="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
        <div class="flex items-center mb-4">
            <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mr-4">
                <i class="fas fa-users text-blue-600 text-xl"></i>
            </div>
            <h3 class="text-lg font-bold text-gray-900">Patients</h3>
        </div>
        <p class="text-gray-600 text-sm mb-4">
            Consulter et gérer la liste des patients inscrits
        </p>
        <a href="${pageContext.request.contextPath}/admin/patients"
           class="inline-block px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition text-sm">
            <i class="fas fa-arrow-right mr-2"></i>
            Gérer
        </a>
    </div>

    <!-- Gérer Docteurs -->
    <div class="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
        <div class="flex items-center mb-4">
            <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mr-4">
                <i class="fas fa-user-md text-green-600 text-xl"></i>
            </div>
            <h3 class="text-lg font-bold text-gray-900">Docteurs</h3>
        </div>
        <p class="text-gray-600 text-sm mb-4">
            Ajouter, modifier ou supprimer des docteurs
        </p>
        <a href="${pageContext.request.contextPath}/admin/docteurs"
           class="inline-block px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition text-sm">
            <i class="fas fa-arrow-right mr-2"></i>
            Gérer
        </a>
    </div>

    <!-- Gérer Départements -->
    <div class="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
        <div class="flex items-center mb-4">
            <div class="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mr-4">
                <i class="fas fa-building text-purple-600 text-xl"></i>
            </div>
            <h3 class="text-lg font-bold text-gray-900">Départements</h3>
        </div>
        <p class="text-gray-600 text-sm mb-4">
            Organiser les départements médicaux
        </p>
        <a href="${pageContext.request.contextPath}/admin/departements"
           class="inline-block px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition text-sm">
            <i class="fas fa-arrow-right mr-2"></i>
            Gérer
        </a>
    </div>

    <!-- Gérer Salles -->
    <div class="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
        <div class="flex items-center mb-4">
            <div class="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center mr-4">
                <i class="fas fa-door-open text-orange-600 text-xl"></i>
            </div>
            <h3 class="text-lg font-bold text-gray-900">Salles</h3>
        </div>
        <p class="text-gray-600 text-sm mb-4">
            Configurer les salles de consultation
        </p>
        <a href="${pageContext.request.contextPath}/admin/salles"
           class="inline-block px-4 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700 transition text-sm">
            <i class="fas fa-arrow-right mr-2"></i>
            Gérer
        </a>
    </div>

    <!-- Toutes Consultations -->
    <div class="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
        <div class="flex items-center mb-4">
            <div class="w-12 h-12 bg-indigo-100 rounded-lg flex items-center justify-center mr-4">
                <i class="fas fa-calendar-check text-indigo-600 text-xl"></i>
            </div>
            <h3 class="text-lg font-bold text-gray-900">Consultations</h3>
        </div>
        <p class="text-gray-600 text-sm mb-4">
            Superviser toutes les consultations
        </p>
        <a href="${pageContext.request.contextPath}/admin/consultations"
           class="inline-block px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition text-sm">
            <i class="fas fa-arrow-right mr-2"></i>
            Voir tout
        </a>
    </div>

    <!-- Statistiques -->
    <div class="bg-white rounded-xl shadow-md p-6 hover:shadow-xl transition">
        <div class="flex items-center mb-4">
            <div class="w-12 h-12 bg-pink-100 rounded-lg flex items-center justify-center mr-4">
                <i class="fas fa-chart-pie text-pink-600 text-xl"></i>
            </div>
            <h3 class="text-lg font-bold text-gray-900">Statistiques</h3>
        </div>
        <p class="text-gray-600 text-sm mb-4">
            Rapports et analyses détaillées
        </p>
        <a href="${pageContext.request.contextPath}/admin/statistiques"
           class="inline-block px-4 py-2 bg-pink-600 text-white rounded-lg hover:bg-pink-700 transition text-sm">
            <i class="fas fa-arrow-right mr-2"></i>
            Consulter
        </a>
    </div>

</div>

<!-- ===================== FIN DU CONTENU ===================== -->

</main>
</div> <!-- ferme le layout flex de admin-nav -->
</body>
</html>
