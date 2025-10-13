<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Espace Patient - Clinique Privée</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50 min-h-screen">

<!-- Navigation -->
<nav class="bg-white shadow-lg sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <i class="fas fa-heartbeat text-blue-600 text-2xl mr-3"></i>
                <span class="text-xl font-bold text-gray-800">Clinique Privée</span>
                <span class="ml-4 px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-semibold">
                        Patient
                    </span>
            </div>
            <div class="flex items-center space-x-4">
                    <span class="text-gray-700">
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

<!-- Main Content -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">
            Bonjour, ${patient.prenom} ! 👋
        </h1>
        <p class="text-gray-600">Bienvenue dans votre espace patient</p>
    </div>

    <!-- Statistiques -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">

        <!-- Total Consultations -->
        <div class="bg-white rounded-xl shadow-md p-6 border-l-4 border-blue-500">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-600 mb-1">Total Consultations</p>
                    <p class="text-3xl font-bold text-gray-900">${totalConsultations}</p>
                </div>
                <div class="w-14 h-14 bg-blue-100 rounded-full flex items-center justify-center">
                    <i class="fas fa-calendar-check text-blue-600 text-2xl"></i>
                </div>
            </div>
        </div>

        <!-- Consultations à venir -->
        <div class="bg-white rounded-xl shadow-md p-6 border-l-4 border-green-500">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-600 mb-1">À venir</p>
                    <p class="text-3xl font-bold text-gray-900">${consultationsAvenir.size()}</p>
                </div>
                <div class="w-14 h-14 bg-green-100 rounded-full flex items-center justify-center">
                    <i class="fas fa-clock text-green-600 text-2xl"></i>
                </div>
            </div>
        </div>

        <!-- En attente -->
        <div class="bg-white rounded-xl shadow-md p-6 border-l-4 border-yellow-500">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-600 mb-1">En attente</p>
                    <p class="text-3xl font-bold text-gray-900">${consultationsEnAttente.size()}</p>
                </div>
                <div class="w-14 h-14 bg-yellow-100 rounded-full flex items-center justify-center">
                    <i class="fas fa-hourglass-half text-yellow-600 text-2xl"></i>
                </div>
            </div>
        </div>

        <!-- Terminées -->
        <div class="bg-white rounded-xl shadow-md p-6 border-l-4 border-purple-500">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-600 mb-1">Terminées</p>
                    <p class="text-3xl font-bold text-gray-900">${nombreConsultationsTerminees}</p>
                </div>
                <div class="w-14 h-14 bg-purple-100 rounded-full flex items-center justify-center">
                    <i class="fas fa-check-circle text-purple-600 text-2xl"></i>
                </div>
            </div>
        </div>

    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

        <!-- Prochaine Consultation -->
        <div class="lg:col-span-2">
            <div class="bg-white rounded-xl shadow-md p-6 mb-6">
                <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-calendar-day text-blue-600 mr-3"></i>
                    Prochaine Consultation
                </h2>

                <c:choose>
                    <c:when test="${not empty prochaineConsultation}">
                        <div class="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-lg p-6 border border-blue-200">
                            <div class="flex items-start justify-between mb-4">
                                <div class="flex-1">
                                    <div class="flex items-center mb-3">
                                        <i class="fas fa-user-md text-blue-600 mr-2"></i>
                                        <span class="text-lg font-semibold text-gray-900">
                                                Dr. ${prochaineConsultation.docteur.prenom} ${prochaineConsultation.docteur.nom}
                                            </span>
                                    </div>
                                    <div class="text-sm text-gray-600 space-y-2">
                                        <div class="flex items-center">
                                            <i class="fas fa-stethoscope w-5 mr-2"></i>
                                            <span>${prochaineConsultation.docteur.specialite}</span>
                                        </div>
                                        <div class="flex items-center">
                                            <i class="fas fa-calendar w-5 mr-2"></i>
                                            <span><fmt:formatDate value="${prochaineConsultation.date}" pattern="EEEE dd MMMM yyyy" /></span>
                                        </div>
                                        <div class="flex items-center">
                                            <i class="fas fa-clock w-5 mr-2"></i>
                                            <span>${prochaineConsultation.heure}</span>
                                        </div>
                                        <div class="flex items-center">
                                            <i class="fas fa-door-open w-5 mr-2"></i>
                                            <span>${prochaineConsultation.salle.nomSalle}</span>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${prochaineConsultation.statut == 'RESERVEE'}">
                                                <span class="px-3 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs font-semibold">
                                                    En attente
                                                </span>
                                        </c:when>
                                        <c:when test="${prochaineConsultation.statut == 'VALIDEE'}">
                                                <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-xs font-semibold">
                                                    Validée
                                                </span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>

                            <c:if test="${not empty prochaineConsultation.motifConsultation}">
                                <div class="mt-4 pt-4 border-t border-blue-200">
                                    <p class="text-sm text-gray-700">
                                        <span class="font-semibold">Motif :</span> ${prochaineConsultation.motifConsultation}
                                    </p>
                                </div>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-8">
                            <i class="fas fa-calendar-times text-gray-300 text-5xl mb-4"></i>
                            <p class="text-gray-500 mb-4">Aucune consultation prévue</p>
                            <a href="${pageContext.request.contextPath}/patient/reserver"
                               class="inline-block px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
                                <i class="fas fa-plus mr-2"></i>
                                Réserver une consultation
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Consultations à venir -->
            <div class="bg-white rounded-xl shadow-md p-6">
                <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-list text-blue-600 mr-3"></i>
                    Mes Consultations à venir
                </h2>

                <c:choose>
                    <c:when test="${not empty consultationsAvenir && consultationsAvenir.size() > 0}">
                        <div class="space-y-3">
                            <c:forEach var="consultation" items="${consultationsAvenir}" varStatus="status">
                                <c:if test="${status.index < 5}">
                                    <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
                                        <div class="flex-1">
                                            <p class="font-semibold text-gray-900">
                                                Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom}
                                            </p>
                                            <p class="text-sm text-gray-600">
                                                <fmt:formatDate value="${consultation.date}" pattern="dd/MM/yyyy" /> à ${consultation.heure}
                                            </p>
                                        </div>
                                        <c:choose>
                                            <c:when test="${consultation.statut == 'VALIDEE'}">
                                                    <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-xs font-semibold">
                                                        Validée
                                                    </span>
                                            </c:when>
                                            <c:otherwise>
                                                    <span class="px-3 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs font-semibold">
                                                        En attente
                                                    </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>

                        <c:if test="${consultationsAvenir.size() > 5}">
                            <div class="text-center mt-4">
                                <a href="${pageContext.request.contextPath}/patient/consultations"
                                   class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                                    Voir toutes les consultations (${consultationsAvenir.size()})
                                </a>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <p class="text-center text-gray-500 py-6">Aucune consultation prévue</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Actions Rapides -->
        <div class="lg:col-span-1">
            <div class="bg-white rounded-xl shadow-md p-6 sticky top-24">
                <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-bolt text-yellow-500 mr-3"></i>
                    Actions Rapides
                </h2>

                <div class="space-y-3">
                    <a href="${pageContext.request.contextPath}/patient/reserver"
                       class="flex items-center p-4 bg-blue-50 rounded-lg hover:bg-blue-100 transition group">
                        <div class="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center mr-3 group-hover:scale-110 transition">
                            <i class="fas fa-calendar-plus text-white"></i>
                        </div>
                        <div>
                            <p class="font-semibold text-gray-900">Nouvelle consultation</p>
                            <p class="text-xs text-gray-600">Réserver un rendez-vous</p>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/patient/consultations"
                       class="flex items-center p-4 bg-green-50 rounded-lg hover:bg-green-100 transition group">
                        <div class="w-10 h-10 bg-green-600 rounded-lg flex items-center justify-center mr-3 group-hover:scale-110 transition">
                            <i class="fas fa-clipboard-list text-white"></i>
                        </div>
                        <div>
                            <p class="font-semibold text-gray-900">Mes consultations</p>
                            <p class="text-xs text-gray-600">Voir toutes mes consultations</p>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/patient/historique"
                       class="flex items-center p-4 bg-purple-50 rounded-lg hover:bg-purple-100 transition group">
                        <div class="w-10 h-10 bg-purple-600 rounded-lg flex items-center justify-center mr-3 group-hover:scale-110 transition">
                            <i class="fas fa-history text-white"></i>
                        </div>
                        <div>
                            <p class="font-semibold text-gray-900">Historique médical</p>
                            <p class="text-xs text-gray-600">Consulter mes comptes rendus</p>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/patient/profil"
                       class="flex items-center p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition group">
                        <div class="w-10 h-10 bg-gray-600 rounded-lg flex items-center justify-center mr-3 group-hover:scale-110 transition">
                            <i class="fas fa-user-edit text-white"></i>
                        </div>
                        <div>
                            <p class="font-semibold text-gray-900">Mon profil</p>
                            <p class="text-xs text-gray-600">Modifier mes informations</p>
                        </div>
                    </a>
                </div>

                <!-- Informations Patient -->
                <div class="mt-6 pt-6 border-t border-gray-200">
                    <h3 class="text-sm font-semibold text-gray-700 mb-3">Mes Informations</h3>
                    <div class="space-y-2 text-sm text-gray-600">
                        <div class="flex justify-between">
                            <span>Poids :</span>
                            <span class="font-medium">${patient.poids} kg</span>
                        </div>
                        <div class="flex justify-between">
                            <span>Taille :</span>
                            <span class="font-medium">${patient.taille} m</span>
                        </div>
                        <div class="flex justify-between">
                            <span>IMC :</span>
                            <span class="font-medium">
                                    <fmt:formatNumber value="${patient.poids / (patient.taille * patient.taille)}" maxFractionDigits="1" />
                                </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

</div>

</body>
</html>