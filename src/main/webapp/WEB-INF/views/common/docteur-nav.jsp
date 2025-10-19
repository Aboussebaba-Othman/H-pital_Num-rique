<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Navigation Docteur -->
<nav class="bg-gradient-to-r from-green-600 to-emerald-600 shadow-lg sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <!-- Logo et Titre -->
            <div class="flex items-center">
                <i class="fas fa-heartbeat text-white text-2xl mr-3"></i>
                <span class="text-xl font-bold text-white">Clinique Privée</span>
                <span class="ml-4 px-3 py-1 bg-white/20 text-white rounded-full text-sm font-semibold backdrop-blur-sm">
                    Docteur
                </span>
            </div>

            <!-- Menu Navigation -->
            <div class="hidden md:flex items-center space-x-1">
                <a href="${pageContext.request.contextPath}/docteur/dashboard"
                   class="nav-link px-4 py-2 rounded-lg text-white hover:bg-white/20 transition-all duration-200 flex items-center ${pageContext.request.requestURI.contains('dashboard') ? 'bg-white/30 font-semibold' : ''}">
                    <i class="fas fa-home mr-2"></i>
                    <span>Accueil</span>
                </a>

                <a href="${pageContext.request.contextPath}/docteur/planning"
                   class="nav-link px-4 py-2 rounded-lg text-white hover:bg-white/20 transition-all duration-200 flex items-center ${pageContext.request.requestURI.contains('planning') ? 'bg-white/30 font-semibold' : ''}">
                    <i class="fas fa-calendar-alt mr-2"></i>
                    <span>Planning</span>
                </a>

                <a href="${pageContext.request.contextPath}/docteur/consultations"
                   class="nav-link px-4 py-2 rounded-lg text-white hover:bg-white/20 transition-all duration-200 flex items-center ${pageContext.request.requestURI.contains('consultations') ? 'bg-white/30 font-semibold' : ''}">
                    <i class="fas fa-clipboard-list mr-2"></i>
                    <span>Consultations</span>
                </a>

                <a href="${pageContext.request.contextPath}/docteur/patients"
                   class="nav-link px-4 py-2 rounded-lg text-white hover:bg-white/20 transition-all duration-200 flex items-center ${pageContext.request.requestURI.contains('patients') ? 'bg-white/30 font-semibold' : ''}">
                    <i class="fas fa-users mr-2"></i>
                    <span>Patients</span>
                </a>
            </div>

            <!-- Profil et Déconnexion -->
            <div class="flex items-center space-x-4">
                <!-- Notifications -->
                <div class="relative">
                    <button id="notificationBtn"
                            class="relative p-2 text-white hover:bg-white/20 rounded-lg transition-all duration-200"
                            onclick="toggleNotifications()">
                        <i class="fas fa-bell text-xl"></i>
                        <span id="notificationBadge"
                              class="hidden absolute -top-1 -right-1 w-5 h-5 bg-red-500 text-white text-xs rounded-full flex items-center justify-center font-bold animate-pulse">
                            0
                        </span>
                    </button>

                    <!-- Dropdown Notifications -->
                    <div id="notificationDropdown"
                         class="hidden absolute right-0 mt-2 w-96 bg-white rounded-xl shadow-2xl z-50 border border-gray-200 overflow-hidden">
                        <div class="bg-gradient-to-r from-green-600 to-emerald-600 p-4">
                            <h3 class="text-white font-bold text-lg flex items-center justify-between">
                                <span>
                                    <i class="fas fa-bell mr-2"></i>
                                    Notifications
                                </span>
                                <span id="notificationCount" class="text-sm bg-white/20 px-2 py-1 rounded-full">0</span>
                            </h3>
                        </div>
                        <div id="notificationList" class="max-h-96 overflow-y-auto">
                            <!-- Notifications chargées dynamiquement -->
                            <div class="flex items-center justify-center p-8">
                                <i class="fas fa-spinner fa-spin text-green-600 text-2xl"></i>
                            </div>
                        </div>
                        <div class="border-t border-gray-200 p-3 bg-gray-50">
                            <a href="${pageContext.request.contextPath}/docteur/consultations"
                               class="text-sm text-green-600 hover:text-green-800 font-semibold block text-center">
                                Voir toutes les consultations →
                            </a>
                        </div>
                    </div>
                </div>

                <div class="hidden md:block text-white">
                    <div class="flex items-center">
                        <div class="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center mr-3">
                            <i class="fas fa-user-md text-white"></i>
                        </div>
                        <div>
                            <p class="text-sm font-semibold">${sessionScope.userName}</p>
                            <p class="text-xs text-white/80">${sessionScope.userConnecte.specialite}</p>
                        </div>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/logout"
                   class="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-all duration-200 flex items-center shadow-lg hover:shadow-xl">
                    <i class="fas fa-sign-out-alt mr-2"></i>
                    <span class="hidden md:inline">Déconnexion</span>
                </a>
            </div>
        </div>

        <!-- Menu Mobile -->
        <div class="md:hidden pb-3">
            <div class="flex flex-col space-y-1">
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

<!-- Messages Flash -->
<c:if test="${not empty sessionScope.successMessage}">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-4">
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
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-4">
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