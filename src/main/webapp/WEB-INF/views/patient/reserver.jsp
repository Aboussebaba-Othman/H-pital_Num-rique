<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réserver une Consultation - Clinique</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">

<c:set var="pageParam" value="consultations" scope="request"/>
<%@ include file="../common/patient-nav.jsp" %>

<div class="max-w-4xl mx-auto p-6">

    <!-- En-tête stylé -->
    <div class="mb-8">
        <div class="flex items-center mb-4">
            <div class="w-14 h-14 bg-gradient-to-br from-indigo-500 to-purple-500 rounded-2xl flex items-center justify-center mr-4 shadow-lg">
                <i class="fas fa-calendar-plus text-white text-2xl"></i>
            </div>
            <div>
                <h2 class="text-3xl font-bold text-gray-800">Réserver une Consultation</h2>
                <p class="text-gray-500">Prenez rendez-vous avec nos spécialistes</p>
            </div>
        </div>
    </div>

    <!-- Message d'erreur -->
    <c:if test="${not empty errorMessage}">
        <div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 rounded-lg shadow-sm">
            <div class="flex items-center">
                <i class="fas fa-exclamation-circle text-red-500 text-xl mr-3"></i>
                <p class="text-red-800 font-medium">${errorMessage}</p>
            </div>
        </div>
    </c:if>

    <!-- Docteur sélectionné -->
    <c:if test="${not empty docteurSelectionne}">
        <div class="mb-6 p-6 bg-gradient-to-r from-indigo-50 to-purple-50 border-l-4 border-indigo-500 rounded-2xl shadow-md">
            <div class="flex items-center">
                <div class="w-16 h-16 bg-white rounded-xl flex items-center justify-center mr-4 shadow">
                    <i class="fas fa-user-md text-indigo-600 text-2xl"></i>
                </div>
                <div>
                    <h5 class="font-bold text-lg text-gray-800 mb-1">Docteur sélectionné</h5>
                    <p class="text-gray-700">
                        <strong>Dr. ${docteurSelectionne.prenom} ${docteurSelectionne.nom}</strong>
                        <span class="mx-2">•</span>
                        <span class="text-indigo-600">${docteurSelectionne.specialite}</span>
                    </p>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Formulaire moderne -->
    <div class="bg-white rounded-2xl shadow-xl p-8 mb-8">
        <form method="post" action="${pageContext.request.contextPath}/patient/reserver" class="space-y-6">

            <!-- Sélection du docteur -->
            <div>
                <label for="docteurId" class="block text-sm font-semibold text-gray-700 mb-2">
                    <i class="fas fa-user-md text-indigo-600 mr-2"></i>Choisir un docteur *
                </label>
                <select id="docteurId" name="docteurId" required
                        class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition">
                    <option value="">Sélectionnez un docteur...</option>
                    <c:forEach items="${docteurs}" var="docteur">
                        <option value="${docteur.idDocteur}" ${docteur.idDocteur == docteurSelectionne.idDocteur ? 'selected' : ''}>
                            Dr. ${docteur.prenom} ${docteur.nom} - ${docteur.specialite}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Date et Heure -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label for="date" class="block text-sm font-semibold text-gray-700 mb-2">
                        <i class="fas fa-calendar text-indigo-600 mr-2"></i>Date de consultation *
                    </label>
                    <input type="date" id="date" name="date" required
                           class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition">
                    <p class="text-xs text-gray-500 mt-2 flex items-center">
                        <i class="fas fa-info-circle mr-1"></i>
                        Réservation au moins 24h à l'avance
                    </p>
                </div>

                <div>
                    <label for="heure" class="block text-sm font-semibold text-gray-700 mb-2">
                        <i class="fas fa-clock text-indigo-600 mr-2"></i>Heure *
                    </label>
                    <select id="heure" name="heure" required
                            class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition">
                        <option value="">Sélectionnez une heure...</option>
                        <optgroup label="Matin (8h - 12h)">
                            <option value="08:00">08:00</option>
                            <option value="08:30">08:30</option>
                            <option value="09:00">09:00</option>
                            <option value="09:30">09:30</option>
                            <option value="10:00">10:00</option>
                            <option value="10:30">10:30</option>
                            <option value="11:00">11:00</option>
                            <option value="11:30">11:30</option>
                        </optgroup>
                        <optgroup label="Après-midi (14h - 18h)">
                            <option value="14:00">14:00</option>
                            <option value="14:30">14:30</option>
                            <option value="15:00">15:00</option>
                            <option value="15:30">15:30</option>
                            <option value="16:00">16:00</option>
                            <option value="16:30">16:30</option>
                            <option value="17:00">17:00</option>
                            <option value="17:30">17:30</option>
                        </optgroup>
                    </select>
                    <p class="text-xs text-gray-500 mt-2 flex items-center">
                        <i class="fas fa-info-circle mr-1"></i>
                        Consultations de 30 minutes
                    </p>
                </div>
            </div>

            <!-- Motif -->
            <div>
                <label for="motif" class="block text-sm font-semibold text-gray-700 mb-2">
                    <i class="fas fa-file-medical text-indigo-600 mr-2"></i>Motif de consultation *
                </label>
                <textarea id="motif" name="motif" rows="5" required minlength="10" maxlength="500"
                          placeholder="Décrivez brièvement la raison de votre consultation (symptômes, préoccupations médicales...)"
                          class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition resize-none"></textarea>
                <div class="flex justify-between mt-2">
                    <p class="text-xs text-gray-500">Entre 10 et 500 caractères</p>
                    <p class="text-xs text-gray-400" id="charCount">0/500</p>
                </div>
            </div>

            <!-- Boutons -->
            <div class="flex flex-col sm:flex-row gap-4 pt-4">
                <button type="submit"
                        class="flex-1 px-8 py-4 bg-gradient-to-r from-indigo-600 to-purple-600 text-white rounded-xl hover:from-indigo-700 hover:to-purple-700 transition shadow-lg font-semibold">
                    <i class="fas fa-check mr-2"></i>Confirmer la réservation
                </button>
                <a href="${pageContext.request.contextPath}/patient/docteurs"
                   class="flex-1 px-8 py-4 border-2 border-gray-300 rounded-xl text-gray-700 hover:bg-gray-50 transition text-center font-semibold">
                    <i class="fas fa-arrow-left mr-2"></i>Retour
                </a>
            </div>
        </form>
    </div>

    <!-- Informations importantes -->
    <div class="bg-gradient-to-br from-blue-50 to-indigo-50 rounded-2xl shadow-lg p-8 border border-blue-100">
        <div class="flex items-center mb-4">
            <div class="w-10 h-10 bg-blue-500 rounded-lg flex items-center justify-center mr-3">
                <i class="fas fa-info-circle text-white"></i>
            </div>
            <h6 class="text-lg font-bold text-gray-800">Informations importantes</h6>
        </div>
        <ul class="space-y-3">
            <li class="flex items-start">
                <i class="fas fa-check-circle text-green-500 mr-3 mt-1"></i>
                <span class="text-gray-700">Les consultations doivent être réservées au moins 24 heures à l'avance</span>
            </li>
            <li class="flex items-start">
                <i class="fas fa-check-circle text-green-500 mr-3 mt-1"></i>
                <span class="text-gray-700">Vous pouvez annuler votre rendez-vous jusqu'à 24 heures avant</span>
            </li>
            <li class="flex items-start">
                <i class="fas fa-check-circle text-green-500 mr-3 mt-1"></i>
                <span class="text-gray-700">Le docteur validera ou refusera votre demande de consultation</span>
            </li>
            <li class="flex items-start">
                <i class="fas fa-check-circle text-green-500 mr-3 mt-1"></i>
                <span class="text-gray-700">Vous recevrez une notification de la décision du docteur</span>
            </li>
        </ul>
    </div>
</div>

<script>
    // Date minimale (demain)
    const today = new Date();
    today.setDate(today.getDate() + 1);
    const tomorrow = today.toISOString().split('T')[0];
    document.addEventListener('DOMContentLoaded', function(){
        const dateEl = document.getElementById('date');
        if(dateEl) dateEl.setAttribute('min', tomorrow);

        // Compteur de caractères
        const motifEl = document.getElementById('motif');
        const charCountEl = document.getElementById('charCount');
        if(motifEl && charCountEl) {
            motifEl.addEventListener('input', function() {
                charCountEl.textContent = this.value.length + '/500';
            });
        }
    });
</script>

</body>
</html>