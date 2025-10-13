<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accès Refusé - Clinique Privée</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gradient-to-br from-red-50 to-orange-100 min-h-screen flex items-center justify-center p-4">

<div class="max-w-2xl w-full text-center">

    <!-- Icône d'erreur -->
    <div class="mb-8">
        <div class="w-32 h-32 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-6">
            <i class="fas fa-ban text-red-600 text-6xl"></i>
        </div>
        <h1 class="text-6xl font-bold text-gray-900 mb-4">403</h1>
        <h2 class="text-3xl font-bold text-gray-800 mb-4">Accès Refusé</h2>
        <p class="text-xl text-gray-600 mb-8">
            Vous n'avez pas les droits nécessaires pour accéder à cette page.
        </p>
    </div>

    <!-- Informations -->
    <div class="bg-white rounded-xl shadow-xl p-8 mb-8">
        <div class="flex items-start text-left">
            <i class="fas fa-info-circle text-blue-600 text-2xl mr-4 mt-1"></i>
            <div>
                <h3 class="text-lg font-semibold text-gray-800 mb-2">Pourquoi ce message ?</h3>
                <p class="text-gray-600 mb-4">
                    Vous avez tenté d'accéder à une section réservée à un autre type d'utilisateur.
                </p>
                <ul class="text-sm text-gray-600 space-y-2">
                    <li class="flex items-center">
                        <i class="fas fa-user text-blue-600 mr-2"></i>
                        <span>Les <strong>Patients</strong> accèdent à l'espace patient</span>
                    </li>
                    <li class="flex items-center">
                        <i class="fas fa-user-md text-green-600 mr-2"></i>
                        <span>Les <strong>Docteurs</strong> accèdent à l'espace docteur</span>
                    </li>
                    <li class="flex items-center">
                        <i class="fas fa-user-shield text-purple-600 mr-2"></i>
                        <span>Les <strong>Administrateurs</strong> accèdent à l'espace admin</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <!-- Actions -->
    <div class="flex flex-col sm:flex-row justify-center space-y-3 sm:space-y-0 sm:space-x-4">
        <button onclick="history.back()"
                class="px-8 py-3 bg-gray-600 text-white rounded-lg font-semibold hover:bg-gray-700 transition shadow-lg">
            <i class="fas fa-arrow-left mr-2"></i>
            Retour
        </button>

        <c:choose>
            <c:when test="${sessionScope.userConnecte != null}">
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'PATIENT'}">
                        <a href="${pageContext.request.contextPath}/patient/dashboard"
                           class="px-8 py-3 bg-blue-600 text-white rounded-lg font-semibold hover:bg-blue-700 transition shadow-lg inline-block">
                            <i class="fas fa-home mr-2"></i>
                            Mon Espace Patient
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.userRole == 'DOCTEUR'}">
                        <a href="${pageContext.request.contextPath}/docteur/dashboard"
                           class="px-8 py-3 bg-green-600 text-white rounded-lg font-semibold hover:bg-green-700 transition shadow-lg inline-block">
                            <i class="fas fa-home mr-2"></i>
                            Mon Espace Docteur
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.userRole == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard"
                           class="px-8 py-3 bg-purple-600 text-white rounded-lg font-semibold hover:bg-purple-700 transition shadow-lg inline-block">
                            <i class="fas fa-home mr-2"></i>
                            Espace Admin
                        </a>
                    </c:when>
                </c:choose>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login"
                   class="px-8 py-3 bg-blue-600 text-white rounded-lg font-semibold hover:bg-blue-700 transition shadow-lg inline-block">
                    <i class="fas fa-sign-in-alt mr-2"></i>
                    Se connecter
                </a>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Support -->
    <div class="mt-8 text-gray-600">
        <p class="text-sm">
            Besoin d'aide ?
            <a href="#" class="text-blue-600 hover:text-blue-800 font-medium">
                Contactez le support
            </a>
        </p>
    </div>

</div>

</body>
</html>