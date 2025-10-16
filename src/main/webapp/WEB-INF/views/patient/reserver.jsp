<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réserver une Consultation - Clinique</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body>

<!-- Définir la page active pour la sidebar -->
<c:set var="pageParam" value="consultations" scope="request"/>

<!-- Inclure la sidebar patient -->
<%@ include file="../common/patient-nav.jsp" %>

<div class="max-w-5xl mx-auto py-4">
    <!-- En-tête -->
    <div class="mb-4">
        <h2 class="text-2xl font-bold"><i class="fas fa-calendar-plus text-indigo-600 mr-2"></i> Réserver une Consultation</h2>
        <p class="text-gray-500">Remplissez le formulaire pour prendre rendez-vous</p>
    </div>

    <!-- Messages -->
    <c:if test="${not empty errorMessage}">
        <div class="mb-4 p-3 bg-red-50 border border-red-100 text-red-800 rounded"> <i class="fas fa-exclamation-circle mr-2"></i> ${errorMessage}</div>
    </c:if>

    <!-- Docteur sélectionné (si applicable) -->
    <c:if test="${not empty docteurSelectionne}">
        <div class="mb-4 p-4 border-l-4 border-indigo-600 bg-indigo-50 rounded">
            <h5 class="font-semibold"><i class="fas fa-user-md mr-2"></i> Docteur sélectionné</h5>
            <p class="text-sm"><strong>Dr. ${docteurSelectionne.prenom} ${docteurSelectionne.nom}</strong> — ${docteurSelectionne.specialite}</p>
        </div>
    </c:if>

    <!-- Formulaire de réservation -->
    <div class="bg-white p-2 rounded-lg shadow">
        <form method="post" action="${pageContext.request.contextPath}/patient/reserver" class="space-y-4">

            <div>
                <label for="docteurId" class="block text-sm font-medium text-gray-700">Docteur *</label>
                <select id="docteurId" name="docteurId" required class="mt-1 block w-full border rounded px-3 py-2">
                    <option value="">Choisir un docteur...</option>
                    <c:forEach items="${docteurs}" var="docteur">
                        <option value="${docteur.idDocteur}" ${docteur.idDocteur == docteurSelectionne.idDocteur ? 'selected' : ''}>Dr. ${docteur.prenom} ${docteur.nom} - ${docteur.specialite}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label for="date" class="block text-sm font-medium text-gray-700">Date de la consultation *</label>
                    <input type="date" id="date" name="date" required class="mt-1 block w-full border rounded px-3 py-2">
                    <p class="text-xs text-gray-500 mt-1">Les consultations doivent être réservées au moins 24h à l'avance</p>
                </div>
                <div>
                    <label for="heure" class="block text-sm font-medium text-gray-700">Heure *</label>
                    <select id="heure" name="heure" required class="mt-1 block w-full border rounded px-3 py-2">
                        <option value="">Choisir une heure...</option>
                        <option value="08:00">08:00</option>
                        <option value="08:30">08:30</option>
                        <option value="09:00">09:00</option>
                        <option value="09:30">09:30</option>
                        <option value="10:00">10:00</option>
                        <option value="10:30">10:30</option>
                        <option value="11:00">11:00</option>
                        <option value="11:30">11:30</option>
                        <option value="14:00">14:00</option>
                        <option value="14:30">14:30</option>
                        <option value="15:00">15:00</option>
                        <option value="15:30">15:30</option>
                        <option value="16:00">16:00</option>
                        <option value="16:30">16:30</option>
                        <option value="17:00">17:00</option>
                        <option value="17:30">17:30</option>
                    </select>
                    <p class="text-xs text-gray-500 mt-1">Heures de consultation : 8h-12h et 14h-18h</p>
                </div>
            </div>

            <div>
                <label for="motif" class="block text-sm font-medium text-gray-700">Motif de la consultation *</label>
                <textarea id="motif" name="motif" rows="4" required minlength="10" maxlength="500" placeholder="Décrivez brièvement la raison de votre consultation..." class="mt-1 block w-full border rounded px-3 py-2"></textarea>
                <p class="text-xs text-gray-500 mt-1">Entre 10 et 500 caractères</p>
            </div>

            <div class="flex gap-3">
                <button type="submit" class="px-4 py-2 bg-indigo-600 text-white rounded"> <i class="fas fa-check mr-2"></i> Confirmer la réservation</button>
                <a href="${pageContext.request.contextPath}/patient/docteurs" class="px-4 py-2 border rounded text-gray-700"> <i class="fas fa-arrow-left mr-2"></i> Retour</a>
            </div>
        </form>
    </div>

    <!-- Informations -->
    <div class="mt-4 p-4 bg-gray-50 rounded text-sm text-gray-700">
        <h6 class="font-medium mb-2"><i class="fas fa-info-circle text-indigo-600 mr-2"></i> Informations importantes</h6>
        <ul class="list-disc ml-5">
            <li>Les consultations doivent être réservées au moins 24 heures à l'avance</li>
            <li>Vous pouvez annuler votre rendez-vous jusqu'à 24 heures avant</li>
            <li>Le docteur validera ou refusera votre demande de consultation</li>
            <li>Vous recevrez une notification de la décision du docteur</li>
        </ul>
    </div>
</div>

</main>
</div>

<script>
    // Définir la date minimale à demain
    const today = new Date();
    today.setDate(today.getDate() + 1);
    const tomorrow = today.toISOString().split('T')[0];
    document.addEventListener('DOMContentLoaded', function(){
        const dateEl = document.getElementById('date');
        if(dateEl) dateEl.setAttribute('min', tomorrow);
    });
</script>

</body>
</html>