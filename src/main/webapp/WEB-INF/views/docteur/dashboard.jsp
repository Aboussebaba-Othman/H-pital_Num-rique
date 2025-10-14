<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espace Docteur - Clinique Privée</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50 min-h-screen">

<!-- Navigation -->
<nav class="bg-white shadow-lg sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <i class="fas fa-heartbeat text-green-600 text-2xl mr-3"></i>
                <span class="text-xl font-bold text-gray-800">Clinique Privée</span>
                <span class="ml-4 px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm font-semibold">
                        Docteur
                    </span>
            </div>
            <div class="flex items-center space-x-4">
                    <span class="text-gray-700">
                        <i class="fas fa-user-md mr-2"></i>
                        Dr. ${sessionScope.userName}
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
            Bienvenue, Dr. ${docteur.prenom} ${docteur.nom} ! 🩺
        </h1>
        <p class="text-gray-600">
            <i class="fas fa-stethoscope mr-2"></i>
            ${docteur.specialite} - ${docteur.departement.nom}
        </p>
    </div>

    <!-- Statistiques -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">

        <!-- Planning Total -->
        <div class="bg-white rounded-xl shadow-md p-6 border-l-4 border-green-500">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-600 mb-1">Planning Total</p>
                    <p class="text-3xl font-bold text-gray-900">${totalConsultations}</p>
                </div>
                <div class="w-14 h-14 bg-green-100 rounded-full flex items-center justify-center">
                    <i class="fas fa-calendar-alt text-green-600 text-2xl"></i>
                </div>
            </div>
        </div>

        <!-- Aujourd'hui -->
        <div class="bg-white rounded-xl shadow-md p-6 border-l-4 border-blue-500">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-600 mb-1">Aujourd'hui</p>
                    <p class="text-3xl font-bold text-gray-900">${consultationsDuJour.size()}</p>
                </div>
                <div class="w-14 h-14 bg-blue-100 rounded-full flex items-center justify-center">
                    <i class="fas fa-calendar-day text-blue-600 text-2xl"></i>
                </div>
            </div>
        </div>

        <!-- En attente -->
        <div class="bg-white rounded-xl shadow-md p-6 border-l-4 border-yellow-500">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-600 mb-1">À valider</p>
                    <p class="text-3xl font-bold text-gray-900">${consultationsEnAttente.size()}</p>
                </div>
                <div class="w-14 h-14 bg-yellow-100 rounded-full flex items-center justify-center">
                    <i class="fas fa-exclamation-circle text-yellow-600 text-2xl"></i>
                </div>
            </div>
        </div>

        <!-- Validées -->
        <div class="bg-white rounded-xl shadow-md p-6 border-l-4 border-indigo-500">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-600 mb-1">Validées</p>
                    <p class="text-3xl font-bold text-gray-900">${consultationsValidees.size()}</p>
                </div>
                <div class="w-14 h-14 bg-indigo-100 rounded-full flex items-center justify-center">
                    <i class="fas fa-check-double text-indigo-600 text-2xl"></i>
                </div>
            </div>
        </div>

    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

        <!-- Prochaine Consultation + Planning du jour -->
        <div class="lg:col-span-2 space-y-6">

            <!-- Prochaine Consultation -->
            <div class="bg-white rounded-xl shadow-md p-6">
                <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-clock text-green-600 mr-3"></i>
                    Prochaine Consultation
                </h2>

                <c:choose>
                    <c:when test="${not empty prochaineConsultation}">
                        <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-lg p-6 border border-green-200">
                            <div class="flex items-start justify-between mb-4">
                                <div class="flex-1">
                                    <div class="flex items-center mb-3">
                                        <i class="fas fa-user text-green-600 mr-2"></i>
                                        <span class="text-lg font-semibold text-gray-900">
                                                ${prochaineConsultation.patient.prenom} ${prochaineConsultation.patient.nom}
                                            </span>
                                    </div>
                                    <div class="text-sm text-gray-600 space-y-2">
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
                                <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-xs font-semibold">
                                        Validée
                                    </span>
                            </div>

                            <div class="mt-4 pt-4 border-t border-green-200">
                                <p class="text-sm text-gray-700">
                                    <span class="font-semibold">Motif :</span> ${prochaineConsultation.motifConsultation}
                                </p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-8">
                            <i class="fas fa-calendar-times text-gray-300 text-5xl mb-4"></i>
                            <p class="text-gray-500">Aucune consultation validée prévue</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Planning du jour -->
            <div class="bg-white rounded-xl shadow-md p-6">
                <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-calendar-day text-blue-600 mr-3"></i>
                    Planning d'aujourd'hui
                </h2>

                <c:choose>
                    <c:when test="${not empty consultationsDuJour}">
                        <div class="space-y-3">
                            <c:forEach var="consultation" items="${consultationsDuJour}">
                                <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition border-l-4
                                         <c:choose>
                                             <c:when test="${consultation.statut == 'VALIDEE'}">border-green-500</c:when>
                                             <c:when test="${consultation.statut == 'RESERVEE'}">border-yellow-500</c:when>
                                         </c:choose>">
                                    <div class="flex-1">
                                        <div class="flex items-center mb-1">
                                                <span class="font-semibold text-gray-900 mr-3">
                                                        ${consultation.heure}
                                                </span>
                                            <span class="text-gray-700">
                                                    ${consultation.patient.prenom} ${consultation.patient.nom}
                                                </span>
                                        </div>
                                        <p class="text-sm text-gray-600">${consultation.salle.nomSalle}</p>
                                    </div>
                                    <c:choose>
                                        <c:when test="${consultation.statut == 'VALIDEE'}">
                                                <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-xs font-semibold">
                                                    Validée
                                                </span>
                                        </c:when>
                                        <c:when test="${consultation.statut == 'RESERVEE'}">
                                                <span class="px-3 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs font-semibold">
                                                    En attente
                                                </span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-center text-gray-500 py-6">Aucune consultation aujourd'hui</p>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

        <!-- Actions Rapides + Consultations en attente -->
        <div class="lg:col-span-1 space-y-6">

            <!-- Actions Rapides -->
            <div class="bg-white rounded-xl shadow-md p-6">
                <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-bolt text-yellow-500 mr-3"></i>
                    Actions Rapides
                </h2>

                <div class="space-y-3">
                    <a href="${pageContext.request.contextPath}/docteur/planning"
                       class="flex items-center p-4 bg-green-50 rounded-lg hover:bg-green-100 transition group">
                        <div class="w-10 h-10 bg-green-600 rounded-lg flex items-center justify-center mr-3 group-hover:scale-110 transition">
                            <i class="fas fa-calendar-alt text-white"></i>
                        </div>
                        <div>
                            <p class="font-semibold text-gray-900">Mon Planning</p>
                            <p class="text-xs text-gray-600">Vue calendrier complète</p>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/docteur/consultations"
                       class="flex items-center p-4 bg-blue-50 rounded-lg hover:bg-blue-100 transition group">
                        <div class="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center mr-3 group-hover:scale-110 transition">
                            <i class="fas fa-clipboard-list text-white"></i>
                        </div>
                        <div>
                            <p class="font-semibold text-gray-900">Consultations</p>
                            <p class="text-xs text-gray-600">Toutes mes consultations</p>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/docteur/patients"
                       class="flex items-center p-4 bg-purple-50 rounded-lg hover:bg-purple-100 transition group">
                        <div class="w-10 h-10 bg-purple-600 rounded-lg flex items-center justify-center mr-3 group-hover:scale-110 transition">
                            <i class="fas fa-users text-white"></i>
                        </div>
                        <div>
                            <p class="font-semibold text-gray-900">Mes Patients</p>
                            <p class="text-xs text-gray-600">Liste et historiques</p>
                        </div>
                    </a>
                </div>
            </div>

            <!-- Consultations en attente -->
            <div class="bg-white rounded-xl shadow-md p-6">
                <h2 class="text-lg font-bold text-gray-900 mb-4 flex items-center justify-between">
                        <span>
                            <i class="fas fa-hourglass-half text-yellow-500 mr-2"></i>
                            En attente
                        </span>
                    <c:if test="${not empty consultationsEnAttente}">
                            <span class="px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs font-semibold">
                                    ${consultationsEnAttente.size()}
                            </span>
                    </c:if>
                </h2>

                <c:choose>
                    <c:when test="${not empty consultationsEnAttente}">
                        <div class="space-y-3">
                            <c:forEach var="consultation" items="${consultationsEnAttente}" varStatus="status">
                                <c:if test="${status.index < 5}">
                                    <div class="p-4 bg-yellow-50 rounded-lg border border-yellow-200">
                                        <div class="flex items-center justify-between mb-2">
                                                <span class="font-semibold text-gray-900 text-sm">
                                                    ${consultation.patient.prenom} ${consultation.patient.nom}
                                                </span>
                                        </div>
                                        <p class="text-xs text-gray-600 mb-3">
                                            <i class="fas fa-calendar mr-1"></i>
                                            <fmt:formatDate value="${consultation.date}" pattern="dd/MM/yyyy" /> à ${consultation.heure}
                                        </p>
                                        <div class="flex space-x-2">
                                            <form action="${pageContext.request.contextPath}/docteur/valider" method="post" class="flex-1">
                                                <input type="hidden" name="consultationId" value="${consultation.idConsultation}">
                                                <button type="submit"
                                                        class="w-full px-3 py-2 bg-green-600 text-white rounded text-xs hover:bg-green-700 transition">
                                                    <i class="fas fa-check mr-1"></i>
                                                    Valider
                                                </button>
                                            </form>
                                            <button onclick="refuserConsultation(${consultation.idConsultation})"
                                                    class="flex-1 px-3 py-2 bg-red-600 text-white rounded text-xs hover:bg-red-700 transition">
                                                <i class="fas fa-times mr-1"></i>
                                                Refuser
                                            </button>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>

                        <c:if test="${consultationsEnAttente.size() > 5}">
                            <div class="text-center mt-4">
                                <a href="${pageContext.request.contextPath}/docteur/consultations?statut=RESERVEE"
                                   class="text-yellow-600 hover:text-yellow-800 text-sm font-medium">
                                    Voir toutes (${consultationsEnAttente.size()})
                                </a>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <p class="text-center text-gray-500 py-4 text-sm">
                            Aucune consultation en attente
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

    </div>

</div>

<script>
    function refuserConsultation(consultationId) {
        const motif = prompt("Motif du refus (optionnel) :");
        if (motif !== null) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/docteur/refuser';

            const inputId = document.createElement('input');
            inputId.type = 'hidden';
            inputId.name = 'consultationId';
            inputId.value = consultationId;

            const inputMotif = document.createElement('input');
            inputMotif.type = 'hidden';
            inputMotif.name = 'motif';
            inputMotif.value = motif;

            form.appendChild(inputId);
            form.appendChild(inputMotif);
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>

</body>
</html>