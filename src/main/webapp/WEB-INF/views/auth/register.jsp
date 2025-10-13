<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Clinique Privée</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen flex items-center justify-center p-4">

<div class="max-w-2xl w-full">

    <!-- Logo et Titre -->
    <div class="text-center mb-8">
        <div class="flex justify-center mb-4">
            <div class="w-16 h-16 bg-blue-600 rounded-full flex items-center justify-center">
                <i class="fas fa-user-plus text-white text-3xl"></i>
            </div>
        </div>
        <h1 class="text-3xl font-bold text-gray-900">Créer un compte</h1>
        <p class="text-gray-600 mt-2">Rejoignez notre clinique en quelques étapes</p>
    </div>

    <!-- Messages d'erreur -->
    <c:if test="${not empty error}">
        <div class="mb-6 p-4 bg-red-100 border-l-4 border-red-500 text-red-700 rounded-lg">
            <div class="flex items-center">
                <i class="fas fa-exclamation-triangle mr-3"></i>
                <span>${error}</span>
            </div>
        </div>
    </c:if>

    <!-- Formulaire d'inscription -->
    <div class="bg-white rounded-2xl shadow-xl p-8">
        <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">

            <!-- Informations personnelles -->
            <div class="mb-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                    <i class="fas fa-user-circle text-blue-600 mr-2"></i>
                    Informations Personnelles
                </h3>

                <div class="grid md:grid-cols-2 gap-4">
                    <!-- Nom -->
                    <div>
                        <label for="nom" class="block text-sm font-medium text-gray-700 mb-2">
                            Nom *
                        </label>
                        <input type="text"
                               id="nom"
                               name="nom"
                               value="${nom}"
                               required
                               pattern="[A-Za-zÀ-ÿ\s-]{2,}"
                               placeholder="Votre nom"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition">
                        <p class="text-xs text-gray-500 mt-1">Minimum 2 caractères</p>
                    </div>

                    <!-- Prénom -->
                    <div>
                        <label for="prenom" class="block text-sm font-medium text-gray-700 mb-2">
                            Prénom *
                        </label>
                        <input type="text"
                               id="prenom"
                               name="prenom"
                               value="${prenom}"
                               required
                               pattern="[A-Za-zÀ-ÿ\s-]{2,}"
                               placeholder="Votre prénom"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition">
                        <p class="text-xs text-gray-500 mt-1">Minimum 2 caractères</p>
                    </div>
                </div>
            </div>

            <!-- Email -->
            <div class="mb-6">
                <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-envelope text-blue-600 mr-2"></i>
                    Adresse Email *
                </label>
                <input type="email"
                       id="email"
                       name="email"
                       value="${email}"
                       required
                       placeholder="exemple@email.com"
                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition">
            </div>

            <!-- Mots de passe -->
            <div class="mb-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                    <i class="fas fa-lock text-blue-600 mr-2"></i>
                    Sécurité
                </h3>

                <div class="grid md:grid-cols-2 gap-4">
                    <!-- Mot de passe -->
                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-2">
                            Mot de passe *
                        </label>
                        <div class="relative">
                            <input type="password"
                                   id="password"
                                   name="password"
                                   required
                                   minlength="8"
                                   placeholder="••••••••"
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition pr-12">
                            <button type="button"
                                    onclick="togglePasswordVisibility('password', 'toggleIcon1')"
                                    class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700">
                                <i class="fas fa-eye" id="toggleIcon1"></i>
                            </button>
                        </div>
                        <p class="text-xs text-gray-500 mt-1">Minimum 8 caractères, 1 majuscule, 1 chiffre</p>
                    </div>

                    <!-- Confirmation mot de passe -->
                    <div>
                        <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-2">
                            Confirmer le mot de passe *
                        </label>
                        <div class="relative">
                            <input type="password"
                                   id="confirmPassword"
                                   name="confirmPassword"
                                   required
                                   placeholder="••••••••"
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition pr-12">
                            <button type="button"
                                    onclick="togglePasswordVisibility('confirmPassword', 'toggleIcon2')"
                                    class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700">
                                <i class="fas fa-eye" id="toggleIcon2"></i>
                            </button>
                        </div>
                        <p class="text-xs text-red-500 mt-1 hidden" id="passwordMismatch">
                            Les mots de passe ne correspondent pas
                        </p>
                    </div>
                </div>

                <!-- Password strength indicator -->
                <div class="mt-3">
                    <div class="flex items-center space-x-2">
                        <div class="flex-1 h-2 bg-gray-200 rounded-full overflow-hidden">
                            <div id="passwordStrength" class="h-full bg-gray-300 transition-all duration-300" style="width: 0%"></div>
                        </div>
                        <span id="passwordStrengthText" class="text-sm text-gray-600">Faible</span>
                    </div>
                </div>
            </div>

            <!-- Informations médicales -->
            <div class="mb-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                    <i class="fas fa-notes-medical text-blue-600 mr-2"></i>
                    Informations Médicales
                </h3>

                <div class="grid md:grid-cols-2 gap-4">
                    <!-- Poids -->
                    <div>
                        <label for="poids" class="block text-sm font-medium text-gray-700 mb-2">
                            Poids (kg) *
                        </label>
                        <input type="number"
                               id="poids"
                               name="poids"
                               value="${poids}"
                               required
                               step="0.1"
                               min="1"
                               max="300"
                               placeholder="Ex: 70.5"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition">
                        <p class="text-xs text-gray-500 mt-1">Entre 1 et 300 kg</p>
                    </div>

                    <!-- Taille -->
                    <div>
                        <label for="taille" class="block text-sm font-medium text-gray-700 mb-2">
                            Taille (m) *
                        </label>
                        <input type="number"
                               id="taille"
                               name="taille"
                               value="${taille}"
                               required
                               step="0.01"
                               min="0.5"
                               max="2.5"
                               placeholder="Ex: 1.75"
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition">
                        <p class="text-xs text-gray-500 mt-1">Entre 0.5 et 2.5 m</p>
                    </div>
                </div>
            </div>

            <!-- Conditions générales -->
            <div class="mb-6">
                <label class="flex items-start">
                    <input type="checkbox"
                           id="terms"
                           required
                           class="mt-1 w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500">
                    <span class="ml-3 text-sm text-gray-600">
                            J'accepte les
                            <a href="#" class="text-blue-600 hover:text-blue-800">conditions générales d'utilisation</a>
                            et la
                            <a href="#" class="text-blue-600 hover:text-blue-800">politique de confidentialité</a>
                        </span>
                </label>
            </div>

            <!-- Bouton d'inscription -->
            <button type="submit"
                    class="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold hover:bg-blue-700 transition transform hover:scale-105 shadow-lg">
                <i class="fas fa-user-plus mr-2"></i>
                Créer mon compte
            </button>

        </form>

        <!-- Lien vers connexion -->
        <div class="mt-6 text-center">
            <p class="text-gray-600">
                Vous avez déjà un compte ?
                <a href="${pageContext.request.contextPath}/login"
                   class="text-blue-600 hover:text-blue-800 font-semibold">
                    Connectez-vous
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
    function togglePasswordVisibility(inputId, iconId) {
        const input = document.getElementById(inputId);
        const icon = document.getElementById(iconId);

        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }

    // Password strength checker
    const passwordInput = document.getElementById('password');
    const strengthBar = document.getElementById('passwordStrength');
    const strengthText = document.getElementById('passwordStrengthText');

    passwordInput.addEventListener('input', function() {
        const password = this.value;
        let strength = 0;

        if (password.length >= 8) strength += 25;
        if (password.match(/[a-z]/)) strength += 25;
        if (password.match(/[A-Z]/)) strength += 25;
        if (password.match(/[0-9]/)) strength += 25;

        strengthBar.style.width = strength + '%';

        if (strength <= 25) {
            strengthBar.className = 'h-full bg-red-500 transition-all duration-300';
            strengthText.textContent = 'Faible';
            strengthText.className = 'text-sm text-red-600';
        } else if (strength <= 50) {
            strengthBar.className = 'h-full bg-orange-500 transition-all duration-300';
            strengthText.textContent = 'Moyen';
            strengthText.className = 'text-sm text-orange-600';
        } else if (strength <= 75) {
            strengthBar.className = 'h-full bg-yellow-500 transition-all duration-300';
            strengthText.textContent = 'Bon';
            strengthText.className = 'text-sm text-yellow-600';
        } else {
            strengthBar.className = 'h-full bg-green-500 transition-all duration-300';
            strengthText.textContent = 'Fort';
            strengthText.className = 'text-sm text-green-600';
        }
    });

    // Check password match
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const mismatchText = document.getElementById('passwordMismatch');

    confirmPasswordInput.addEventListener('input', function() {
        if (this.value !== passwordInput.value) {
            mismatchText.classList.remove('hidden');
            this.classList.add('border-red-500');
        } else {
            mismatchText.classList.add('hidden');
            this.classList.remove('border-red-500');
        }
    });

    // Form validation
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const terms = document.getElementById('terms').checked;

        if (password !== confirmPassword) {
            e.preventDefault();
            alert('Les mots de passe ne correspondent pas');
            return false;
        }

        if (!terms) {
            e.preventDefault();
            alert('Veuillez accepter les conditions générales');
            return false;
        }
    });
</script>

</body>
</html>