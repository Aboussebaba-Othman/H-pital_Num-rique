<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Navigation commune pour toutes les pages admin -->
<nav class="bg-gradient-to-r from-purple-600 to-indigo-600 shadow-lg sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <!-- Logo et titre -->
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center">
                    <i class="fas fa-user-shield text-white text-2xl mr-3"></i>
                    <span class="text-xl font-bold text-white">Clinique Privée - Admin</span>
                </a>
            </div>

            <!-- Menu de navigation -->
            <div class="hidden md:flex items-center space-x-1">
                <a href="${pageContext.request.contextPath}/admin/dashboard"
                   class="px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-white hover:bg-opacity-20 transition">
                    <i class="fas fa-home mr-2"></i>Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin/patients"
                   class="px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-white hover:bg-opacity-20 transition">
                    <i class="fas fa-users mr-2"></i>Patients
                </a>
                <a href="${pageContext.request.contextPath}/admin/docteurs"
                   class="px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-white hover:bg-opacity-20 transition">
                    <i class="fas fa-user-md mr-2"></i>Docteurs
                </a>
                <a href="${pageContext.request.contextPath}/admin/departements"
                   class="px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-white hover:bg-opacity-20 transition">
                    <i class="fas fa-building mr-2"></i>Départements
                </a>
                <a href="${pageContext.request.contextPath}/admin/salles"
                   class="px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-white hover:bg-opacity-20 transition">
                    <i class="fas fa-door-open mr-2"></i>Salles
                </a>
                <a href="${pageContext.request.contextPath}/admin/consultations"
                   class="px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-white hover:bg-opacity-20 transition">
                    <i class="fas fa-calendar-check mr-2"></i>Consultations
                </a>
                <a href="${pageContext.request.contextPath}/admin/statistiques"
                   class="px-3 py-2 rounded-md text-sm font-medium text-white hover:bg-white hover:bg-opacity-20 transition">
                    <i class="fas fa-chart-pie mr-2"></i>Statistiques
                </a>
            </div>

            <!-- Utilisateur et déconnexion -->
            <div class="flex items-center space-x-4">
                <span class="text-white text-sm">
                    <i class="fas fa-user-circle mr-2"></i>
                    <c:choose>
                        <c:when test="${not empty sessionScope.userConnecte}">
                            ${sessionScope.userConnecte.nom} ${sessionScope.userConnecte.prenom}
                        </c:when>
                        <c:otherwise>
                            Administrateur
                        </c:otherwise>
                    </c:choose>
                </span>
                <a href="${pageContext.request.contextPath}/logout"
                   class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition">
                    <i class="fas fa-sign-out-alt mr-2"></i>Déconnexion
                </a>
            </div>
        </div>
    </div>

    <!-- Menu mobile -->
    <div class="md:hidden" id="mobile-menu">
        <div class="px-2 pt-2 pb-3 space-y-1 bg-purple-700">
            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-white hover:bg-opacity-20">
                <i class="fas fa-home mr-2"></i>Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/admin/patients"
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-white hover:bg-opacity-20">
                <i class="fas fa-users mr-2"></i>Patients
            </a>
            <a href="${pageContext.request.contextPath}/admin/docteurs"
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-white hover:bg-opacity-20">
                <i class="fas fa-user-md mr-2"></i>Docteurs
            </a>
            <a href="${pageContext.request.contextPath}/admin/departements"
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-white hover:bg-opacity-20">
                <i class="fas fa-building mr-2"></i>Départements
            </a>
            <a href="${pageContext.request.contextPath}/admin/salles"
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-white hover:bg-opacity-20">
                <i class="fas fa-door-open mr-2"></i>Salles
            </a>
            <a href="${pageContext.request.contextPath}/admin/consultations"
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-white hover:bg-opacity-20">
                <i class="fas fa-calendar-check mr-2"></i>Consultations
            </a>
            <a href="${pageContext.request.contextPath}/admin/statistiques"
               class="block px-3 py-2 rounded-md text-base font-medium text-white hover:bg-white hover:bg-opacity-20">
                <i class="fas fa-chart-pie mr-2"></i>Statistiques
            </a>
        </div>
    </div>
</nav>