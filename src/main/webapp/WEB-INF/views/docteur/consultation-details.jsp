<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails Consultation - Clinique Privée</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen">

<!-- Navigation -->
<jsp:include page="/WEB-INF/views/common/docteur-nav.jsp" />

<!-- Main Content -->
<div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header -->
    <div class="mb-6 flex items-center justify-between">
        <div>
            <h1 class="text-3xl font-bold text-gray-900 mb-2">Détails de la Consultation</h1>
            <p class="text-gray-600">Consultation du ${consultation.dateFormatee}</p>
        </div>
        <a href="${pageContext.request.contextPath}/docteur/dashboard"
           class="px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition inline-flex items-center">
            <i class="fas fa-arrow-left mr-2"></i>
            Retour
        </a>
    </div>

    <!-- Statut Badge -->
    <div class="mb-6">
        <c:choose>
            <c:when test="${consultation.statut == 'RESERVEE'}">
                <span class="inline-flex items-center px-6 py-3 bg-yellow-100 text-yellow-800 rounded-lg text-lg font-semibold shadow-sm">
                    <i class="fas fa-hourglass-half mr-2"></i> En Attente de Validation
                </span>
            </c:when>
            <c:when test="${consultation.statut == 'VALIDEE'}">
                <span class="inline-flex items-center px-6 py-3 bg-blue-100 text-blue-800 rounded-lg text-lg font-semibold shadow-sm">
                    <i class="fas fa-check-circle mr-2"></i> Validée
                </span>
            </c:when>
            <c:when test="${consultation.statut == 'TERMINEE'}">
                <span class="inline-flex items-center px-6 py-3 bg-green-100 text-green-800 rounded-lg text-lg font-semibold shadow-sm">
                    <i class="fas fa-check-double mr-2"></i> Terminée
                </span>
            </c:when>
            <c:when test="${consultation.statut == 'ANNULEE'}">
                <span class="inline-flex items-center px-6 py-3 bg-red-100 text-red-800 rounded-lg text-lg font-semibold shadow-sm">
                    <i class="fas fa-times-circle mr-2"></i> Annulée
                </span>
            </c:when>
        </c:choose>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <!-- Informations Patient -->
        <div class="lg:col-span-2 space-y-6">

            <!-- Patient Info Card -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center border-b pb-3">
                    <i class="fas fa-user text-blue-600 mr-3"></i>
                    Informations Patient
                </h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="flex items-center p-4 bg-gray-50 rounded-lg">
                        <i class="fas fa-id-card text-blue-600 text-2xl mr-4"></i>
                        <div>
                            <p class="text-xs text-gray-600 mb-1">Nom Complet</p>
                            <p class="font-bold text-gray-900 text-lg">
                                ${consultation.patient.prenom} ${consultation.patient.nom}
                            </p>
                        </div>
                    </div>

                    <div class="flex items-center p-4 bg-gray-50 rounded-lg">
                        <i class="fas fa-envelope text-blue-600 text-2xl mr-4"></i>
                        <div>
                            <p class="text-xs text-gray-600 mb-1">Email</p>
                            <p class="font-semibold text-gray-900">${consultation.patient.email}</p>
                        </div>
                    </div>

                    <c:if test="${consultation.patient.poids != null}">
                        <div class="flex items-center p-4 bg-gray-50 rounded-lg">
                            <i class="fas fa-weight text-blue-600 text-2xl mr-4"></i>
                            <div>
                                <p class="text-xs text-gray-600 mb-1">Poids</p>
                                <p class="font-semibold text-gray-900">${consultation.patient.poids} kg</p>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${consultation.patient.taille != null}">
                        <div class="flex items-center p-4 bg-gray-50 rounded-lg">
                            <i class="fas fa-ruler-vertical text-blue-600 text-2xl mr-4"></i>
                            <div>
                                <p class="text-xs text-gray-600 mb-1">Taille</p>
                                <p class="font-semibold text-gray-900">${consultation.patient.taille} m</p>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Détails Consultation -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center border-b pb-3">
                    <i class="fas fa-calendar-check text-green-600 mr-3"></i>
                    Détails de la Consultation
                </h2>

                <div class="space-y-4">
                    <div class="flex items-start p-4 bg-green-50 rounded-lg border-l-4 border-green-500">
                        <i class="fas fa-calendar text-green-600 text-xl mr-4 mt-1"></i>
                        <div class="flex-1">
                            <p class="text-sm text-gray-600 mb-1">Date</p>
                            <p class="font-bold text-gray-900 text-lg">${consultation.dateFormatee}</p>
                        </div>
                    </div>

                    <div class="flex items-start p-4 bg-blue-50 rounded-lg border-l-4 border-blue-500">
                        <i class="fas fa-clock text-blue-600 text-xl mr-4 mt-1"></i>
                        <div class="flex-1">
                            <p class="text-sm text-gray-600 mb-1">Heure</p>
                            <p class="font-bold text-gray-900 text-lg">${consultation.heure}</p>
                        </div>
                    </div>

                    <div class="flex items-start p-4 bg-purple-50 rounded-lg border-l-4 border-purple-500">
                        <i class="fas fa-door-open text-purple-600 text-xl mr-4 mt-1"></i>
                        <div class="flex-1">
                            <p class="text-sm text-gray-600 mb-1">Salle</p>
                            <p class="font-bold text-gray-900 text-lg">${consultation.salle.nomSalle}</p>
                        </div>
                    </div>

                    <div class="p-4 bg-yellow-50 rounded-lg border-l-4 border-yellow-500">
                        <div class="flex items-start mb-2">
                            <i class="fas fa-notes-medical text-yellow-600 text-xl mr-4 mt-1"></i>
                            <p class="text-sm font-semibold text-gray-700">Motif de la Consultation</p>
                        </div>
                        <p class="text-gray-800 ml-10">${consultation.motifConsultation}</p>
                    </div>

                    <c:if test="${consultation.statut == 'TERMINEE' && consultation.compteRendu != null}">
                        <div class="p-4 bg-gray-50 rounded-lg border-l-4 border-gray-500">
                            <div class="flex items-start mb-2">
                                <i class="fas fa-file-medical text-gray-600 text-xl mr-4 mt-1"></i>
                                <p class="text-sm font-semibold text-gray-700">Compte Rendu</p>
                            </div>
                            <p class="text-gray-800 ml-10 whitespace-pre-wrap">${consultation.compteRendu}</p>
                        </div>
                    </c:if>
                </div>
            </div>

        </div>

        <!-- Actions Card -->
        <div class="lg:col-span-1 space-y-6">

            <div class="bg-white rounded-xl shadow-lg p-6">
                <h2 class="text-lg font-bold text-gray-900 mb-4 flex items-center">
                    <i class="fas fa-tasks text-purple-600 mr-2"></i>
                    Actions
                </h2>

                <div class="space-y-3">

                    <!-- Valider (si RESERVEE) -->
                    <c:if test="${consultation.statut == 'RESERVEE'}">
                        <form action="${pageContext.request.contextPath}/docteur/valider" method="post">
                            <input type="hidden" name="consultationId" value="${consultation.idConsultation}">
                            <button type="submit"
                                    class="w-full px-4 py-3 bg-green-600 text-white rounded-lg hover:bg-green-700 transition shadow-md hover:shadow-lg transform hover:scale-105 flex items-center justify-center">
                                <i class="fas fa-check-circle mr-2"></i>
                                Valider la Consultation
                            </button>
                        </form>

                        <button onclick="refuserConsultation(${consultation.idConsultation})"
                                class="w-full px-4 py-3 bg-red-600 text-white rounded-lg hover:bg-red-700 transition shadow-md hover:shadow-lg transform hover:scale-105 flex items-center justify-center">
                            <i class="fas fa-times-circle mr-2"></i>
                            Refuser
                        </button>
                    </c:if>

                    <!-- Terminer (si VALIDEE) -->
                    <c:if test="${consultation.statut == 'VALIDEE'}">
                        <a href="${pageContext.request.contextPath}/docteur/compte-rendu?id=${consultation.idConsultation}"
                           class="block w-full px-4 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition shadow-md hover:shadow-lg transform hover:scale-105 text-center">
                            <i class="fas fa-file-medical mr-2"></i>
                            Terminer & Rédiger CR
                        </a>
                    </c:if>

                    <!-- Retour Dashboard -->
                    <a href="${pageContext.request.contextPath}/docteur/dashboard"
                       class="block w-full px-4 py-3 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition shadow-md text-center">
                        <i class="fas fa-home mr-2"></i>
                        Retour au Dashboard
                    </a>
                </div>
            </div>

            <!-- Info Card -->
            <div class="bg-gradient-to-br from-blue-50 to-indigo-50 rounded-xl shadow-md p-6 border border-blue-200">
                <div class="flex items-start">
                    <i class="fas fa-info-circle text-blue-600 text-2xl mr-3"></i>
                    <div>
                        <h3 class="font-bold text-gray-900 mb-2">Information</h3>
                        <p class="text-sm text-gray-700">
                            Vous pouvez valider, refuser ou terminer cette consultation selon son statut actuel.
                        </p>
                    </div>
                </div>
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