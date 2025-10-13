<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clinique Privée - Accueil</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen">

<!-- Navigation -->
<nav class="bg-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <i class="fas fa-heartbeat text-blue-600 text-3xl mr-3"></i>
                <span class="text-2xl font-bold text-gray-800">Clinique Privée</span>
            </div>
            <div class="flex items-center space-x-4">
                <a href="${pageContext.request.contextPath}/login"
                   class="px-4 py-2 text-blue-600 hover:text-blue-800 font-medium transition">
                    Connexion
                </a>
                <a href="${pageContext.request.contextPath}/register"
                   class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition shadow-md">
                    Inscription
                </a>
            </div>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
    <div class="text-center">
        <h1 class="text-5xl font-bold text-gray-900 mb-6">
            Bienvenue dans votre
            <span class="text-blue-600">Clinique Digitale</span>
        </h1>
        <p class="text-xl text-gray-600 mb-12 max-w-3xl mx-auto">
            Gérez vos consultations médicales en ligne. Réservez, suivez et consultez
            vos rendez-vous avec nos docteurs spécialisés en quelques clics.
        </p>

        <div class="flex justify-center space-x-4">
            <a href="${pageContext.request.contextPath}/register"
               class="px-8 py-4 bg-blue-600 text-white rounded-lg text-lg font-semibold hover:bg-blue-700 transition shadow-lg transform hover:scale-105">
                <i class="fas fa-user-plus mr-2"></i>
                Créer un compte
            </a>
            <a href="${pageContext.request.contextPath}/login"
               class="px-8 py-4 bg-white text-blue-600 border-2 border-blue-600 rounded-lg text-lg font-semibold hover:bg-blue-50 transition shadow-lg transform hover:scale-105">
                <i class="fas fa-sign-in-alt mr-2"></i>
                Se connecter
            </a>
        </div>
    </div>
</div>

<!-- Features Section -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
    <div class="grid md:grid-cols-3 gap-8">

        <!-- Feature 1 -->
        <div class="bg-white rounded-xl shadow-lg p-8 text-center transform hover:scale-105 transition">
            <div class="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <i class="fas fa-calendar-check text-blue-600 text-2xl"></i>
            </div>
            <h3 class="text-xl font-bold text-gray-800 mb-3">Réservation Facile</h3>
            <p class="text-gray-600">
                Réservez vos consultations en ligne 24/7. Choisissez votre docteur,
                la date et l'heure qui vous conviennent.
            </p>
        </div>

        <!-- Feature 2 -->
        <div class="bg-white rounded-xl shadow-lg p-8 text-center transform hover:scale-105 transition">
            <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <i class="fas fa-user-md text-green-600 text-2xl"></i>
            </div>
            <h3 class="text-xl font-bold text-gray-800 mb-3">Docteurs Spécialisés</h3>
            <p class="text-gray-600">
                Accédez à des médecins qualifiés dans différents départements :
                cardiologie, dermatologie, pédiatrie...
            </p>
        </div>

        <!-- Feature 3 -->
        <div class="bg-white rounded-xl shadow-lg p-8 text-center transform hover:scale-105 transition">
            <div class="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <i class="fas fa-history text-purple-600 text-2xl"></i>
            </div>
            <h3 class="text-xl font-bold text-gray-800 mb-3">Historique Médical</h3>
            <p class="text-gray-600">
                Consultez votre historique de consultations et vos comptes rendus
                médicaux à tout moment.
            </p>
        </div>

    </div>
</div>

<!-- Statistics Section -->
<div class="bg-blue-600 text-white py-16 mt-16">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid md:grid-cols-3 gap-8 text-center">
            <div>
                <div class="text-5xl font-bold mb-2">500+</div>
                <div class="text-blue-200 text-lg">Patients Satisfaits</div>
            </div>
            <div>
                <div class="text-5xl font-bold mb-2">25+</div>
                <div class="text-blue-200 text-lg">Docteurs Qualifiés</div>
            </div>
            <div>
                <div class="text-5xl font-bold mb-2">98%</div>
                <div class="text-blue-200 text-lg">Taux de Satisfaction</div>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="bg-gray-900 text-white py-8 mt-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <p class="text-gray-400">
            &copy; 2025 Clinique Privée. Tous droits réservés.
            Développé par <span class="text-blue-400">Othman</span>
        </p>
    </div>
</footer>

</body>
</html>