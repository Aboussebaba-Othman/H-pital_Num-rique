<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Clinique Privée</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen flex items-center justify-center p-4">

<div class="max-w-md w-full">

    <!-- Logo et Titre -->
    <div class="text-center mb-8">
        <div class="flex justify-center mb-4">
            <div class="w-16 h-16 bg-blue-600 rounded-full flex items-center justify-center">
                <i class="fas fa-heartbeat text-white text-3xl"></i>
            </div>
        </div>
        <h1 class="text-3xl font-bold text-gray-900">Connexion</h1>
        <p class="text-gray-600 mt-2">Accédez à votre espace patient</p>
    </div>

    <!-- Messages de succès -->
    <c:if test="${param.success != null}">
        <div class="mb-6 p-4 bg-green-100 border-l-4 border-green-500 text-green-700 rounded">
            <div class="flex items-center">
                <i class="fas fa-check-circle mr-3"></i>
                <span>${param.success}</span>
            </div>
        </div>
    </c:if>

    <c:if test="${param.logout == 'true'}">
        <div class="mb-6 p-4 bg-blue-100 border-l-4 border-blue-500 text-blue-700 rounded">
            <div class="flex items-center">
                <i class="fas fa-info-circle mr-3"></i>
                <span>Vous avez été déconnecté avec succès</span>
            </div>
        </div>
    </c:if>

    <!-- Messages d'erreur -->
    <c:if test="${not empty error}">
        <div class="mb-6 p-4 bg-red-100 border-l-4 border-red-500 text-red-700 rounded">
            <div class="flex items-center">
                <i class="fas fa-exclamation-triangle mr-3"></i>
                <span>${error}</span>
            </div>
        </div>
    </c:if>

    <!-- Formulaire de connexion -->
    <div class="bg-white rounded-2xl shadow-xl p-8">
        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">

            <!-- Email -->
            <div class="mb-6">
                <label for="email" class="block text-sm font-semibold text-gray-700 mb-2">
                    <i class="fas fa-envelope mr-2 text-blue-600"></i>
                    Adresse Email
                </label>
                <input type="email"
                       id="email"
                       name="email"
                       value="${email}"
                       required
                       placeholder="exemple@email.com"
                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
            </div>

            <!-- Mot de passe -->
            <div class="mb-6">
                <label for="password" class="block text-sm font-semibold text-gray-700 mb-2">
                    <i class="fas fa-lock mr-2 text-blue-600"></i>
                    Mot de passe
                </label>
                <div class="relative">
                    <input type="password"
                           id="password"
                           name="password"
                           required
                           placeholder="••••••••"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition pr-12">
                    <button type="button"
                            onclick="togglePassword()"
                            class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700">
                        <i class="fas fa-eye" id="toggleIcon"></i>
                    </button>
                </div>
            </div>

            <!-- Remember me & Forgot password -->
            <div class="flex items-center justify-between mb-6">
                <label class="flex items-center">
                    <input type="checkbox"
                           name="remember"
                           class="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500">
                    <span class="ml-2 text-sm text-gray-600">Se souvenir de moi</span>
                </label>
                <a href="#" class="text-sm text-blue-600 hover:text-blue-800">
                    Mot de passe oublié ?
                </a>
            </div>

            <!-- Bouton de connexion -->
            <button type="submit"
                    class="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold hover:bg-blue-700 transition transform hover:scale-105 shadow-lg">
                <i class="fas fa-sign-in-alt mr-2"></i>
                Se connecter
            </button>

        </form>

        <!-- Lien vers inscription -->
        <div class="mt-6 text-center">
            <p class="text-gray-600">
                Vous n'avez pas de compte ?
                <a href="${pageContext.request.contextPath}/register"
                   class="text-blue-600 hover:text-blue-800 font-semibold">
                    Inscrivez-vous
                </a>
            </p>
        </div>
    </div>

    <!-- Retour à l'accueil -->
    <div class="text-center mt-6">
        <a href="${pageContext.request.contextPath}/"
           class="text-gray-600 hover:text-gray-900 transition">
            <i class="fas fa-arrow-left mr-2"></i>
            Retour à l'accueil
        </a>
    </div>

</div>

<script>
    // Toggle password visibility
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const toggleIcon = document.getElementById('toggleIcon');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.classList.remove('fa-eye');
            toggleIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            toggleIcon.classList.remove('fa-eye-slash');
            toggleIcon.classList.add('fa-eye');
        }
    }

    // Validation côté client
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;

        if (!email || !password) {
            e.preventDefault();
            alert('Veuillez remplir tous les champs');
        }
    });
</script>

</body>
</html>