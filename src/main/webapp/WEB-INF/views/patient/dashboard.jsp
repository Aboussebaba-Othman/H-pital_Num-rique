<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord Patient - Clinique</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">

<c:set var="pageParam" value="dashboard" scope="request"/>
<%@ include file="../common/patient-nav.jsp" %>

<div class="max-w-7xl mx-auto p-6">

    <!-- Header avec gradient -->
    <div class="mb-8">
        <div class="bg-gradient-to-r from-blue-600 via-indigo-600 to-purple-600 text-white rounded-2xl p-8 shadow-xl">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-4xl font-bold mb-2">Bonjour, ${patient.prenom} ${patient.nom}! 👋</h1>
                    <p class="text-blue-100 text-lg">Bienvenue sur votre espace santé personnel</p>
                </div>
                <div class="hidden md:block">
                    <div class="w-24 h-24 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                        <i class="fas fa-user-circle text-6xl text-white"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Statistiques avec animations -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Total -->
        <div class="bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition-all duration-300 hover:-translate-y-1">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <p class="text-sm text-gray-500 font-medium mb-1">Total Consultations</p>
                    <p class="text-4xl font-bold text-gray-800">${totalConsultations}</p>
                </div>
                <div class="w-16 h-16 bg-gradient-to-br from-blue-400 to-blue-600 rounded-2xl flex items-center justify-center shadow-lg">
                    <i class="fas fa-calendar-alt text-white text-2xl"></i>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/patient/consultations"
               class="text-sm text-blue-600 hover:text-blue-700 font-medium flex items-center">
                Voir mes consultations <i class="fas fa-arrow-right ml-2 text-xs"></i>
            </a>
        </div>

        <!-- Réservées -->
        <div class="bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition-all duration-300 hover:-translate-y-1">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <p class="text-sm text-gray-500 font-medium mb-1">Réservées</p>
                    <p class="text-4xl font-bold text-yellow-600">${nombreConsultationsReservees}</p>
                </div>
                <div class="w-16 h-16 bg-gradient-to-br from-yellow-400 to-yellow-600 rounded-2xl flex items-center justify-center shadow-lg">
                    <i class="fas fa-clock text-white text-2xl"></i>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/patient/consultations"
               class="text-sm text-yellow-600 hover:text-yellow-700 font-medium flex items-center">
                Gérer <i class="fas fa-arrow-right ml-2 text-xs"></i>
            </a>
        </div>

        <!-- Terminées -->
        <div class="bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition-all duration-300 hover:-translate-y-1">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <p class="text-sm text-gray-500 font-medium mb-1">Terminées</p>
                    <p class="text-4xl font-bold text-green-600">${nombreConsultationsTerminees}</p>
                </div>
                <div class="w-16 h-16 bg-gradient-to-br from-green-400 to-green-600 rounded-2xl flex items-center justify-center shadow-lg">
                    <i class="fas fa-check-circle text-white text-2xl"></i>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/patient/historique"
               class="text-sm text-green-600 hover:text-green-700 font-medium flex items-center">
                Voir l'historique <i class="fas fa-arrow-right ml-2 text-xs"></i>
            </a>
        </div>

        <!-- IMC -->
        <div class="bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition-all duration-300 hover:-translate-y-1">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <p class="text-sm text-gray-500 font-medium mb-1">IMC</p>
                    <p class="text-4xl font-bold text-cyan-600">
                        <c:choose>
                            <c:when test="${not empty patient.poids && not empty patient.taille}">
                                <fmt:formatNumber value="${patient.poids / ((patient.taille / 100) * (patient.taille / 100))}" maxFractionDigits="1"/>
                            </c:when>
                            <c:otherwise>--</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="w-16 h-16 bg-gradient-to-br from-cyan-400 to-cyan-600 rounded-2xl flex items-center justify-center shadow-lg">
                    <i class="fas fa-heartbeat text-white text-2xl"></i>
                </div>
            </div>
            <p class="text-xs text-gray-500">Indice de masse corporelle</p>
        </div>
    </div>

    <!-- Prochaine consultation avec design moderne -->
    <c:if test="${not empty prochaineConsultation}">
        <div class="bg-gradient-to-br from-indigo-50 to-purple-50 rounded-2xl shadow-lg p-8 mb-8 border border-indigo-100">
            <div class="flex items-center mb-6">
                <div class="w-12 h-12 bg-gradient-to-br from-indigo-500 to-purple-500 rounded-xl flex items-center justify-center mr-4">
                    <i class="fas fa-calendar-star text-white text-xl"></i>
                </div>
                <h3 class="text-2xl font-bold text-gray-800">Prochaine Consultation</h3>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                <div class="space-y-4">
                    <div class="flex items-center">
                        <div class="w-10 h-10 bg-white rounded-lg flex items-center justify-center mr-4 shadow">
                            <i class="fas fa-calendar text-indigo-600"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500 font-medium">Date</p>
                            <p class="text-lg font-semibold text-gray-800">${prochaineConsultation.date}</p>
                        </div>
                    </div>

                    <div class="flex items-center">
                        <div class="w-10 h-10 bg-white rounded-lg flex items-center justify-center mr-4 shadow">
                            <i class="fas fa-clock text-indigo-600"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500 font-medium">Heure</p>
                            <p class="text-lg font-semibold text-gray-800">${prochaineConsultation.heure}</p>
                        </div>
                    </div>

                    <div class="flex items-center">
                        <div class="w-10 h-10 bg-white rounded-lg flex items-center justify-center mr-4 shadow">
                            <i class="fas fa-door-open text-indigo-600"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500 font-medium">Salle</p>
                            <p class="text-lg font-semibold text-gray-800">${prochaineConsultation.salle.nomSalle}</p>
                        </div>
                    </div>
                </div>

                <div class="space-y-4">
                    <div class="flex items-center">
                        <div class="w-10 h-10 bg-white rounded-lg flex items-center justify-center mr-4 shadow">
                            <i class="fas fa-user-md text-indigo-600"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500 font-medium">Docteur</p>
                            <p class="text-lg font-semibold text-gray-800">Dr. ${prochaineConsultation.docteur.prenom} ${prochaineConsultation.docteur.nom}</p>
                        </div>
                    </div>

                    <div class="flex items-center">
                        <div class="w-10 h-10 bg-white rounded-lg flex items-center justify-center mr-4 shadow">
                            <i class="fas fa-stethoscope text-indigo-600"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500 font-medium">Spécialité</p>
                            <p class="text-lg font-semibold text-gray-800">${prochaineConsultation.docteur.specialite}</p>
                        </div>
                    </div>

                    <div class="flex items-start">
                        <div class="w-10 h-10 bg-white rounded-lg flex items-center justify-center mr-4 shadow flex-shrink-0">
                            <i class="fas fa-file-medical text-indigo-600"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-xs text-gray-500 font-medium mb-1">Motif</p>
                            <p class="text-sm text-gray-700 leading-relaxed">${prochaineConsultation.motifConsultation}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Message si pas de consultation -->
    <c:if test="${empty prochaineConsultation}">
        <div class="bg-white rounded-2xl shadow-lg p-12 mb-8 text-center">
            <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <i class="fas fa-calendar-times text-5xl text-gray-300"></i>
            </div>
            <h3 class="text-2xl font-bold text-gray-800 mb-2">Aucune consultation à venir</h3>
            <p class="text-gray-500 mb-6">Prenez rendez-vous avec un médecin dès maintenant</p>
            <a href="${pageContext.request.contextPath}/patient/reserver"
               class="inline-block px-8 py-4 bg-gradient-to-r from-indigo-600 to-purple-600 text-white rounded-xl hover:from-indigo-700 hover:to-purple-700 transition shadow-lg font-medium">
                <i class="fas fa-calendar-plus mr-2"></i>Réserver une consultation
            </a>
        </div>
    </c:if>

    <!-- Actions rapides avec design carte -->
    <div class="bg-white rounded-2xl shadow-lg p-8 mb-8">
        <div class="flex items-center mb-6">
            <div class="w-10 h-10 bg-gradient-to-br from-green-400 to-green-600 rounded-lg flex items-center justify-center mr-3">
                <i class="fas fa-rocket text-white"></i>
            </div>
            <h3 class="text-xl font-bold text-gray-800">Actions rapides</h3>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <a href="${pageContext.request.contextPath}/patient/reserver"
               class="group flex items-center p-5 bg-gradient-to-r from-indigo-500 to-purple-500 text-white rounded-xl hover:from-indigo-600 hover:to-purple-600 transition shadow-md">
                <div class="w-12 h-12 bg-white bg-opacity-20 rounded-lg flex items-center justify-center mr-4">
                    <i class="fas fa-calendar-plus text-xl"></i>
                </div>
                <div>
                    <p class="font-semibold text-lg">Réserver une consultation</p>
                    <p class="text-xs text-indigo-100">Prendre rendez-vous</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/patient/docteurs"
               class="group flex items-center p-5 bg-sky-50 hover:bg-sky-100 rounded-xl transition shadow-md border border-sky-100">
                <div class="w-12 h-12 bg-sky-500 rounded-lg flex items-center justify-center mr-4">
                    <i class="fas fa-user-md text-white text-xl"></i>
                </div>
                <div>
                    <p class="font-semibold text-lg text-gray-800">Trouver un docteur</p>
                    <p class="text-xs text-gray-500">Parcourir les spécialistes</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/patient/consultations"
               class="group flex items-center p-5 bg-amber-50 hover:bg-amber-100 rounded-xl transition shadow-md border border-amber-100">
                <div class="w-12 h-12 bg-amber-500 rounded-lg flex items-center justify-center mr-4">
                    <i class="fas fa-list text-white text-xl"></i>
                </div>
                <div>
                    <p class="font-semibold text-lg text-gray-800">Mes consultations</p>
                    <p class="text-xs text-gray-500">Gérer mes rendez-vous</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/patient/historique"
               class="group flex items-center p-5 bg-gray-50 hover:bg-gray-100 rounded-xl transition shadow-md border border-gray-200">
                <div class="w-12 h-12 bg-gray-600 rounded-lg flex items-center justify-center mr-4">
                    <i class="fas fa-history text-white text-xl"></i>
                </div>
                <div>
                    <p class="font-semibold text-lg text-gray-800">Historique médical</p>
                    <p class="text-xs text-gray-500">Consulter mon dossier</p>
                </div>
            </a>
        </div>
    </div>

    <!-- Informations patient -->
    <div class="bg-white rounded-2xl shadow-lg p-8">
        <div class="flex items-center mb-6">
            <div class="w-10 h-10 bg-gradient-to-br from-gray-400 to-gray-600 rounded-lg flex items-center justify-center mr-3">
                <i class="fas fa-user-circle text-white"></i>
            </div>
            <h3 class="text-xl font-bold text-gray-800">Mes informations</h3>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div class="p-4 bg-gray-50 rounded-xl">
                <p class="text-xs text-gray-500 font-medium mb-2">Email</p>
                <p class="text-sm font-semibold text-gray-800">${patient.email}</p>
            </div>

            <div class="p-4 bg-gray-50 rounded-xl">
                <p class="text-xs text-gray-500 font-medium mb-2">Poids</p>
                <p class="text-sm font-semibold text-gray-800">
                    <c:choose>
                        <c:when test="${not empty patient.poids}">
                            <fmt:formatNumber value="${patient.poids}" maxFractionDigits="1"/> kg
                        </c:when>
                        <c:otherwise>Non renseigné</c:otherwise>
                    </c:choose>
                </p>
            </div>

            <div class="p-4 bg-gray-50 rounded-xl">
                <p class="text-xs text-gray-500 font-medium mb-2">Taille</p>
                <p class="text-sm font-semibold text-gray-800">
                    <c:choose>
                        <c:when test="${not empty patient.taille}">
                            ${patient.taille} cm
                        </c:when>
                        <c:otherwise>Non renseignée</c:otherwise>
                    </c:choose>
                </p>
            </div>

            <div class="p-4 bg-gradient-to-br from-indigo-50 to-purple-50 rounded-xl border border-indigo-100">
                <p class="text-xs text-indigo-600 font-medium mb-2">Membre depuis</p>
                <p class="text-sm font-semibold text-gray-800">Patient Vérifié ✓</p>
            </div>
        </div>
    </div>

</div>

</body>
</html>