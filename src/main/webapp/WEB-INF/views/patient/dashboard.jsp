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
    <style>
        /* small helper */
        .stat-card:hover { transform: translateY(-6px); }
    </style>
</head>
<body>

<!-- Définir la page active pour la sidebar -->
<c:set var="pageParam" value="dashboard" scope="request"/>

<!-- Inclure la sidebar patient -->
<%@ include file="../common/patient-nav.jsp" %>

<!-- Contenu principal adapté Tailwind -->
<div class="max-w-7xl mx-auto">

    <!-- Header -->
    <div class="mb-8">
        <div class="bg-gradient-to-r from-blue-600 to-indigo-600 text-white rounded-xl p-6 shadow-lg">
            <h1 class="text-3xl font-bold">Bonjour, ${patient.prenom} ${patient.nom}!</h1>
            <p class="text-blue-100">Bienvenue sur votre espace patient</p>
        </div>
    </div>

    <!-- Statistiques principales -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <div class="bg-white rounded-xl shadow p-6">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <p class="text-sm text-gray-500 mb-1">Total Consultations</p>
                    <p class="text-3xl font-bold">${totalConsultations}</p>
                </div>
                <div class="w-16 h-16 bg-blue-50 rounded-full flex items-center justify-center">
                    <i class="fas fa-calendar-alt text-blue-600 text-2xl"></i>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/patient/consultations" class="text-sm text-blue-600 hover:underline">Voir mes consultations</a>
        </div>

        <div class="bg-white rounded-xl shadow p-6">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <p class="text-sm text-gray-500 mb-1">En Attente</p>
                    <p class="text-3xl font-bold">${consultationsEnAttente.size()}</p>
                </div>
                <div class="w-16 h-16 bg-yellow-50 rounded-full flex items-center justify-center">
                    <i class="fas fa-clock text-yellow-500 text-2xl"></i>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/patient/consultations" class="text-sm text-yellow-600 hover:underline">Gérer</a>
        </div>

        <div class="bg-white rounded-xl shadow p-6">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <p class="text-sm text-gray-500 mb-1">Terminées</p>
                    <p class="text-3xl font-bold">${nombreConsultationsTerminees}</p>
                </div>
                <div class="w-16 h-16 bg-green-50 rounded-full flex items-center justify-center">
                    <i class="fas fa-check-circle text-green-600 text-2xl"></i>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/patient/historique" class="text-sm text-green-600 hover:underline">Voir l'historique</a>
        </div>

        <div class="bg-white rounded-xl shadow p-6">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <p class="text-sm text-gray-500 mb-1">IMC</p>
                    <p class="text-3xl font-bold">
                        <c:choose>
                            <c:when test="${not empty patient.poids && not empty patient.taille}">
                                <fmt:formatNumber value="${patient.poids / ((patient.taille / 100) * (patient.taille / 100))}" maxFractionDigits="1"/>
                            </c:when>
                            <c:otherwise>--</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="w-16 h-16 bg-cyan-50 rounded-full flex items-center justify-center">
                    <i class="fas fa-heartbeat text-cyan-500 text-2xl"></i>
                </div>
            </div>
            <p class="text-sm text-gray-500">Indice de masse corporelle</p>
        </div>
    </div>

    <!-- Prochaine consultation -->
    <c:if test="${not empty prochaineConsultation}">
        <div class="bg-white rounded-xl shadow p-6 mb-8">
            <h2 class="text-xl font-bold text-gray-900 mb-4"><i class="fas fa-calendar-star text-indigo-600 mr-2"></i> Prochaine consultation</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 items-center">
                <div>
                    <p class="text-lg font-semibold">
                        <fmt:formatDate value="${prochaineConsultation.date}" pattern="EEEE dd MMMM yyyy"/> à <fmt:formatDate value="${prochaineConsultation.heure}" pattern="HH:mm"/>
                    </p>
                    <p class="text-sm text-gray-600">Dr. ${prochaineConsultation.docteur.prenom} ${prochaineConsultation.docteur.nom} — ${prochaineConsultation.docteur.specialite}</p>
                    <p class="text-sm mt-2">${prochaineConsultation.motifConsultation}</p>
                </div>
                <div class="md:col-span-2 text-right">
                    <span class="inline-block px-4 py-2 rounded-full text-sm font-medium ${prochaineConsultation.statut == 'VALIDEE' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'}">
                        ${prochaineConsultation.statut == 'VALIDEE' ? 'Confirmée' : 'En attente'}
                    </span>
                </div>
            </div>
        </div>
    </c:if>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Consultations à venir -->
        <div class="bg-white rounded-xl shadow p-6">
            <h3 class="text-lg font-bold mb-4"><i class="fas fa-calendar-alt text-indigo-600 mr-2"></i> Consultations à venir</h3>
            <c:choose>
                <c:when test="${empty consultationsAvenir}">
                    <div class="text-center py-8 text-gray-500">
                        <i class="fas fa-calendar-times text-3xl mb-3"></i>
                        <p>Aucune consultation programmée</p>
                        <a href="${pageContext.request.contextPath}/patient/reserver" class="inline-block mt-4 px-4 py-2 bg-indigo-600 text-white rounded-lg">Réserver une consultation</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="space-y-3">
                        <c:forEach items="${consultationsAvenir}" var="consultation" varStatus="status">
                            <c:if test="${status.index < 5}">
                                <div class="flex items-center justify-between p-4 border rounded-lg">
                                    <div>
                                        <div class="font-semibold"><fmt:formatDate value="${consultation.date}" pattern="dd/MM/yyyy"/> — <fmt:formatDate value="${consultation.heure}" pattern="HH:mm"/></div>
                                        <div class="text-sm text-gray-600">Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom} · ${consultation.docteur.specialite}</div>
                                    </div>
                                    <div>
                                        <span class="px-3 py-1 rounded-full text-sm ${consultation.statut == 'VALIDEE' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'}">${consultation.statut == 'VALIDEE' ? 'Validée' : 'Réservée'}</span>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/patient/consultations" class="text-indigo-600 hover:underline">Voir toutes les consultations →</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Actions rapides -->
        <div class="bg-white rounded-xl shadow p-6">
            <h3 class="text-lg font-bold mb-4"><i class="fas fa-rocket text-green-600 mr-2"></i> Actions rapides</h3>
            <div class="grid grid-cols-1 gap-3">
                <a href="${pageContext.request.contextPath}/patient/reserver" class="px-4 py-3 bg-indigo-600 text-white rounded-lg flex items-center">
                    <i class="fas fa-calendar-plus mr-3"></i> Réserver une consultation
                </a>
                <a href="${pageContext.request.contextPath}/patient/docteurs" class="px-4 py-3 bg-sky-100 text-sky-800 rounded-lg flex items-center">
                    <i class="fas fa-user-md mr-3"></i> Trouver un docteur
                </a>
                <a href="${pageContext.request.contextPath}/patient/consultations" class="px-4 py-3 bg-amber-50 text-amber-800 rounded-lg flex items-center">
                    <i class="fas fa-list mr-3"></i> Mes consultations
                </a>
                <a href="${pageContext.request.contextPath}/patient/historique" class="px-4 py-3 bg-gray-100 text-gray-800 rounded-lg flex items-center">
                    <i class="fas fa-history mr-3"></i> Historique médical
                </a>
            </div>
        </div>
    </div>

    <!-- Informations patient -->
    <div class="bg-white rounded-xl shadow p-6 mt-6">
        <h3 class="text-lg font-bold mb-4"><i class="fas fa-user-circle text-gray-700 mr-2"></i> Mes informations</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
                <p class="text-sm text-gray-600"><strong>Email:</strong> ${patient.email}</p>
                <p class="text-sm text-gray-600"><strong>Poids:</strong>
                    <c:choose>
                        <c:when test="${not empty patient.poids}">
                            <fmt:formatNumber value="${patient.poids}" maxFractionDigits="1"/> kg
                        </c:when>
                        <c:otherwise>Non renseigné</c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div>
                <p class="text-sm text-gray-600"><strong>ID Patient:</strong> #${patient.idPatient}</p>
                <p class="text-sm text-gray-600"><strong>Taille:</strong>
                    <c:choose>
                        <c:when test="${not empty patient.taille}">
                            <fmt:formatNumber value="${patient.taille}" maxFractionDigits="0"/> cm
                        </c:when>
                        <c:otherwise>Non renseignée</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>
    </div>

</div>

</main>
</div>

</body>
</html>