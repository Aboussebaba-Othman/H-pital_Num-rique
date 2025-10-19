<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails Consultation - Clinique Privée</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .animate-slide-in {
            animation: slideIn 0.5s ease-out;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 via-blue-50 to-purple-50 min-h-screen">

<!-- Navigation -->
<jsp:include page="/WEB-INF/views/common/docteur-nav.jsp" />

<!-- Main Content -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header Section -->
    <div class="mb-8 animate-slide-in">
        <div class="bg-white rounded-2xl shadow-xl p-6 border border-gray-100">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div class="flex-1">
                    <div class="flex items-center gap-3 mb-3">
                        <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl flex items-center justify-center shadow-lg">
                            <i class="fas fa-file-medical text-white text-xl"></i>
                        </div>
                        <div>
                            <h1 class="text-3xl font-bold text-gray-900">Détails de la Consultation</h1>
                            <%
                                com.othman.clinique.model.Consultation cons = (com.othman.clinique.model.Consultation) request.getAttribute("consultation");
                                if (cons != null && cons.getDate() != null) {
                                    java.time.LocalDate consultationDate = cons.getDate();
                                    String dateFormatee = consultationDate.format(DateTimeFormatter.ofPattern("EEEE d MMMM yyyy", Locale.FRENCH));
                                    request.setAttribute("dateComplete", dateFormatee);
                                }
                            %>
                            <c:if test="${not empty dateComplete}">
                                <p class="text-gray-600 text-sm mt-1 capitalize">${dateComplete}</p>
                            </c:if>
                        </div>
                    </div>

                    <!-- Status Badge -->
                    <div class="inline-flex items-center">
                        <c:choose>
                            <c:when test="${consultation.statut == 'RESERVEE'}">
                                <span class="inline-flex items-center px-4 py-2 bg-gradient-to-r from-yellow-100 to-yellow-200 text-yellow-800 rounded-full text-sm font-bold shadow-md border-2 border-yellow-300">
                                    <span class="w-2 h-2 bg-yellow-600 rounded-full mr-2 animate-pulse"></span>
                                    <i class="fas fa-hourglass-half mr-2"></i>
                                    En Attente de Validation
                                </span>
                            </c:when>
                            <c:when test="${consultation.statut == 'VALIDEE'}">
                                <span class="inline-flex items-center px-4 py-2 bg-gradient-to-r from-blue-100 to-blue-200 text-blue-800 rounded-full text-sm font-bold shadow-md border-2 border-blue-300">
                                    <span class="w-2 h-2 bg-blue-600 rounded-full mr-2 animate-pulse"></span>
                                    <i class="fas fa-check-circle mr-2"></i>
                                    Validée - À Réaliser
                                </span>
                            </c:when>
                            <c:when test="${consultation.statut == 'TERMINEE'}">
                                <span class="inline-flex items-center px-4 py-2 bg-gradient-to-r from-green-100 to-green-200 text-green-800 rounded-full text-sm font-bold shadow-md border-2 border-green-300">
                                    <i class="fas fa-check-double mr-2"></i>
                                    Consultation Terminée
                                </span>
                            </c:when>
                            <c:when test="${consultation.statut == 'ANNULEE'}">
                                <span class="inline-flex items-center px-4 py-2 bg-gradient-to-r from-red-100 to-red-200 text-red-800 rounded-full text-sm font-bold shadow-md border-2 border-red-300">
                                    <i class="fas fa-times-circle mr-2"></i>
                                    Annulée
                                </span>
                            </c:when>
                        </c:choose>
                    </div>
                </div>

                <div class="flex gap-3">
                    <a href="${pageContext.request.contextPath}/docteur/dashboard"
                       class="px-6 py-3 bg-gradient-to-r from-gray-600 to-gray-700 text-white rounded-xl hover:from-gray-700 hover:to-gray-800 transition shadow-lg hover:shadow-xl transform hover:scale-105 inline-flex items-center font-semibold">
                        <i class="fas fa-arrow-left mr-2"></i>
                        Retour
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <!-- Main Content - Left Side -->
        <div class="lg:col-span-2 space-y-6">

            <!-- Patient Information Card -->
            <div class="gradient-border shadow-xl animate-slide-in" style="animation-delay: 0.1s">
                <div class="bg-white rounded-2xl p-6 relative z-10">
                    <div class="flex items-center justify-between mb-6 pb-4 border-b-2 border-gray-100">
                        <h2 class="text-2xl font-bold text-gray-900 flex items-center">
                            <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center mr-3 shadow-md">
                                <i class="fas fa-user text-white"></i>
                            </div>
                            Informations Patient
                        </h2>
                        <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-2xl shadow-lg">
                            <c:if test="${not empty consultation and not empty consultation.patient}">
                                ${consultation.patient.prenom.substring(0,1)}${consultation.patient.nom.substring(0,1)}
                            </c:if>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="group bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-4 hover:shadow-lg transition-all duration-300 border-l-4 border-blue-500">
                            <div class="flex items-center">
                                <div class="w-12 h-12 bg-blue-500 rounded-lg flex items-center justify-center mr-4 shadow-md group-hover:scale-110 transition-transform">
                                    <i class="fas fa-id-card text-white text-xl"></i>
                                </div>
                                <div>
                                    <p class="text-xs text-blue-700 font-semibold mb-1 uppercase">Nom Complet</p>
                                    <p class="font-bold text-gray-900 text-lg">
                                        <c:if test="${not empty consultation and not empty consultation.patient}">
                                            ${consultation.patient.prenom} ${consultation.patient.nom}
                                        </c:if>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="group bg-gradient-to-br from-purple-50 to-purple-100 rounded-xl p-4 hover:shadow-lg transition-all duration-300 border-l-4 border-purple-500">
                            <div class="flex items-center">
                                <div class="w-12 h-12 bg-purple-500 rounded-lg flex items-center justify-center mr-4 shadow-md group-hover:scale-110 transition-transform">
                                    <i class="fas fa-envelope text-white text-xl"></i>
                                </div>
                                <div class="flex-1 min-w-0">
                                    <p class="text-xs text-purple-700 font-semibold mb-1 uppercase">Email</p>
                                    <p class="font-semibold text-gray-900 truncate">
                                        <c:if test="${not empty consultation and not empty consultation.patient}">
                                            ${consultation.patient.email}
                                        </c:if>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <c:if test="${not empty consultation and not empty consultation.patient and consultation.patient.poids != null}">
                            <div class="group bg-gradient-to-br from-green-50 to-green-100 rounded-xl p-4 hover:shadow-lg transition-all duration-300 border-l-4 border-green-500">
                                <div class="flex items-center">
                                    <div class="w-12 h-12 bg-green-500 rounded-lg flex items-center justify-center mr-4 shadow-md group-hover:scale-110 transition-transform">
                                        <i class="fas fa-weight text-white text-xl"></i>
                                    </div>
                                    <div>
                                        <p class="text-xs text-green-700 font-semibold mb-1 uppercase">Poids</p>
                                        <p class="font-bold text-gray-900 text-lg">
                                            <c:if test="${not empty consultation.patient.poids}">
                                                ${consultation.patient.poids} kg
                                            </c:if>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty consultation and not empty consultation.patient and consultation.patient.taille != null}">
                            <div class="group bg-gradient-to-br from-indigo-50 to-indigo-100 rounded-xl p-4 hover:shadow-lg transition-all duration-300 border-l-4 border-indigo-500">
                                <div class="flex items-center">
                                    <div class="w-12 h-12 bg-indigo-500 rounded-lg flex items-center justify-center mr-4 shadow-md group-hover:scale-110 transition-transform">
                                        <i class="fas fa-ruler-vertical text-white text-xl"></i>
                                    </div>
                                    <div>
                                        <p class="text-xs text-indigo-700 font-semibold mb-1 uppercase">Taille</p>
                                        <p class="font-bold text-gray-900 text-lg">
                                            <c:if test="${not empty consultation.patient.taille}">
                                                ${consultation.patient.taille} m
                                            </c:if>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Consultation Details Card -->
            <div class="bg-white rounded-2xl shadow-xl p-6 border border-gray-100 animate-slide-in" style="animation-delay: 0.2s">
                <h2 class="text-2xl font-bold text-gray-900 mb-6 flex items-center pb-4 border-b-2 border-gray-100">
                    <div class="w-10 h-10 bg-gradient-to-br from-green-500 to-green-600 rounded-lg flex items-center justify-center mr-3 shadow-md">
                        <i class="fas fa-calendar-check text-white"></i>
                    </div>
                    Détails de la Consultation
                </h2>

                <div class="space-y-4">
                    <div class="group flex items-start p-5 bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl border-l-4 border-green-500 hover:shadow-lg transition-all duration-300">
                        <div class="w-12 h-12 bg-green-500 rounded-lg flex items-center justify-center mr-4 shadow-md group-hover:scale-110 transition-transform">
                            <i class="fas fa-calendar text-white text-xl"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-semibold text-green-700 mb-1 uppercase">Date de Consultation</p>
                            <c:choose>
                                <c:when test="${not empty dateComplete}">
                                    <p class="font-bold text-gray-900 text-xl capitalize">${dateComplete}</p>
                                </c:when>
                                <c:otherwise>
                                    <%
                                        com.othman.clinique.model.Consultation c = (com.othman.clinique.model.Consultation) request.getAttribute("consultation");
                                        if (c != null && c.getDate() != null) {
                                            String simpleDate = c.getDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                                            request.setAttribute("simpleDate", simpleDate);
                                        }
                                    %>
                                    <p class="font-bold text-gray-900 text-xl">${simpleDate}</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="group flex items-start p-5 bg-gradient-to-r from-blue-50 to-cyan-50 rounded-xl border-l-4 border-blue-500 hover:shadow-lg transition-all duration-300">
                        <div class="w-12 h-12 bg-blue-500 rounded-lg flex items-center justify-center mr-4 shadow-md group-hover:scale-110 transition-transform">
                            <i class="fas fa-clock text-white text-xl"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-semibold text-blue-700 mb-1 uppercase">Heure</p>
                            <p class="font-bold text-gray-900 text-xl">
                                <c:if test="${not empty consultation and not empty consultation.heure}">
                                    ${consultation.heure}
                                </c:if>
                            </p>
                        </div>
                    </div>

                    <div class="group flex items-start p-5 bg-gradient-to-r from-purple-50 to-violet-50 rounded-xl border-l-4 border-purple-500 hover:shadow-lg transition-all duration-300">
                        <div class="w-12 h-12 bg-purple-500 rounded-lg flex items-center justify-center mr-4 shadow-md group-hover:scale-110 transition-transform">
                            <i class="fas fa-door-open text-white text-xl"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-semibold text-purple-700 mb-1 uppercase">Salle</p>
                            <p class="font-bold text-gray-900 text-xl">
                                <c:if test="${not empty consultation and not empty consultation.salle}">
                                    ${consultation.salle.nomSalle}
                                </c:if>
                            </p>
                        </div>
                    </div>

                    <div class="p-5 bg-gradient-to-r from-yellow-50 to-amber-50 rounded-xl border-l-4 border-yellow-500 hover:shadow-lg transition-all duration-300">
                        <div class="flex items-start mb-3">
                            <div class="w-12 h-12 bg-yellow-500 rounded-lg flex items-center justify-center mr-4 shadow-md">
                                <i class="fas fa-notes-medical text-white text-xl"></i>
                            </div>
                            <p class="text-sm font-bold text-yellow-700 uppercase pt-3">Motif de la Consultation</p>
                        </div>
                        <p class="text-gray-800 text-base leading-relaxed pl-16">
                            <c:if test="${not empty consultation and not empty consultation.motifConsultation}">
                                ${consultation.motifConsultation}
                            </c:if>
                        </p>
                    </div>

                    <c:if test="${not empty consultation and consultation.statut == 'TERMINEE' and not empty consultation.compteRendu}">
                        <div class="p-5 bg-gradient-to-r from-gray-50 to-slate-50 rounded-xl border-l-4 border-gray-500 hover:shadow-lg transition-all duration-300">
                            <div class="flex items-start mb-3">
                                <div class="w-12 h-12 bg-gray-500 rounded-lg flex items-center justify-center mr-4 shadow-md">
                                    <i class="fas fa-file-medical text-white text-xl"></i>
                                </div>
                                <p class="text-sm font-bold text-gray-700 uppercase pt-3">Compte Rendu Médical</p>
                            </div>
                            <div class="pl-16 bg-white rounded-lg p-4 border border-gray-200">
                                <p class="text-gray-800 whitespace-pre-wrap leading-relaxed">${consultation.compteRendu}</p>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

        </div>

        <!-- Actions Sidebar - Right Side -->
        <div class="lg:col-span-1 space-y-6">

            <!-- Quick Actions Card -->
            <div class="bg-white rounded-2xl shadow-xl p-6 border border-gray-100 sticky top-8 animate-slide-in" style="animation-delay: 0.3s">
                <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center pb-4 border-b-2 border-gray-100">
                    <div class="w-10 h-10 bg-gradient-to-br from-purple-500 to-purple-600 rounded-lg flex items-center justify-center mr-3 shadow-md">
                        <i class="fas fa-tasks text-white"></i>
                    </div>
                    Actions Rapides
                </h2>

                <div class="space-y-3">

                    <!-- Actions selon le statut -->
                    <c:if test="${not empty consultation and consultation.statut == 'RESERVEE'}">
                        <form action="${pageContext.request.contextPath}/docteur/valider" method="post">
                            <input type="hidden" name="consultationId" value="${consultation.idConsultation}">
                            <button type="submit"
                                    class="w-full px-6 py-4 bg-gradient-to-r from-green-500 to-green-600 text-white rounded-xl hover:from-green-600 hover:to-green-700 transition shadow-lg hover:shadow-xl transform hover:scale-105 flex items-center justify-center font-bold text-lg group">
                                <i class="fas fa-check-circle mr-3 text-xl group-hover:scale-110 transition-transform"></i>
                                Valider la Consultation
                            </button>
                        </form>

                        <button onclick="refuserConsultation(${consultation.idConsultation})"
                                class="w-full px-6 py-4 bg-gradient-to-r from-red-500 to-red-600 text-white rounded-xl hover:from-red-600 hover:to-red-700 transition shadow-lg hover:shadow-xl transform hover:scale-105 flex items-center justify-center font-bold text-lg group">
                            <i class="fas fa-times-circle mr-3 text-xl group-hover:scale-110 transition-transform"></i>
                            Refuser
                        </button>
                    </c:if>

                    <c:if test="${not empty consultation and consultation.statut == 'VALIDEE'}">
                        <a href="${pageContext.request.contextPath}/docteur/compte-rendu?id=${consultation.idConsultation}"
                           class="block w-full px-6 py-4 bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-xl hover:from-blue-600 hover:to-blue-700 transition shadow-lg hover:shadow-xl transform hover:scale-105 text-center font-bold text-lg group">
                            <i class="fas fa-file-medical mr-3 text-xl group-hover:scale-110 transition-transform"></i>
                            Terminer & Rédiger CR
                        </a>
                    </c:if>

                    <!-- Navigation Actions -->
                    <a href="${pageContext.request.contextPath}/docteur/patients"
                       class="block w-full px-6 py-3 bg-gradient-to-r from-purple-500 to-purple-600 text-white rounded-xl hover:from-purple-600 hover:to-purple-700 transition shadow-md hover:shadow-lg text-center font-semibold">
                        <i class="fas fa-users mr-2"></i>
                        Voir tous les Patients
                    </a>

                    <a href="${pageContext.request.contextPath}/docteur/consultations"
                       class="block w-full px-6 py-3 bg-gradient-to-r from-indigo-500 to-indigo-600 text-white rounded-xl hover:from-indigo-600 hover:to-indigo-700 transition shadow-md hover:shadow-lg text-center font-semibold">
                        <i class="fas fa-list mr-2"></i>
                        Toutes les Consultations
                    </a>

                    <a href="${pageContext.request.contextPath}/docteur/dashboard"
                       class="block w-full px-6 py-3 bg-gradient-to-r from-gray-600 to-gray-700 text-white rounded-xl hover:from-gray-700 hover:to-gray-800 transition shadow-md hover:shadow-lg text-center font-semibold">
                        <i class="fas fa-home mr-2"></i>
                        Retour au Dashboard
                    </a>
                </div>
            </div>

            <!-- Information Card -->
            <div class="bg-gradient-to-br from-blue-50 to-indigo-100 rounded-2xl shadow-lg p-6 border-2 border-blue-200 animate-slide-in" style="animation-delay: 0.4s">
                <div class="flex items-start">
                    <div class="w-12 h-12 bg-blue-500 rounded-lg flex items-center justify-center mr-4 shadow-md flex-shrink-0">
                        <i class="fas fa-info-circle text-white text-2xl"></i>
                    </div>
                    <div>
                        <h3 class="font-bold text-gray-900 mb-2 text-lg">Information</h3>
                        <p class="text-sm text-gray-700 leading-relaxed">
                            <c:choose>
                                <c:when test="${consultation.statut == 'RESERVEE'}">
                                    Cette consultation est en attente de validation. Vous pouvez l'accepter ou la refuser.
                                </c:when>
                                <c:when test="${consultation.statut == 'VALIDEE'}">
                                    Cette consultation est validée. Vous pouvez maintenant la réaliser et rédiger le compte rendu.
                                </c:when>
                                <c:when test="${consultation.statut == 'TERMINEE'}">
                                    Cette consultation est terminée. Le compte rendu a été enregistré.
                                </c:when>
                                <c:otherwise>
                                    Consultez les détails de cette consultation ci-contre.
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </div>

        </div>

    </div>

</div>

<script>
    function refuserConsultation(consultationId) {
        const result = confirm("Êtes-vous sûr de vouloir refuser cette consultation ?");

        if (result) {
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
    }
</script>

</body>
</html>