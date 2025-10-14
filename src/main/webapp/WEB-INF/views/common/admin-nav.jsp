<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sidebar Admin Moderne -->
<div class="flex min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">

    <!-- Sidebar -->
    <aside class="w-64 bg-gradient-to-b from-purple-600 via-indigo-600 to-indigo-700 text-white flex flex-col shadow-2xl fixed h-full">

        <!-- Logo & Titre -->
        <div class="flex items-center justify-center h-20 border-b border-white border-opacity-20 backdrop-blur-sm">
            <div class="flex items-center space-x-3">
                <div class="w-10 h-10 bg-white bg-opacity-20 rounded-xl flex items-center justify-center backdrop-blur-sm">
                    <i class="fas fa-user-shield text-2xl"></i>
                </div>
                <span class="text-xl font-bold">Clinique Admin</span>
            </div>
        </div>

        <!-- Menu Navigation -->
        <nav class="flex-1 p-4 space-y-1 overflow-y-auto">
            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="nav-link ${pageParam == 'dashboard' ? 'active' : ''} flex items-center px-4 py-3 rounded-xl transition-all duration-200 group">
                <i class="fas fa-home text-lg w-6 group-hover:scale-110 transition-transform"></i>
                <span class="ml-3 font-medium">Dashboard</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/patients"
               class="nav-link ${pageParam == 'patients' ? 'active' : ''} flex items-center px-4 py-3 rounded-xl transition-all duration-200 group">
                <i class="fas fa-users text-lg w-6 group-hover:scale-110 transition-transform"></i>
                <span class="ml-3 font-medium">Patients</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/docteurs"
               class="nav-link ${pageParam == 'docteurs' ? 'active' : ''} flex items-center px-4 py-3 rounded-xl transition-all duration-200 group">
                <i class="fas fa-user-md text-lg w-6 group-hover:scale-110 transition-transform"></i>
                <span class="ml-3 font-medium">Docteurs</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/departements"
               class="nav-link ${pageParam == 'departements' ? 'active' : ''} flex items-center px-4 py-3 rounded-xl transition-all duration-200 group">
                <i class="fas fa-building text-lg w-6 group-hover:scale-110 transition-transform"></i>
                <span class="ml-3 font-medium">Départements</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/salles"
               class="nav-link ${pageParam == 'salles' ? 'active' : ''} flex items-center px-4 py-3 rounded-xl transition-all duration-200 group">
                <i class="fas fa-door-open text-lg w-6 group-hover:scale-110 transition-transform"></i>
                <span class="ml-3 font-medium">Salles</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/consultations"
               class="nav-link ${pageParam == 'consultations' ? 'active' : ''} flex items-center px-4 py-3 rounded-xl transition-all duration-200 group">
                <i class="fas fa-calendar-check text-lg w-6 group-hover:scale-110 transition-transform"></i>
                <span class="ml-3 font-medium">Consultations</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/statistiques"
               class="nav-link ${pageParam == 'statistiques' ? 'active' : ''} flex items-center px-4 py-3 rounded-xl transition-all duration-200 group">
                <i class="fas fa-chart-pie text-lg w-6 group-hover:scale-110 transition-transform"></i>
                <span class="ml-3 font-medium">Statistiques</span>
            </a>
        </nav>

        <!-- Footer Utilisateur -->
        <div class="border-t border-white border-opacity-20 p-4 backdrop-blur-sm">
            <div class="flex items-center space-x-3 mb-3 px-2">
                <div class="w-10 h-10 bg-white bg-opacity-20 rounded-full flex items-center justify-center backdrop-blur-sm">
                    <i class="fas fa-user-circle text-xl"></i>
                </div>
                <div class="flex-1">
                    <p class="text-sm font-semibold truncate">
                        <c:choose>
                            <c:when test="${not empty sessionScope.userConnecte}">
                                ${sessionScope.userConnecte.nom} ${sessionScope.userConnecte.prenom}
                            </c:when>
                            <c:otherwise>Administrateur</c:otherwise>
                        </c:choose>
                    </p>
                    <p class="text-xs text-purple-200">
                        <i class="fas fa-circle text-green-400 text-xs mr-1"></i>Connecté
                    </p>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout"
               class="flex items-center justify-center px-4 py-2.5 bg-red-500 rounded-xl hover:bg-red-600 transition-all duration-200 shadow-lg hover:shadow-xl font-medium">
                <i class="fas fa-sign-out-alt mr-2"></i>
                Déconnexion
            </a>
        </div>
    </aside>

    <!-- Contenu Principal -->
    <main class="flex-1 ml-64 p-6 min-h-screen">
