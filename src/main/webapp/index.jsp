<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hôpital Numérique - Votre Santé en Ligne</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-20px);
            }
        }

        @keyframes gradientShift {
            0% {
                background-position: 0% 50%;
            }
            50% {
                background-position: 100% 50%;
            }
            100% {
                background-position: 0% 50%;
            }
        }

        .animate-fadeInUp {
            animation: fadeInUp 1s ease-out forwards;
        }

        .animate-fadeInDown {
            animation: fadeInDown 0.8s ease-out forwards;
        }

        .animate-slideInLeft {
            animation: slideInLeft 1s ease-out forwards;
        }

        .animate-slideInRight {
            animation: slideInRight 1s ease-out forwards;
        }

        .animate-pulse-slow {
            animation: pulse 3s ease-in-out infinite;
        }

        .animate-float {
            animation: float 3s ease-in-out infinite;
        }

        .gradient-animate {
            background-size: 200% 200%;
            animation: gradientShift 5s ease infinite;
        }

        .glass-effect {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .card-hover {
            transition: all 0.3s ease;
        }

        .card-hover:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }

        .delay-100 { animation-delay: 0.1s; }
        .delay-200 { animation-delay: 0.2s; }
        .delay-300 { animation-delay: 0.3s; }
        .delay-400 { animation-delay: 0.4s; }
        .delay-500 { animation-delay: 0.5s; }
        .delay-600 { animation-delay: 0.6s; }

        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 10px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        ::-webkit-scrollbar-thumb {
            background: linear-gradient(180deg, #3b82f6, #8b5cf6);
            border-radius: 5px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(180deg, #2563eb, #7c3aed);
        }
    </style>
</head>
<body class="bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 min-h-screen overflow-x-hidden">

<!-- Navigation -->
<nav class="bg-white/80 backdrop-blur-md shadow-lg sticky top-0 z-50 animate-fadeInDown">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-20">
            <div class="flex items-center animate-slideInLeft">
                <div class="relative">
                    <div class="absolute inset-0 bg-gradient-to-r from-blue-600 to-purple-600 rounded-full blur-lg opacity-50 animate-pulse-slow"></div>
                    <div class="relative w-14 h-14 bg-gradient-to-r from-blue-600 to-purple-600 rounded-full flex items-center justify-center shadow-lg">
                        <i class="fas fa-heartbeat text-white text-2xl animate-pulse"></i>
                    </div>
                </div>
                <div class="ml-4">
                    <span class="text-2xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                        Hôpital Numérique
                    </span>
                    <p class="text-xs text-gray-500 font-medium">Votre santé, notre priorité</p>
                </div>
            </div>
            <div class="flex items-center space-x-4 animate-slideInRight">
                <a href="${pageContext.request.contextPath}/login"
                   class="px-6 py-2 text-gray-700 hover:text-blue-600 font-semibold transition-all duration-300 hover:scale-105">
                    <i class="fas fa-sign-in-alt mr-2"></i>Connexion
                </a>
                <a href="${pageContext.request.contextPath}/register"
                   class="px-6 py-3 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-xl hover:from-blue-700 hover:to-purple-700 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:scale-105 font-semibold">
                    <i class="fas fa-user-plus mr-2"></i>Inscription
                </a>
            </div>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
    <!-- Floating Background Elements -->
    <div class="absolute top-10 left-10 w-72 h-72 bg-blue-300 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-float"></div>
    <div class="absolute top-20 right-10 w-72 h-72 bg-purple-300 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-float delay-200" style="animation-delay: 1s;"></div>
    <div class="absolute -bottom-8 left-20 w-72 h-72 bg-pink-300 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-float delay-400" style="animation-delay: 2s;"></div>

    <div class="relative text-center">
        <div class="animate-fadeInUp opacity-0">
            <span class="inline-block px-6 py-2 bg-gradient-to-r from-blue-100 to-purple-100 rounded-full text-blue-600 font-semibold text-sm mb-6 shadow-md">
                ✨ Plateforme Médicale de Nouvelle Génération
            </span>
        </div>
        
        <h1 class="text-6xl md:text-7xl font-extrabold text-gray-900 mb-6 animate-fadeInUp opacity-0 delay-100">
            Bienvenue dans votre
            <br/>
            <span class="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent animate-pulse-slow">
                Hôpital Numérique
            </span>
        </h1>
        
        <p class="text-xl md:text-2xl text-gray-600 mb-12 max-w-4xl mx-auto leading-relaxed animate-fadeInUp opacity-0 delay-200">
            Gérez vos consultations médicales en ligne avec facilité et sécurité. 
            <br/>Réservez, suivez et consultez vos rendez-vous avec nos médecins spécialisés en quelques clics.
        </p>

        <div class="flex flex-col sm:flex-row justify-center gap-4 mb-16 animate-fadeInUp opacity-0 delay-300">
            <a href="${pageContext.request.contextPath}/register"
               class="group px-10 py-5 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-2xl text-lg font-bold hover:from-blue-700 hover:to-purple-700 transition-all duration-300 shadow-2xl hover:shadow-blue-500/50 transform hover:scale-105">
                <i class="fas fa-rocket mr-2 group-hover:animate-bounce"></i>
                Commencer Maintenant
                <i class="fas fa-arrow-right ml-2 group-hover:translate-x-2 inline-block transition-transform"></i>
            </a>
            <a href="#features"
               class="px-10 py-5 bg-white text-gray-700 border-2 border-gray-300 rounded-2xl text-lg font-bold hover:border-blue-500 hover:text-blue-600 transition-all duration-300 shadow-xl hover:shadow-2xl transform hover:scale-105">
                <i class="fas fa-info-circle mr-2"></i>
                En savoir plus
            </a>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto animate-fadeInUp opacity-0 delay-400">
            <div class="bg-white/70 backdrop-blur-sm rounded-2xl p-6 shadow-xl card-hover border border-gray-100">
                <div class="text-4xl font-bold bg-gradient-to-r from-blue-600 to-blue-400 bg-clip-text text-transparent mb-2">
                    500+
                </div>
                <div class="text-gray-600 font-semibold">Patients Actifs</div>
            </div>
            <div class="bg-white/70 backdrop-blur-sm rounded-2xl p-6 shadow-xl card-hover border border-gray-100">
                <div class="text-4xl font-bold bg-gradient-to-r from-purple-600 to-purple-400 bg-clip-text text-transparent mb-2">
                    25+
                </div>
                <div class="text-gray-600 font-semibold">Médecins Experts</div>
            </div>
            <div class="bg-white/70 backdrop-blur-sm rounded-2xl p-6 shadow-xl card-hover border border-gray-100">
                <div class="text-4xl font-bold bg-gradient-to-r from-pink-600 to-pink-400 bg-clip-text text-transparent mb-2">
                    98%
                </div>
                <div class="text-gray-600 font-semibold">Satisfaction</div>
            </div>
        </div>
    </div>
</div>

<!-- Features Section -->
<div id="features" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
    <div class="text-center mb-16 animate-fadeInUp opacity-0">
        <h2 class="text-5xl font-bold text-gray-900 mb-4">
            Pourquoi nous <span class="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">choisir ?</span>
        </h2>
        <p class="text-xl text-gray-600 max-w-2xl mx-auto">
            Une plateforme complète pour gérer votre santé en toute simplicité
        </p>
    </div>

    <div class="grid md:grid-cols-3 gap-8">
        <!-- Feature 1 -->
        <div class="bg-white rounded-3xl shadow-xl p-8 text-center card-hover border border-gray-100 animate-fadeInUp opacity-0 delay-100">
            <div class="relative mb-6">
                <div class="absolute inset-0 bg-gradient-to-r from-blue-400 to-blue-600 rounded-full blur-2xl opacity-30 animate-pulse-slow"></div>
                <div class="relative w-20 h-20 bg-gradient-to-r from-blue-400 to-blue-600 rounded-2xl flex items-center justify-center mx-auto shadow-2xl transform rotate-6 hover:rotate-0 transition-transform duration-300">
                    <i class="fas fa-calendar-check text-white text-3xl"></i>
                </div>
            </div>
            <h3 class="text-2xl font-bold text-gray-800 mb-4">Réservation Instantanée</h3>
            <p class="text-gray-600 leading-relaxed">
                Réservez vos consultations en ligne 24/7. Choisissez votre médecin, 
                la date et l'heure qui vous conviennent en quelques clics.
            </p>
            <div class="mt-6 flex justify-center gap-2">
                <span class="px-3 py-1 bg-blue-100 text-blue-600 rounded-full text-xs font-semibold">Rapide</span>
                <span class="px-3 py-1 bg-blue-100 text-blue-600 rounded-full text-xs font-semibold">Simple</span>
            </div>
        </div>

        <!-- Feature 2 -->
        <div class="bg-white rounded-3xl shadow-xl p-8 text-center card-hover border border-gray-100 animate-fadeInUp opacity-0 delay-200">
            <div class="relative mb-6">
                <div class="absolute inset-0 bg-gradient-to-r from-green-400 to-emerald-600 rounded-full blur-2xl opacity-30 animate-pulse-slow"></div>
                <div class="relative w-20 h-20 bg-gradient-to-r from-green-400 to-emerald-600 rounded-2xl flex items-center justify-center mx-auto shadow-2xl transform -rotate-6 hover:rotate-0 transition-transform duration-300">
                    <i class="fas fa-user-md text-white text-3xl"></i>
                </div>
            </div>
            <h3 class="text-2xl font-bold text-gray-800 mb-4">Médecins Qualifiés</h3>
            <p class="text-gray-600 leading-relaxed">
                Accédez à des médecins expérimentés dans différents départements : 
                cardiologie, dermatologie, pédiatrie, et bien plus.
            </p>
            <div class="mt-6 flex justify-center gap-2">
                <span class="px-3 py-1 bg-green-100 text-green-600 rounded-full text-xs font-semibold">Experts</span>
                <span class="px-3 py-1 bg-green-100 text-green-600 rounded-full text-xs font-semibold">Certifiés</span>
            </div>
        </div>

        <!-- Feature 3 -->
        <div class="bg-white rounded-3xl shadow-xl p-8 text-center card-hover border border-gray-100 animate-fadeInUp opacity-0 delay-300">
            <div class="relative mb-6">
                <div class="absolute inset-0 bg-gradient-to-r from-purple-400 to-pink-600 rounded-full blur-2xl opacity-30 animate-pulse-slow"></div>
                <div class="relative w-20 h-20 bg-gradient-to-r from-purple-400 to-pink-600 rounded-2xl flex items-center justify-center mx-auto shadow-2xl transform rotate-6 hover:rotate-0 transition-transform duration-300">
                    <i class="fas fa-file-medical text-white text-3xl"></i>
                </div>
            </div>
            <h3 class="text-2xl font-bold text-gray-800 mb-4">Dossier Médical</h3>
            <p class="text-gray-600 leading-relaxed">
                Consultez votre historique de consultations et vos comptes rendus 
                médicaux à tout moment, en toute sécurité.
            </p>
            <div class="mt-6 flex justify-center gap-2">
                <span class="px-3 py-1 bg-purple-100 text-purple-600 rounded-full text-xs font-semibold">Sécurisé</span>
                <span class="px-3 py-1 bg-purple-100 text-purple-600 rounded-full text-xs font-semibold">Accessible</span>
            </div>
        </div>
    </div>
</div>

<!-- Services Section -->
<div class="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 py-20 gradient-animate relative overflow-hidden">
    <!-- Decorative Elements -->
    <div class="absolute top-0 left-0 w-full h-full opacity-10">
        <div class="absolute top-10 left-10 w-40 h-40 bg-white rounded-full"></div>
        <div class="absolute bottom-10 right-10 w-60 h-60 bg-white rounded-full"></div>
        <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-80 h-80 bg-white rounded-full"></div>
    </div>

    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center text-white mb-16">
            <h2 class="text-5xl font-bold mb-4 animate-fadeInUp opacity-0">
                Nos Services Médicaux
            </h2>
            <p class="text-xl text-blue-100 max-w-3xl mx-auto animate-fadeInUp opacity-0 delay-100">
                Des départements spécialisés pour répondre à tous vos besoins de santé
            </p>
        </div>

        <div class="grid md:grid-cols-4 gap-6">
            <div class="glass-effect rounded-2xl p-6 text-white text-center hover:bg-white/20 transition-all duration-300 transform hover:scale-105 animate-fadeInUp opacity-0 delay-100">
                <i class="fas fa-heartbeat text-4xl mb-4"></i>
                <h4 class="font-bold text-lg mb-2">Cardiologie</h4>
                <p class="text-sm text-blue-100">Soins du cœur</p>
            </div>
            <div class="glass-effect rounded-2xl p-6 text-white text-center hover:bg-white/20 transition-all duration-300 transform hover:scale-105 animate-fadeInUp opacity-0 delay-200">
                <i class="fas fa-brain text-4xl mb-4"></i>
                <h4 class="font-bold text-lg mb-2">Neurologie</h4>
                <p class="text-sm text-blue-100">Santé cérébrale</p>
            </div>
            <div class="glass-effect rounded-2xl p-6 text-white text-center hover:bg-white/20 transition-all duration-300 transform hover:scale-105 animate-fadeInUp opacity-0 delay-300">
                <i class="fas fa-baby text-4xl mb-4"></i>
                <h4 class="font-bold text-lg mb-2">Pédiatrie</h4>
                <p class="text-sm text-blue-100">Soins enfants</p>
            </div>
            <div class="glass-effect rounded-2xl p-6 text-white text-center hover:bg-white/20 transition-all duration-300 transform hover:scale-105 animate-fadeInUp opacity-0 delay-400">
                <i class="fas fa-hand-holding-medical text-4xl mb-4"></i>
                <h4 class="font-bold text-lg mb-2">Dermatologie</h4>
                <p class="text-sm text-blue-100">Soins de la peau</p>
            </div>
        </div>
    </div>
</div>

<!-- How It Works Section -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
    <div class="text-center mb-16">
        <h2 class="text-5xl font-bold text-gray-900 mb-4">
            Comment ça <span class="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">fonctionne ?</span>
        </h2>
        <p class="text-xl text-gray-600 max-w-2xl mx-auto">
            Trois étapes simples pour prendre soin de votre santé
        </p>
    </div>

    <div class="grid md:grid-cols-3 gap-8">
        <!-- Step 1 -->
        <div class="relative">
            <div class="bg-gradient-to-br from-blue-50 to-blue-100 rounded-3xl p-8 card-hover border-2 border-blue-200 animate-fadeInUp opacity-0">
                <div class="absolute -top-6 -left-6 w-16 h-16 bg-gradient-to-r from-blue-600 to-blue-400 rounded-2xl flex items-center justify-center text-white text-2xl font-bold shadow-2xl">
                    1
                </div>
                <div class="mt-4">
                    <i class="fas fa-user-plus text-blue-600 text-5xl mb-6 block"></i>
                    <h3 class="text-2xl font-bold text-gray-800 mb-4">Créez votre compte</h3>
                    <p class="text-gray-600 leading-relaxed">
                        Inscrivez-vous gratuitement en quelques secondes. Remplissez vos informations médicales de base.
                    </p>
                </div>
            </div>
        </div>

        <!-- Step 2 -->
        <div class="relative">
            <div class="bg-gradient-to-br from-purple-50 to-purple-100 rounded-3xl p-8 card-hover border-2 border-purple-200 animate-fadeInUp opacity-0 delay-200">
                <div class="absolute -top-6 -left-6 w-16 h-16 bg-gradient-to-r from-purple-600 to-purple-400 rounded-2xl flex items-center justify-center text-white text-2xl font-bold shadow-2xl">
                    2
                </div>
                <div class="mt-4">
                    <i class="fas fa-calendar-alt text-purple-600 text-5xl mb-6 block"></i>
                    <h3 class="text-2xl font-bold text-gray-800 mb-4">Réservez un RDV</h3>
                    <p class="text-gray-600 leading-relaxed">
                        Choisissez votre médecin, sélectionnez la date et l'heure qui vous conviennent le mieux.
                    </p>
                </div>
            </div>
        </div>

        <!-- Step 3 -->
        <div class="relative">
            <div class="bg-gradient-to-br from-pink-50 to-pink-100 rounded-3xl p-8 card-hover border-2 border-pink-200 animate-fadeInUp opacity-0 delay-400">
                <div class="absolute -top-6 -left-6 w-16 h-16 bg-gradient-to-r from-pink-600 to-pink-400 rounded-2xl flex items-center justify-center text-white text-2xl font-bold shadow-2xl">
                    3
                </div>
                <div class="mt-4">
                    <i class="fas fa-check-circle text-pink-600 text-5xl mb-6 block"></i>
                    <h3 class="text-2xl font-bold text-gray-800 mb-4">Consultez votre médecin</h3>
                    <p class="text-gray-600 leading-relaxed">
                        Présentez-vous à votre rendez-vous et recevez votre compte rendu médical en ligne.
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- CTA Section -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
    <div class="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 rounded-3xl shadow-2xl p-12 text-center gradient-animate overflow-hidden relative">
        <div class="absolute inset-0 bg-black/10"></div>
        <div class="relative z-10">
            <h2 class="text-4xl md:text-5xl font-bold text-white mb-6 animate-fadeInUp opacity-0">
                Prêt à prendre soin de votre santé ?
            </h2>
            <p class="text-xl text-blue-100 mb-8 max-w-2xl mx-auto animate-fadeInUp opacity-0 delay-100">
                Rejoignez des centaines de patients satisfaits et gérez votre santé en toute simplicité
            </p>
            <a href="${pageContext.request.contextPath}/register"
               class="inline-block px-12 py-5 bg-white text-blue-600 rounded-2xl text-lg font-bold hover:bg-gray-100 transition-all duration-300 shadow-2xl hover:shadow-white/50 transform hover:scale-110 animate-fadeInUp opacity-0 delay-200">
                <i class="fas fa-rocket mr-2"></i>
                Créer mon compte gratuitement
                <i class="fas fa-arrow-right ml-2"></i>
            </a>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="bg-gradient-to-r from-gray-900 via-gray-800 to-gray-900 text-white py-12">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid md:grid-cols-4 gap-8 mb-8">
            <!-- About -->
            <div class="animate-fadeInUp opacity-0">
                <div class="flex items-center mb-4">
                    <div class="w-10 h-10 bg-gradient-to-r from-blue-600 to-purple-600 rounded-lg flex items-center justify-center mr-3">
                        <i class="fas fa-heartbeat text-white text-xl"></i>
                    </div>
                    <h3 class="text-xl font-bold">Hôpital Numérique</h3>
                </div>
                <p class="text-gray-400 text-sm leading-relaxed">
                    Votre plateforme de santé digitale pour une gestion simplifiée de vos consultations médicales.
                </p>
            </div>

            <!-- Quick Links -->
            <div class="animate-fadeInUp opacity-0 delay-100">
                <h4 class="text-lg font-bold mb-4">Liens Rapides</h4>
                <ul class="space-y-2 text-gray-400 text-sm">
                    <li><a href="#" class="hover:text-blue-400 transition-colors"><i class="fas fa-chevron-right text-xs mr-2"></i>Accueil</a></li>
                    <li><a href="#features" class="hover:text-blue-400 transition-colors"><i class="fas fa-chevron-right text-xs mr-2"></i>Services</a></li>
                    <li><a href="${pageContext.request.contextPath}/login" class="hover:text-blue-400 transition-colors"><i class="fas fa-chevron-right text-xs mr-2"></i>Connexion</a></li>
                    <li><a href="${pageContext.request.contextPath}/register" class="hover:text-blue-400 transition-colors"><i class="fas fa-chevron-right text-xs mr-2"></i>Inscription</a></li>
                </ul>
            </div>

            <!-- Services -->
            <div class="animate-fadeInUp opacity-0 delay-200">
                <h4 class="text-lg font-bold mb-4">Nos Services</h4>
                <ul class="space-y-2 text-gray-400 text-sm">
                    <li><i class="fas fa-check text-blue-400 mr-2"></i>Consultations en ligne</li>
                    <li><i class="fas fa-check text-blue-400 mr-2"></i>Suivi médical</li>
                    <li><i class="fas fa-check text-blue-400 mr-2"></i>Dossier médical</li>
                    <li><i class="fas fa-check text-blue-400 mr-2"></i>Médecins experts</li>
                </ul>
            </div>

            <!-- Contact -->
            <div class="animate-fadeInUp opacity-0 delay-300">
                <h4 class="text-lg font-bold mb-4">Contact</h4>
                <ul class="space-y-3 text-gray-400 text-sm">
                    <li class="flex items-center">
                        <i class="fas fa-phone text-blue-400 mr-3"></i>
                        <span>+212 5 22 00 00 00</span>
                    </li>
                    <li class="flex items-center">
                        <i class="fas fa-envelope text-blue-400 mr-3"></i>
                        <span>contact@hopital.ma</span>
                    </li>
                    <li class="flex items-center">
                        <i class="fas fa-map-marker-alt text-blue-400 mr-3"></i>
                        <span>Casablanca, Maroc</span>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Bottom Footer -->
        <div class="border-t border-gray-700 pt-8 mt-8">
            <div class="flex flex-col md:flex-row justify-between items-center">
                <p class="text-gray-400 text-sm mb-4 md:mb-0">
                    &copy; 2025 Hôpital Numérique. Tous droits réservés.
                    Développé avec <i class="fas fa-heart text-red-500 animate-pulse"></i> par 
                    <span class="text-blue-400 font-semibold">Othman Aboussebaba</span>
                </p>
                <div class="flex space-x-4">
                    <a href="#" class="w-10 h-10 bg-gray-700 rounded-full flex items-center justify-center hover:bg-blue-600 transition-all duration-300 transform hover:scale-110">
                        <i class="fab fa-facebook-f"></i>
                    </a>
                    <a href="#" class="w-10 h-10 bg-gray-700 rounded-full flex items-center justify-center hover:bg-blue-400 transition-all duration-300 transform hover:scale-110">
                        <i class="fab fa-twitter"></i>
                    </a>
                    <a href="#" class="w-10 h-10 bg-gray-700 rounded-full flex items-center justify-center hover:bg-pink-600 transition-all duration-300 transform hover:scale-110">
                        <i class="fab fa-instagram"></i>
                    </a>
                    <a href="#" class="w-10 h-10 bg-gray-700 rounded-full flex items-center justify-center hover:bg-blue-700 transition-all duration-300 transform hover:scale-110">
                        <i class="fab fa-linkedin-in"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- Scroll to Top Button -->
<button id="scrollToTop" 
        class="fixed bottom-8 right-8 w-14 h-14 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-full shadow-2xl hover:shadow-blue-500/50 transition-all duration-300 transform hover:scale-110 opacity-0 pointer-events-none z-50">
    <i class="fas fa-arrow-up"></i>
</button>

<script>
    // Scroll to top functionality
    const scrollToTopBtn = document.getElementById('scrollToTop');
    
    window.addEventListener('scroll', () => {
        if (window.pageYOffset > 300) {
            scrollToTopBtn.style.opacity = '1';
            scrollToTopBtn.style.pointerEvents = 'auto';
        } else {
            scrollToTopBtn.style.opacity = '0';
            scrollToTopBtn.style.pointerEvents = 'none';
        }
    });
    
    scrollToTopBtn.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });

    // Animate elements on scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.animate-fadeInUp, .animate-fadeInDown, .animate-slideInLeft, .animate-slideInRight').forEach(el => {
        observer.observe(el);
    });

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
</script>

</body>
</html>