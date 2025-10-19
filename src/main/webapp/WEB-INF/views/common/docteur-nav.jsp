<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Navigation Docteur (sidebar on md+) -->
<div class="flex">
    <!-- Sidebar for md+ (styled like admin-nav) -->
    <aside class="hidden md:flex flex-col w-64 bg-gradient-to-b from-green-600 via-emerald-600 to-emerald-700 text-white shadow-2xl fixed h-full">

        <!-- Logo & Title -->
        <div class="flex items-center justify-center h-20 border-b border-white border-opacity-20 backdrop-blur-sm">
            <div class="flex items-center space-x-3">
                <div class="w-10 h-10 bg-white bg-opacity-20 rounded-xl flex items-center justify-center backdrop-blur-sm">
                    <i class="fas fa-user-md text-2xl"></i>
                </div>
                <span class="text-xl font-bold">Clinique Privée</span>
            </div>
        </div>

        <!-- Menu Navigation -->
        <nav class="flex-1 p-4 space-y-1 overflow-y-auto mt-2">
            <a href="${pageContext.request.contextPath}/docteur/dashboard"
               class="flex items-center px-4 py-3 rounded-xl hover:bg-white/10 transition-all duration-200 group ${pageContext.request.requestURI.contains('dashboard') ? 'bg-white/20 font-semibold' : ''}">
                <i class="fas fa-home text-lg w-6 group-hover:scale-110 transition-transform"></i>
                <span class="ml-3 font-medium">Accueil</span>
            </a>

            <a href="${pageContext.request.contextPath}/docteur/planning"
               class="flex items-center px-4 py-3 rounded-xl hover:bg-white/10 transition-all duration-200 group ${pageContext.request.requestURI.contains('planning') ? 'bg-white/20 font-semibold' : ''}">
                <i class="fas fa-calendar-alt text-lg w-6 group-hover:scale-110 transition-transform"></i>
                <span class="ml-3 font-medium">Planning</span>
            </a>

            <a href="${pageContext.request.contextPath}/docteur/consultations"
               class="flex items-center px-4 py-3 rounded-xl hover:bg-white/10 transition-all duration-200 group ${pageContext.request.requestURI.contains('consultations') ? 'bg-white/20 font-semibold' : ''}">
                <i class="fas fa-clipboard-list text-lg w-6 group-hover:scale-110 transition-transform"></i>
                <span class="ml-3 font-medium">Consultations</span>
            </a>

            <a href="${pageContext.request.contextPath}/docteur/patients"
               class="flex items-center px-4 py-3 rounded-xl hover:bg-white/10 transition-all duration-200 group ${pageContext.request.requestURI.contains('patients') ? 'bg-white/20 font-semibold' : ''}">
                <i class="fas fa-users text-lg w-6 group-hover:scale-110 transition-transform"></i>
                <span class="ml-3 font-medium">Patients</span>
            </a>
        </nav>

        <!-- Footer User -->
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
                            <c:otherwise>Docteur</c:otherwise>
                        </c:choose>
                    </p>
                    <p class="text-xs text-green-200">
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

    <!-- Mobile Topbar (hidden on md+) -->
    <nav class="bg-gradient-to-r from-green-600 to-emerald-600 shadow-lg md:hidden sticky top-0 z-40">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16 items-center">
                <div class="flex items-center">
                    <i class="fas fa-user-md text-white text-xl mr-3"></i>
                    <span class="text-lg font-bold text-white">Clinique Privée</span>
                </div>

                <div class="flex items-center space-x-3">
                    <button id="mobileMenuBtn" class="p-2 text-white hover:bg-white/20 rounded-lg transition">
                        <i class="fas fa-bars text-xl"></i>
                    </button>
                    <a href="${pageContext.request.contextPath}/logout"
                       class="px-3 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-all duration-200 flex items-center">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
            <!-- Mobile collapsible menu -->
            <div id="mobileMenu" class="hidden pb-3">
                <div class="flex flex-col space-y-1 py-2">
                    <a href="${pageContext.request.contextPath}/docteur/dashboard" 
                       class="px-3 py-2 rounded-lg text-white hover:bg-white/20 transition flex items-center ${pageContext.request.requestURI.contains('dashboard') ? 'bg-white/30 font-semibold' : ''}">
                        <i class="fas fa-home mr-2"></i>
                        <span>Accueil</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/docteur/planning" 
                       class="px-3 py-2 rounded-lg text-white hover:bg-white/20 transition flex items-center ${pageContext.request.requestURI.contains('planning') ? 'bg-white/30 font-semibold' : ''}">
                        <i class="fas fa-calendar-alt mr-2"></i>
                        <span>Planning</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/docteur/consultations" 
                       class="px-3 py-2 rounded-lg text-white hover:bg-white/20 transition flex items-center ${pageContext.request.requestURI.contains('consultations') ? 'bg-white/30 font-semibold' : ''}">
                        <i class="fas fa-clipboard-list mr-2"></i>
                        <span>Consultations</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/docteur/patients" 
                       class="px-3 py-2 rounded-lg text-white hover:bg-white/20 transition flex items-center ${pageContext.request.requestURI.contains('patients') ? 'bg-white/30 font-semibold' : ''}">
                        <i class="fas fa-users mr-2"></i>
                        <span>Patients</span>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content Area (with margin for sidebar on md+) -->
    <main class="flex-1 md:ml-64 min-h-screen">

<script>
    // Mobile menu toggle
    document.addEventListener('DOMContentLoaded', function () {
        const mobileBtn = document.getElementById('mobileMenuBtn');
        const mobileMenu = document.getElementById('mobileMenu');
        if (mobileBtn && mobileMenu) {
            mobileBtn.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
        }
    });
</script>

<!-- Messages Flash -->
<c:if test="${not empty sessionScope.successMessage}">
    <div class="px-4 sm:px-6 lg:px-8 mt-4">
        <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded-lg shadow-md flex items-center justify-between animate-slideIn">
            <div class="flex items-center">
                <i class="fas fa-check-circle text-green-500 text-xl mr-3"></i>
                <span>${sessionScope.successMessage}</span>
            </div>
            <button onclick="this.parentElement.parentElement.remove()" class="text-green-700 hover:text-green-900">
                <i class="fas fa-times"></i>
            </button>
        </div>
    </div>
    <c:remove var="successMessage" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.errorMessage}">
    <div class="px-4 sm:px-6 lg:px-8 mt-4">
        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded-lg shadow-md flex items-center justify-between animate-slideIn">
            <div class="flex items-center">
                <i class="fas fa-exclamation-triangle text-red-500 text-xl mr-3"></i>
                <span>${sessionScope.errorMessage}</span>
            </div>
            <button onclick="this.parentElement.parentElement.remove()" class="text-red-700 hover:text-red-900">
                <i class="fas fa-times"></i>
            </button>
        </div>
    </div>
    <c:remove var="errorMessage" scope="session"/>
</c:if>

<style>
    @keyframes slideIn {
        from {
            transform: translateY(-20px);
            opacity: 0;
        }
        to {
            transform: translateY(0);
            opacity: 1;
        }
    }

    .animate-slideIn {
        animation: slideIn 0.3s ease-out;
    }
</style>