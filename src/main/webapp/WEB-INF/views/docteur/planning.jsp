<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Planning - Dr. ${docteur.nom}</title>
    <!-- Using Tailwind CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen font-sans">

<!-- Navigation -->
<jsp:include page="/WEB-INF/views/common/docteur-nav.jsp" />

<div class="max-w-7xl mx-auto px-4 py-6">
    <!-- Statistics Cards -->
    <!-- Replaced custom CSS with Tailwind grid layout -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6 mb-8">
        <!-- Total Card -->
        <div class="bg-white rounded-lg shadow-md hover:shadow-lg hover:-translate-y-1 transition-all p-6 border-l-4 border-gray-500">
            <div class="text-4xl text-gray-500 mb-3">
                <i class="bi bi-calendar-check"></i>
            </div>
            <div class="text-3xl font-bold text-gray-800">${totalConsultations}</div>
            <div class="text-sm text-gray-600 uppercase tracking-wide">Total Consultations</div>
        </div>

        <!-- Réservées Card -->
        <div class="bg-white rounded-lg shadow-md hover:shadow-lg hover:-translate-y-1 transition-all p-6 border-l-4 border-yellow-400">
            <div class="text-4xl text-yellow-400 mb-3">
                <i class="bi bi-clock-history"></i>
            </div>
            <div class="text-3xl font-bold text-gray-800">${reservees}</div>
            <div class="text-sm text-gray-600 uppercase tracking-wide">Réservées</div>
        </div>

        <!-- Validées Card -->
        <div class="bg-white rounded-lg shadow-md hover:shadow-lg hover:-translate-y-1 transition-all p-6 border-l-4 border-blue-500">
            <div class="text-4xl text-blue-500 mb-3">
                <i class="bi bi-check-circle"></i>
            </div>
            <div class="text-3xl font-bold text-gray-800">${validees}</div>
            <div class="text-sm text-gray-600 uppercase tracking-wide">Validées</div>
        </div>

        <!-- Terminées Card -->
        <div class="bg-white rounded-lg shadow-md hover:shadow-lg hover:-translate-y-1 transition-all p-6 border-l-4 border-green-500">
            <div class="text-4xl text-green-500 mb-3">
                <i class="bi bi-check2-all"></i>
            </div>
            <div class="text-3xl font-bold text-gray-800">${terminees}</div>
            <div class="text-sm text-gray-600 uppercase tracking-wide">Terminées</div>
        </div>

        <!-- Annulées Card -->
        <div class="bg-white rounded-lg shadow-md hover:shadow-lg hover:-translate-y-1 transition-all p-6 border-l-4 border-red-500">
            <div class="text-4xl text-red-500 mb-3">
                <i class="bi bi-x-circle"></i>
            </div>
            <div class="text-3xl font-bold text-gray-800">${annulees}</div>
            <div class="text-sm text-gray-600 uppercase tracking-wide">Annulées</div>
        </div>
    </div>

    <!-- Calendar -->
    <!-- Replaced custom CSS with Tailwind classes for calendar container -->
    <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
        <!-- Calendar Header -->
        <div class="bg-gradient-to-r from-purple-500 to-purple-700 rounded-lg p-6 mb-8 flex flex-col md:flex-row justify-between items-center gap-4 text-white">
            <h2 class="text-2xl font-bold">
                <i class="bi bi-calendar3"></i>
                ${monthName}
            </h2>
            <!-- Navigation buttons with Tailwind styling -->
            <div class="flex gap-3 flex-wrap justify-center md:justify-end">
                <a href="?month=${moisPrecedent}&year=${anneePrecedente}" class="bg-white bg-opacity-20 hover:bg-opacity-30 border border-white border-opacity-30 text-white px-4 py-2 rounded transition-all hover:-translate-y-0.5">
                    <i class="bi bi-chevron-left"></i> Précédent
                </a>
                <a href="?" class="bg-white bg-opacity-20 hover:bg-opacity-30 border border-white border-opacity-30 text-white px-4 py-2 rounded transition-all hover:-translate-y-0.5">
                    <i class="bi bi-calendar-today"></i> Aujourd'hui
                </a>
                <a href="?month=${moisSuivant}&year=${anneeSuivante}" class="bg-white bg-opacity-20 hover:bg-opacity-30 border border-white border-opacity-30 text-white px-4 py-2 rounded transition-all hover:-translate-y-0.5">
                    Suivant <i class="bi bi-chevron-right"></i>
                </a>
            </div>
        </div>

        <!-- Legend -->
        <!-- Legend with Tailwind flex layout -->
        <div class="flex flex-wrap justify-center gap-6 mb-6 p-4 bg-gray-50 rounded-lg">
            <div class="flex items-center gap-2">
                <div class="w-5 h-5 bg-yellow-100 border-l-4 border-yellow-400 rounded"></div>
                <span class="text-gray-700 text-sm">Réservée</span>
            </div>
            <div class="flex items-center gap-2">
                <div class="w-5 h-5 bg-blue-100 border-l-4 border-blue-500 rounded"></div>
                <span class="text-gray-700 text-sm">Validée</span>
            </div>
            <div class="flex items-center gap-2">
                <div class="w-5 h-5 bg-green-100 border-l-4 border-green-500 rounded"></div>
                <span class="text-gray-700 text-sm">Terminée</span>
            </div>
            <div class="flex items-center gap-2">
                <div class="w-5 h-5 bg-red-100 border-l-4 border-red-500 rounded"></div>
                <span class="text-gray-700 text-sm">Annulée</span>
            </div>
        </div>

        <!-- Calendar Grid -->
        <!-- Calendar grid with Tailwind CSS Grid -->
        <div class="grid grid-cols-7 gap-2 md:gap-3">
            <!-- Day Headers -->
            <div class="text-center font-bold p-3 bg-gray-100 rounded text-gray-700 text-sm md:text-base">Lun</div>
            <div class="text-center font-bold p-3 bg-gray-100 rounded text-gray-700 text-sm md:text-base">Mar</div>
            <div class="text-center font-bold p-3 bg-gray-100 rounded text-gray-700 text-sm md:text-base">Mer</div>
            <div class="text-center font-bold p-3 bg-gray-100 rounded text-gray-700 text-sm md:text-base">Jeu</div>
            <div class="text-center font-bold p-3 bg-gray-100 rounded text-gray-700 text-sm md:text-base">Ven</div>
            <div class="text-center font-bold p-3 bg-gray-100 rounded text-gray-700 text-sm md:text-base">Sam</div>
            <div class="text-center font-bold p-3 bg-gray-100 rounded text-gray-700 text-sm md:text-base">Dim</div>

            <!-- Empty cells before first day -->
            <c:forEach begin="1" end="${premierJourSemaine - 1}">
                <div class="bg-gray-50 rounded border border-transparent"></div>
            </c:forEach>

            <!-- Calendar days -->
            <c:forEach var="day" begin="1" end="${nombreDeJours}">
                <jsp:useBean id="yearMonth" scope="request" type="java.time.YearMonth"/>
                <jsp:useBean id="currentDate" scope="request" type="java.time.LocalDate"/>
                <c:set var="date" value="${yearMonth.atDay(day)}"/>
                <c:set var="isToday" value="${date.equals(currentDate)}"/>

                <!-- Calendar day cell with conditional Tailwind classes for today -->
                <div class="min-h-24 md:min-h-32 p-2 md:p-3 border-2 rounded-lg bg-white transition-all hover:border-blue-500 hover:shadow-md hover:-translate-y-0.5 <c:if test="${isToday}">border-blue-500 bg-blue-50</c:if><c:if test="${!isToday}">border-gray-200</c:if>">
                    <div class="font-bold text-base md:text-lg mb-1 <c:if test="${isToday}">text-blue-600</c:if><c:if test="${!isToday}">text-gray-700</c:if>">${day}</div>

                    <c:set var="consultations" value="${consultationsParDate[date]}"/>
                    <c:if test="${not empty consultations}">
                        <c:forEach var="consultation" items="${consultations}">
                            <!-- Consultation badges with Tailwind status colors -->
                            <c:choose>
                                <c:when test="${consultation.statut.toString().toLowerCase() == 'reservee'}">
                                    <div class="text-xs bg-yellow-100 text-yellow-800 border-l-2 border-yellow-400 p-1 mb-1 rounded cursor-pointer hover:scale-105 transition-transform"
                                         title="${consultation.patient.nom} ${consultation.patient.prenom} - ${consultation.heure}"
                                         onclick="showConsultationDetails('${consultation.idConsultation}')">
                                        <i class="bi bi-clock"></i> ${consultation.heure}
                                        <br><small>${consultation.patient.nom}</small>
                                    </div>
                                </c:when>
                                <c:when test="${consultation.statut.toString().toLowerCase() == 'validee'}">
                                    <div class="text-xs bg-blue-100 text-blue-800 border-l-2 border-blue-500 p-1 mb-1 rounded cursor-pointer hover:scale-105 transition-transform"
                                         title="${consultation.patient.nom} ${consultation.patient.prenom} - ${consultation.heure}"
                                         onclick="showConsultationDetails('${consultation.idConsultation}')">
                                        <i class="bi bi-clock"></i> ${consultation.heure}
                                        <br><small>${consultation.patient.nom}</small>
                                    </div>
                                </c:when>
                                <c:when test="${consultation.statut.toString().toLowerCase() == 'terminee'}">
                                    <div class="text-xs bg-green-100 text-green-800 border-l-2 border-green-500 p-1 mb-1 rounded cursor-pointer hover:scale-105 transition-transform"
                                         title="${consultation.patient.nom} ${consultation.patient.prenom} - ${consultation.heure}"
                                         onclick="showConsultationDetails('${consultation.idConsultation}')">
                                        <i class="bi bi-clock"></i> ${consultation.heure}
                                        <br><small>${consultation.patient.nom}</small>
                                    </div>
                                </c:when>
                                <c:when test="${consultation.statut.toString().toLowerCase() == 'annulee'}">
                                    <div class="text-xs bg-red-100 text-red-800 border-l-2 border-red-500 p-1 mb-1 rounded cursor-pointer hover:scale-105 transition-transform"
                                         title="${consultation.patient.nom} ${consultation.patient.prenom} - ${consultation.heure}"
                                         onclick="showConsultationDetails('${consultation.idConsultation}')">
                                        <i class="bi bi-clock"></i> ${consultation.heure}
                                        <br><small>${consultation.patient.nom}</small>
                                    </div>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Consultations List -->
    <!-- List container with Tailwind styling -->
    <div class="bg-white rounded-lg shadow-lg p-6">
        <h3 class="text-xl font-bold mb-6 text-gray-800">
            <i class="bi bi-list-ul"></i>
            Liste des consultations du mois
        </h3>

        <c:choose>
            <c:when test="${empty consultationsDuMois}">
                <div class="bg-blue-50 border border-blue-200 text-blue-800 p-4 rounded-lg">
                    <i class="bi bi-info-circle"></i>
                    Aucune consultation prévue pour ce mois.
                </div>
            </c:when>
            <c:otherwise>
                <!-- Table with Tailwind responsive styling -->
                <div class="overflow-x-auto">
                    <table class="w-full text-sm">
                        <thead>
                        <tr class="border-b-2 border-gray-200 bg-gray-50">
                            <th class="text-left p-3 font-bold text-gray-700">Date</th>
                            <th class="text-left p-3 font-bold text-gray-700">Heure</th>
                            <th class="text-left p-3 font-bold text-gray-700">Patient</th>
                            <th class="text-left p-3 font-bold text-gray-700">Statut</th>
                            <th class="text-left p-3 font-bold text-gray-700">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="consultation" items="${consultationsDuMois}">
                            <tr class="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                                <td class="p-3">
                                    <i class="bi bi-calendar-event"></i>
                                        ${consultation.date.dayOfMonth}/${consultation.date.monthValue}/${consultation.date.year}
                                </td>
                                <td class="p-3">
                                    <i class="bi bi-clock"></i>
                                        ${consultation.heure}
                                </td>
                                <td class="p-3">
                                    <strong class="text-gray-800">${consultation.patient.nom} ${consultation.patient.prenom}</strong>
                                </td>
                                <td class="p-3">
                                    <c:choose>
                                        <c:when test="${consultation.statut == 'RESERVEE'}">
                                            <span class="inline-block bg-yellow-100 text-yellow-800 px-3 py-1 rounded-full text-xs font-semibold">
                                                <i class="bi bi-clock-history"></i> Réservée
                                            </span>
                                        </c:when>
                                        <c:when test="${consultation.statut == 'VALIDEE'}">
                                            <span class="inline-block bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-xs font-semibold">
                                                <i class="bi bi-check-circle"></i> Validée
                                            </span>
                                        </c:when>
                                        <c:when test="${consultation.statut == 'TERMINEE'}">
                                            <span class="inline-block bg-green-100 text-green-800 px-3 py-1 rounded-full text-xs font-semibold">
                                                <i class="bi bi-check2-all"></i> Terminée
                                            </span>
                                        </c:when>
                                        <c:when test="${consultation.statut == 'ANNULEE'}">
                                            <span class="inline-block bg-red-100 text-red-800 px-3 py-1 rounded-full text-xs font-semibold">
                                                <i class="bi bi-x-circle"></i> Annulée
                                            </span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td class="p-3">
                                    <a href="${pageContext.request.contextPath}/docteur/consultation?id=${consultation.idConsultation}"
                                       class="inline-block bg-blue-500 hover:bg-blue-600 text-white px-3 py-1 rounded text-xs font-semibold transition-colors">
                                        <i class="bi bi-eye"></i> Détails
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Vanilla JavaScript for consultation details navigation -->
<script>
    function showConsultationDetails(consultationId) {
        window.location.href = '${pageContext.request.contextPath}/docteur/consultation?id=' + consultationId;
    }
</script>
</body>
</html>
