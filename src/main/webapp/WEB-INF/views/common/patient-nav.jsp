<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sidebar Patient Simple -->
<div class="flex min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">

    <!-- Sidebar -->
    <aside class="w-64 bg-gradient-to-b from-blue-600 to-indigo-600 text-white flex flex-col shadow-lg fixed h-full">

        <!-- Logo & Titre -->
        <div class="flex items-center justify-center h-20 border-b border-white border-opacity-20">
            <div class="flex items-center space-x-3">
                <div class="w-10 h-10 bg-white bg-opacity-20 rounded-xl flex items-center justify-center">
                    <i class="fas fa-user-injured text-2xl"></i>
                </div>
                <span class="text-lg font-bold">Espace Patient</span>
            </div>
        </div>

        <!-- Menu Navigation -->
        <nav class="flex-1 p-4 space-y-1 overflow-y-auto">
            <a href="${pageContext.request.contextPath}/patient/dashboard"
               class="nav-link ${pageParam == 'dashboard' ? 'active' : ''} flex items-center px-3 py-3 rounded-lg transition-all duration-150">
                <i class="fas fa-home w-5"></i>
                <span class="ml-3">Tableau de bord</span>
            </a>

            <a href="${pageContext.request.contextPath}/patient/docteurs"
               class="nav-link ${pageParam == 'docteurs' ? 'active' : ''} flex items-center px-3 py-3 rounded-lg transition-all duration-150">
                <i class="fas fa-user-md w-5"></i>
                <span class="ml-3">Docteurs</span>
            </a>

            <a href="${pageContext.request.contextPath}/patient/consultations"
               class="nav-link ${pageParam == 'consultations' ? 'active' : ''} flex items-center px-3 py-3 rounded-lg transition-all duration-150">
                <i class="fas fa-calendar-check w-5"></i>
                <span class="ml-3">Mes consultations</span>
            </a>

            <a href="${pageContext.request.contextPath}/patient/historique"
               class="nav-link ${pageParam == 'historique' ? 'active' : ''} flex items-center px-3 py-3 rounded-lg transition-all duration-150">
                <i class="fas fa-history w-5"></i>
                <span class="ml-3">Historique</span>
            </a>
        </nav>

        <!-- Footer utilisateur -->
        <div class="border-t border-white border-opacity-20 p-4">
            <div class="flex items-center space-x-3 mb-3 px-2">
                <div class="w-10 h-10 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                    <i class="fas fa-user-circle text-xl"></i>
                </div>
                <div class="flex-1">
                    <p class="text-sm font-semibold truncate">
                        <c:choose>
                            <c:when test="${not empty sessionScope.userConnecte}">
                                ${sessionScope.userConnecte.nom} ${sessionScope.userConnecte.prenom}
                            </c:when>
                            <c:otherwise>Patient</c:otherwise>
                        </c:choose>
                    </p>
                    <p class="text-xs text-blue-200"><i class="fas fa-circle text-green-400 text-xs mr-1"></i>Connecté</p>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout"
               class="flex items-center justify-center px-4 py-2.5 bg-red-500 rounded-lg hover:bg-red-600 transition-all duration-150 font-medium">
                <i class="fas fa-sign-out-alt mr-2"></i> Déconnexion
            </a>
        </div>
    </aside>

    <!-- Contenu Principal -->
    <main class="flex-1 ml-56 p-6 min-h-screen">

        <!-- Styles -->
        <style>
            .nav-link.active { background: rgba(255,255,255,0.15); }
        </style>
