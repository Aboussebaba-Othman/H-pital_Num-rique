<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="bg-gradient-to-r from-purple-600 to-indigo-600 shadow-lg sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center space-x-8">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center">
                    <i class="fas fa-user-shield text-white text-2xl mr-3"></i>
                    <span class="text-xl font-bold text-white">Administration</span>
                </a>

                <!-- Navigation Links -->
                <div class="hidden md:flex space-x-4">
                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                       class="text-white hover:bg-white hover:bg-opacity-20 px-3 py-2 rounded-lg transition">
                        <i class="fas fa-home mr-1"></i> Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/departements"
                       class="text-white hover:bg-white hover:bg-opacity-20 px-3 py-2 rounded-lg transition">
                        <i class="fas fa-building mr-1"></i> Départements
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/docteurs"
                       class="text-white hover:bg-white hover:bg-opacity-20 px-3 py-2 rounded-lg transition">
                        <i class="fas fa-user-md mr-1"></i> Docteurs
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/salles"
                       class="text-white hover:bg-white hover:bg-opacity-20 px-3 py-2 rounded-lg transition">
                        <i class="fas fa-door-open mr-1"></i> Salles
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/supervision"
                       class="text-white hover:bg-white hover:bg-opacity-20 px-3 py-2 rounded-lg transition">
                        <i class="fas fa-eye mr-1"></i> Supervision
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/statistiques"
                       class="text-white hover:bg-white hover:bg-opacity-20 px-3 py-2 rounded-lg transition">
                        <i class="fas fa-chart-pie mr-1"></i> Statistiques
                    </a>
                </div>
            </div>

            <div class="flex items-center space-x-4">
                <span class="text-white">
                    <i class="fas fa-user-circle mr-2"></i>
                    ${sessionScope.userName}
                </span>
                <a href="${pageContext.request.contextPath}/logout"
                   class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition">
                    <i class="fas fa-sign-out-alt mr-2"></i>
                    Déconnexion
                </a>
            </div>
        </div>
    </div>
</nav>