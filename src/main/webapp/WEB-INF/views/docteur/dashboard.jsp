<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Docteur - Clinique Privée</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen">

<!-- Navigation -->
<jsp:include page="/WEB-INF/views/common/docteur-nav.jsp" />

<!-- Main Content -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header avec Bienvenue -->
    <div class="mb-8 bg-white rounded-xl shadow-lg p-6 border-l-4 border-green-500">
        <div class="flex items-center justify-between">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 mb-2">
                    Bienvenue, Dr. ${docteur.prenom} ${docteur.nom} ! 🩺
                </h1>
                <p class="text-gray-600 flex items-center">
                    <i class="fas fa-stethoscope mr-2 text-green-600"></i>
                    <span class="font-semibold">${docteur.specialite}</span>
                    <span class="mx-2">•</span>
                    <span>${docteur.departement.nom}</span>
                </p>
            </div>
            <div class="hidden md:block">
                <div class="text-right">
                    <p class="text-sm text-gray-500">Aujourd'hui</p>
                    <p class="text-lg font-semibold text-gray-900">
                        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="EEEE dd MMMM yyyy" />
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Statistiques Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">

        <!-- Planning Total -->
        <div class="bg-white rounded-xl shadow-lg p-6 border-t-4 border-green-500 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
            <div class="flex items-center justify-between mb-4">
                <div class="w-14 h-14 bg-gradient-to-br from-green-400 to-green-600 rounded-full flex items-center justify-center shadow-lg">
                    <i class="fas fa-calendar-alt text-white text-2xl"></i>
                </div>
                <span class="text-xs font-semibold text-green-600 bg-green-100 px-2 py-1 rounded-full">Total</span>
            </div>
            <p class="text-sm text-gray-600 mb-1 font-medium">Planning Total</p>
            <p class="text-4xl font-bold text-gray-900">${totalConsultations}</p>
            <p class="text-xs text-gray-500 mt-2">Toutes consultations</p>
        </div>

        <!-- Aujourd'hui -->
        <div class="bg-white rounded-xl shadow-lg p-6 border-t-4 border-blue-500 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
            <div class="flex items-center justify-between mb-4">
                <div class="w-14 h-14 bg-gradient-to-br from-blue-400 to-blue-600 rounded-full flex items-center justify-center shadow-lg">
                    <i class="fas fa-calendar-day text-white text-2xl"></i>
                </div>
                <span class="text-xs font-semibold text-blue-600 bg-blue-100 px-2 py-1 rounded-full">Aujourd'hui</span>
            </div>
            <p class="text-sm text-gray-600 mb-1 font-medium">Consultations du Jour</p>
            <p class="text-4xl font-bold text-gray-900">${consultationsDuJour.size()}</p>
            <p class="text-xs text-gray-500 mt-2">En cours et à venir</p>
        </div>

        <!-- En attente -->
        <div class="bg-white rounded-xl shadow-lg p-6 border-t-4 border-yellow-500 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
            <div class="flex items-center justify-between mb-4">
                <div class="w-14 h-14 bg-gradient-to-br from-yellow-400 to-yellow-600 rounded-full flex items-center justify-center shadow-lg">
                    <i class="fas fa-hourglass-half text-white text-2xl"></i>
                </div>
                <span class="text-xs font-semibold text-yellow-600 bg-yellow-100 px-2 py-1 rounded-full">À valider</span>
            </div>
            <p class="text-sm text-gray-600 mb-1 font-medium">En Attente</p>
            <p class="text-4xl font-bold text-gray-900">${consultationsEnAttente.size()}</p>
            <p class="text-xs text-gray-500 mt-2">Nécessitent validation</p>
        </div>

        <!-- Validées -->
        <div class="bg-white rounded-xl shadow-lg p-6 border-t-4 border-purple-500 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
            <div class="flex items-center justify-between mb-4">
                <div class="w-14 h-14 bg-gradient-to-br from-purple-400 to-purple-600 rounded-full flex items-center justify-center shadow-lg">
                    <i class="fas fa-check-double text-white text-2xl"></i>
                </div>
                <span class="text-xs font-semibold text-purple-600 bg-purple-100 px-2 py-1 rounded-full">Confirmées</span>
            </div>
            <p class="text-sm text-gray-600 mb-1 font-medium">Validées</p>
            <p class="text-4xl font-bold text-gray-900">${consultationsValidees.size()}</p>
            <p class="text-xs text-gray-500 mt-2">Prêtes à commencer</p>
        </div>

    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

        <!-- Colonne Principale (2/3) -->
        <div class="lg:col-span-2 space-y-6">

            <!-- Prochaine Consultation -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-2xl font-bold text-gray-900 flex items-center">
                        <i class="fas fa-clock text-green-600 mr-3"></i>
                        Prochaine Consultation
                    </h2>
                    <c:if test="${not empty prochaineConsultation}">
                        <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-xs font-semibold">
                            <i class="fas fa-check-circle mr-1"></i> Validée
                        </span>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${not empty prochaineConsultation}">
                        <div class="bg-gradient-to-r from-green-50 via-emerald-50 to-teal-50 rounded-xl p-6 border border-green-200 shadow-inner">
                            <div class="flex items-start justify-between mb-4">
                                <div class="flex-1">
                                    <div class="flex items-center mb-4">
                                        <div class="w-12 h-12 bg-green-600 rounded-full flex items-center justify-center mr-3 shadow-md">
                                            <i class="fas fa-user text-white text-lg"></i>
                                        </div>
                                        <div>
                                            <span class="text-xl font-bold text-gray-900 block">
                                                ${prochaineConsultation.patient.prenom} ${prochaineConsultation.patient.nom}
                                            </span>
                                            <span class="text-sm text-gray-600">Patient</span>
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div class="flex items-center bg-white/60 p-3 rounded-lg">
                                            <i class="fas fa-calendar text-green-600 w-6 mr-3"></i>
                                            <div>
                                                <p class="text-xs text-gray-600">Date</p>
                                                <p class="font-semibold text-gray-900">${prochaineConsultation.dateFormatee}</p>
                                            </div>
                                        </div>
                                        <div class="flex items-center bg-white/60 p-3 rounded-lg">
                                            <i class="fas fa-clock text-green-600 w-6 mr-3"></i>
                                            <div>
                                                <p class="text-xs text-gray-600">Heure</p>
                                                <p class="font-semibold text-gray-900">${prochaineConsultation.heure}</p>
                                            </div>
                                        </div>
                                        <div class="flex items-center bg-white/60 p-3 rounded-lg">
                                            <i class="fas fa-door-open text-green-600 w-6 mr-3"></i>
                                            <div>
                                                <p class="text-xs text-gray-600">Salle</p>
                                                <p class="font-semibold text-gray-900">${prochaineConsultation.salle.nomSalle}</p>
                                            </div>
                                        </div>
                                        <div class="flex items-center bg-white/60 p-3 rounded-lg">
                                            <i class="fas fa-hourglass-half text-green-600 w-6 mr-3"></i>
                                            <div>
                                                <p class="text-xs text-gray-600">Durée</p>
                                                <p class="font-semibold text-gray-900">30 minutes</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-4 pt-4 border-t border-green-200">
                                <div class="bg-white/80 rounded-lg p-4">
                                    <p class="text-sm font-semibold text-gray-700 mb-2">
                                        <i class="fas fa-notes-medical mr-2 text-green-600"></i>Motif de consultation
                                    </p>
                                    <p class="text-gray-800">${prochaineConsultation.motifConsultation}</p>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12 bg-gray-50 rounded-xl border-2 border-dashed border-gray-300">
                            <i class="fas fa-calendar-times text-gray-400 text-6xl mb-4"></i>
                            <p class="text-gray-600 text-lg font-medium">Aucune consultation validée prévue</p>
                            <p class="text-gray-500 text-sm mt-2">Les nouvelles réservations apparaîtront ici</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Planning du jour -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-2xl font-bold text-gray-900 flex items-center">
                        <i class="fas fa-calendar-day text-blue-600 mr-3"></i>
                        Planning d'Aujourd'hui
                    </h2>
                    <c:if test="${not empty consultationsDuJour}">
                        <span class="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-semibold">
                            ${consultationsDuJour.size()} consultation(s)
                        </span>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${not empty consultationsDuJour}">
                        <div class="space-y-3">
                            <c:forEach var="consultation" items="${consultationsDuJour}">
                                <div class="group flex items-center justify-between p-4 bg-gradient-to-r from-gray-50 to-gray-100 rounded-xl hover:shadow-md transition-all duration-200 border-l-4
                                     <c:choose>
                                         <c:when test="${consultation.statut == 'VALIDEE'}">border-green-500</c:when>
                                         <c:when test="${consultation.statut == 'RESERVEE'}">border-yellow-500</c:when>
                                     </c:choose>">
                                    <div class="flex-1 flex items-center">
                                        <div class="w-12 h-12 rounded-full flex items-center justify-center mr-4
                                             <c:choose>
                                                 <c:when test="${consultation.statut == 'VALIDEE'}">bg-green-100 text-green-600</c:when>
                                                 <c:when test="${consultation.statut == 'RESERVEE'}">bg-yellow-100 text-yellow-600</c:when>
                                             </c:choose>">
                                            <i class="fas fa-user-injured text-lg"></i>
                                        </div>
                                        <div>
                                            <div class="flex items-center mb-1">
                                                <span class="font-bold text-gray-900 text-lg mr-3">
                                                        ${consultation.heure}
                                                </span>
                                                <span class="font-semibold text-gray-800">
                                                    ${consultation.patient.prenom} ${consultation.patient.nom}
                                                </span>
                                            </div>
                                            <p class="text-sm text-gray-600 flex items-center">
                                                <i class="fas fa-door-open mr-2 text-gray-400"></i>
                                                    ${consultation.salle.nomSalle}
                                            </p>
                                        </div>
                                    </div>
                                    <c:choose>
                                        <c:when test="${consultation.statut == 'VALIDEE'}">
                                            <span class="px-4 py-2 bg-green-100 text-green-800 rounded-lg text-sm font-semibold shadow-sm">
                                                <i class="fas fa-check-circle mr-1"></i> Validée
                                            </span>
                                        </c:when>
                                        <c:when test="${consultation.statut == 'RESERVEE'}">
                                            <span class="px-4 py-2 bg-yellow-100 text-yellow-800 rounded-lg text-sm font-semibold shadow-sm">
                                                <i class="fas fa-hourglass-half mr-1"></i> En attente
                                            </span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12 bg-gray-50 rounded-xl border-2 border-dashed border-gray-300">
                            <i class="fas fa-moon text-gray-400 text-5xl mb-4"></i>
                            <p class="text-gray-600 text-lg">Aucune consultation aujourd'hui</p>
                            <p class="text-gray-500 text-sm mt-2">Profitez de cette journée pour vous reposer ! 😊</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

        <!-- Colonne Latérale (1/3) -->
        <div class="lg:col-span-1 space-y-6">

            <!-- Actions Rapides -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-bolt text-yellow-500 mr-3"></i>
                    Actions Rapides
                </h2>

                <div class="space-y-3">
                    <a href="${pageContext.request.contextPath}/docteur/planning"
                       class="group flex items-center p-4 bg-gradient-to-r from-green-50 to-green-100 rounded-xl hover:from-green-100 hover:to-green-200 transition-all duration-200 shadow-sm hover:shadow-md">
                        <div class="w-12 h-12 bg-green-600 rounded-xl flex items-center justify-center mr-3 group-hover:scale-110 transition-transform shadow-md">
                            <i class="fas fa-calendar-alt text-white text-lg"></i>
                        </div>
                        <div>
                            <p class="font-bold text-gray-900">Mon Planning</p>
                            <p class="text-xs text-gray-600">Vue calendrier complète</p>
                        </div>
                        <i class="fas fa-chevron-right ml-auto text-gray-400 group-hover:text-green-600 transition"></i>
                    </a>

                    <a href="${pageContext.request.contextPath}/docteur/consultations"
                       class="group flex items-center p-4 bg-gradient-to-r from-blue-50 to-blue-100 rounded-xl hover:from-blue-100 hover:to-blue-200 transition-all duration-200 shadow-sm hover:shadow-md">
                        <div class="w-12 h-12 bg-blue-600 rounded-xl flex items-center justify-center mr-3 group-hover:scale-110 transition-transform shadow-md">
                            <i class="fas fa-clipboard-list text-white text-lg"></i>
                        </div>
                        <div>
                            <p class="font-bold text-gray-900">Consultations</p>
                            <p class="text-xs text-gray-600">Toutes mes consultations</p>
                        </div>
                        <i class="fas fa-chevron-right ml-auto text-gray-400 group-hover:text-blue-600 transition"></i>
                    </a>

                    <a href="${pageContext.request.contextPath}/docteur/patients"
                       class="group flex items-center p-4 bg-gradient-to-r from-purple-50 to-purple-100 rounded-xl hover:from-purple-100 hover:to-purple-200 transition-all duration-200 shadow-sm hover:shadow-md">
                        <div class="w-12 h-12 bg-purple-600 rounded-xl flex items-center justify-center mr-3 group-hover:scale-110 transition-transform shadow-md">
                            <i class="fas fa-users text-white text-lg"></i>
                        </div>
                        <div>
                            <p class="font-bold text-gray-900">Mes Patients</p>
                            <p class="text-xs text-gray-600">Liste et historiques</p>
                        </div>
                        <i class="fas fa-chevron-right ml-auto text-gray-400 group-hover:text-purple-600 transition"></i>
                    </a>
                </div>
            </div>

            <!-- Consultations en attente -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-lg font-bold text-gray-900 flex items-center">
                        <i class="fas fa-hourglass-half text-yellow-500 mr-2"></i>
                        En Attente de Validation
                    </h2>
                    <c:if test="${not empty consultationsEnAttente}">
                        <span class="px-3 py-1 bg-yellow-100 text-yellow-800 rounded-full text-sm font-bold shadow-sm">
                                ${consultationsEnAttente.size()}
                        </span>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${not empty consultationsEnAttente}">
                        <div class="space-y-3 max-h-96 overflow-y-auto custom-scrollbar">
                            <c:forEach var="consultation" items="${consultationsEnAttente}" varStatus="status">
                                <c:if test="${status.index < 5}">
                                    <div class="p-4 bg-gradient-to-r from-yellow-50 to-amber-50 rounded-xl border border-yellow-200 hover:shadow-md transition-all">
                                        <div class="flex items-center justify-between mb-3">
                                            <div class="flex items-center">
                                                <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center mr-3 shadow-sm">
                                                    <i class="fas fa-user text-white"></i>
                                                </div>
                                                <div>
                                                    <span class="font-bold text-gray-900 block">
                                                        ${consultation.patient.prenom} ${consultation.patient.nom}
                                                    </span>
                                                    <p class="text-xs text-gray-600">
                                                        <i class="fas fa-calendar mr-1"></i>
                                                            ${consultation.dateCourte} à ${consultation.heure}
                                                    </p>
                                                </div>
                                            </div>
                                        </div>

                                        <p class="text-sm text-gray-700 mb-3 bg-white/60 p-2 rounded">
                                            <span class="font-semibold">Motif:</span> ${consultation.motifConsultation}
                                        </p>

                                        <div class="flex space-x-2">
                                            <form action="${pageContext.request.contextPath}/docteur/valider" method="post" class="flex-1">
                                                <input type="hidden" name="consultationId" value="${consultation.idConsultation}">
                                                <button type="submit"
                                                        class="w-full px-3 py-2 bg-green-600 text-white rounded-lg text-sm font-semibold hover:bg-green-700 transition-all shadow-md hover:shadow-lg transform hover:scale-105">
                                                    <i class="fas fa-check mr-1"></i> Valider
                                                </button>
                                            </form>
                                            <button onclick="refuserConsultation(${consultation.idConsultation})"
                                                    class="flex-1 px-3 py-2 bg-red-600 text-white rounded-lg text-sm font-semibold hover:bg-red-700 transition-all shadow-md hover:shadow-lg transform hover:scale-105">
                                                <i class="fas fa-times mr-1"></i> Refuser
                                            </button>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>

                        <c:if test="${consultationsEnAttente.size() > 5}">
                            <div class="text-center mt-4 pt-4 border-t border-gray-200">
                                <a href="${pageContext.request.contextPath}/docteur/consultations?statut=RESERVEE"
                                   class="text-yellow-600 hover:text-yellow-800 text-sm font-semibold inline-flex items-center">
                                    Voir toutes les ${consultationsEnAttente.size()} réservations
                                    <i class="fas fa-arrow-right ml-2"></i>
                                </a>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-8 bg-gray-50 rounded-xl border-2 border-dashed border-gray-300">
                            <i class="fas fa-check-circle text-gray-400 text-4xl mb-3"></i>
                            <p class="text-gray-600 font-medium">Aucune réservation en attente</p>
                            <p class="text-gray-500 text-sm mt-1">Tout est à jour ! 🎉</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

    </div>

</div>

<style>
    .custom-scrollbar::-webkit-scrollbar {
        width: 6px;
    }

    .custom-scrollbar::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 10px;
    }

    .custom-scrollbar::-webkit-scrollbar-thumb {
        background: #888;
        border-radius: 10px;
    }

    .custom-scrollbar::-webkit-scrollbar-thumb:hover {
        background: #555;
    }
</style>

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

    // Auto-hide messages après 5 secondes
    setTimeout(() => {
        const messages = document.querySelectorAll('.animate-slideIn');
        messages.forEach(msg => {
            msg.style.animation = 'slideOut 0.3s ease-in';
            setTimeout(() => msg.remove(), 300);
        });
    }, 5000);
</script>

</body>
</html>