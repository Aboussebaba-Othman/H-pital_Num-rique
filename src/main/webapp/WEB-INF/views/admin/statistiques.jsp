<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {},
            }
        }
    </script>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes slideIn {
            from { transform: translateX(-20px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        .fade-in { animation: fadeIn 0.6s ease-out; }
        .slide-in { animation: slideIn 0.5s ease-out; }
        .hover-lift { transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .hover-lift:hover { transform: translateY(-5px); box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); }
        .stat-card { background: linear-gradient(135deg, var(--tw-gradient-from) 0%, var(--tw-gradient-to) 100%); }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100">

<%@ include file="../common/admin-nav.jsp" %>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header Premium -->
    <div class="mb-10 fade-in">
        <div class="flex items-center justify-between">
            <div>
                <div class="flex items-center space-x-3 mb-2">
                    <div class="w-12 h-12 bg-gradient-to-br from-pink-500 to-purple-600 rounded-xl flex items-center justify-center shadow-lg">
                        <i class="fas fa-chart-line text-white text-xl"></i>
                    </div>
                    <h1 class="text-4xl font-bold text-gray-900">
                        Tableau de Bord Analytics
                    </h1>
                </div>
                <p class="text-gray-600 text-lg ml-15">Vue d'ensemble des performances de la clinique</p>
            </div>
            <div class="hidden md:flex items-center space-x-4">
                <div class="text-right">
                    <p class="text-sm text-gray-500">Dernière mise à jour</p>
                    <p class="text-sm font-semibold text-gray-900">
                        <jsp:useBean id="now" class="java.util.Date"/>
                        <fmt:formatDate value="${now}" pattern="dd/MM/yyyy HH:mm"/>
                    </p>
                </div>
                <button onclick="window.location.reload()"
                        class="px-4 py-2 bg-white rounded-lg shadow hover:shadow-md transition flex items-center space-x-2">
                    <i class="fas fa-sync-alt text-indigo-600"></i>
                    <span class="text-sm font-medium">Actualiser</span>
                </button>
            </div>
        </div>
    </div>

    <!-- KPI Cards - Statistiques principales -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-10 fade-in">

        <!-- Total Patients -->
        <div class="stat-card from-blue-500 to-blue-600 rounded-2xl shadow-xl p-6 text-white hover-lift overflow-hidden relative">
            <div class="absolute top-0 right-0 opacity-10">
                <i class="fas fa-users" style="font-size: 120px;"></i>
            </div>
            <div class="relative z-10">
                <div class="flex items-center justify-between mb-4">
                    <div class="w-14 h-14 bg-white bg-opacity-20 rounded-xl flex items-center justify-center backdrop-blur-sm">
                        <i class="fas fa-users text-2xl"></i>
                    </div>
                    <span class="px-3 py-1 bg-white bg-opacity-20 rounded-full text-xs font-semibold backdrop-blur-sm">
                        Actifs
                    </span>
                </div>
                <p class="text-blue-100 text-sm font-medium mb-1">Total Patients</p>
                <p class="text-5xl font-bold mb-2">${totalPatients}</p>
                <div class="flex items-center text-blue-100 text-sm">
                    <i class="fas fa-arrow-up mr-2"></i>
                    <span>Base de données complète</span>
                </div>
            </div>
        </div>

        <!-- Total Docteurs -->
        <div class="stat-card from-emerald-500 to-green-600 rounded-2xl shadow-xl p-6 text-white hover-lift overflow-hidden relative">
            <div class="absolute top-0 right-0 opacity-10">
                <i class="fas fa-user-md" style="font-size: 120px;"></i>
            </div>
            <div class="relative z-10">
                <div class="flex items-center justify-between mb-4">
                    <div class="w-14 h-14 bg-white bg-opacity-20 rounded-xl flex items-center justify-center backdrop-blur-sm">
                        <i class="fas fa-user-md text-2xl"></i>
                    </div>
                    <span class="px-3 py-1 bg-white bg-opacity-20 rounded-full text-xs font-semibold backdrop-blur-sm">
                        Personnel
                    </span>
                </div>
                <p class="text-green-100 text-sm font-medium mb-1">Total Docteurs</p>
                <p class="text-5xl font-bold mb-2">${totalDocteurs}</p>
                <div class="flex items-center text-green-100 text-sm">
                    <i class="fas fa-stethoscope mr-2"></i>
                    <span>Corps médical qualifié</span>
                </div>
            </div>
        </div>

        <!-- Total Consultations -->
        <div class="stat-card from-violet-500 to-purple-600 rounded-2xl shadow-xl p-6 text-white hover-lift overflow-hidden relative">
            <div class="absolute top-0 right-0 opacity-10">
                <i class="fas fa-calendar-check" style="font-size: 120px;"></i>
            </div>
            <div class="relative z-10">
                <div class="flex items-center justify-between mb-4">
                    <div class="w-14 h-14 bg-white bg-opacity-20 rounded-xl flex items-center justify-center backdrop-blur-sm">
                        <i class="fas fa-calendar-check text-2xl"></i>
                    </div>
                    <span class="px-3 py-1 bg-white bg-opacity-20 rounded-full text-xs font-semibold backdrop-blur-sm">
                        Total
                    </span>
                </div>
                <p class="text-purple-100 text-sm font-medium mb-1">Total Consultations</p>
                <p class="text-5xl font-bold mb-2">${totalConsultations}</p>
                <div class="flex items-center text-purple-100 text-sm">
                    <i class="fas fa-chart-line mr-2"></i>
                    <span>Activité globale</span>
                </div>
            </div>
        </div>

        <!-- Taux d'annulation -->
        <div class="stat-card ${tauxAnnulation < 10 ? 'from-emerald-500 to-green-600' : tauxAnnulation < 20 ? 'from-orange-500 to-amber-600' : 'from-red-500 to-red-600'} rounded-2xl shadow-xl p-6 text-white hover-lift overflow-hidden relative">
            <div class="absolute top-0 right-0 opacity-10">
                <i class="fas fa-chart-pie" style="font-size: 120px;"></i>
            </div>
            <div class="relative z-10">
                <div class="flex items-center justify-between mb-4">
                    <div class="w-14 h-14 bg-white bg-opacity-20 rounded-xl flex items-center justify-center backdrop-blur-sm">
                        <i class="fas ${tauxAnnulation < 10 ? 'fa-check-circle' : 'fa-exclamation-triangle'} text-2xl"></i>
                    </div>
                    <span class="px-3 py-1 bg-white bg-opacity-20 rounded-full text-xs font-semibold backdrop-blur-sm">
                        ${tauxAnnulation < 10 ? 'Excellent' : tauxAnnulation < 20 ? 'Bon' : 'Attention'}
                    </span>
                </div>
                <p class="text-white text-opacity-90 text-sm font-medium mb-1">Taux d'Annulation</p>
                <p class="text-5xl font-bold mb-2">${tauxAnnulation}%</p>
                <div class="flex items-center text-white text-opacity-90 text-sm">
                    <i class="fas ${tauxAnnulation < 10 ? 'fa-arrow-down' : 'fa-arrow-up'} mr-2"></i>
                    <span>${annulees} annulations</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Graphiques Analytics -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-10 fade-in">

        <!-- Graphique Donut - Répartition -->
        <div class="bg-white rounded-2xl shadow-lg p-8 hover-lift">
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h3 class="text-xl font-bold text-gray-900 flex items-center">
                        <div class="w-10 h-10 bg-pink-100 rounded-lg flex items-center justify-center mr-3">
                            <i class="fas fa-chart-pie text-pink-600"></i>
                        </div>
                        Répartition par Statut
                    </h3>
                    <p class="text-sm text-gray-500 mt-1 ml-13">Distribution des consultations</p>
                </div>
            </div>
            <div style="height: 300px;">
                <canvas id="statutChart"></canvas>
            </div>
        </div>

        <!-- Graphique Ligne - Évolution -->
        <div class="bg-white rounded-2xl shadow-lg p-8 hover-lift">
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h3 class="text-xl font-bold text-gray-900 flex items-center">
                        <div class="w-10 h-10 bg-indigo-100 rounded-lg flex items-center justify-center mr-3">
                            <i class="fas fa-chart-line text-indigo-600"></i>
                        </div>
                        Évolution Mensuelle
                    </h3>
                    <p class="text-sm text-gray-500 mt-1 ml-13">Tendance des 6 derniers mois</p>
                </div>
            </div>
            <div style="height: 300px;">
                <canvas id="monthChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Top Docteurs & Départements -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-10 fade-in">

        <!-- Top 5 Docteurs -->
        <div class="bg-white rounded-2xl shadow-lg p-8 hover-lift">
            <div class="flex items-center justify-between mb-6">
                <h3 class="text-xl font-bold text-gray-900 flex items-center">
                    <div class="w-10 h-10 bg-yellow-100 rounded-lg flex items-center justify-center mr-3">
                        <i class="fas fa-trophy text-yellow-600"></i>
                    </div>
                    Top 5 Docteurs
                </h3>
                <span class="text-xs font-semibold text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
                    Par consultations
                </span>
            </div>
            <div class="space-y-5">
                <c:forEach var="entry" items="${topDocteurs}" varStatus="status">
                    <div class="flex items-center slide-in" style="animation-delay: ${status.index * 0.1}s;">
                        <div class="relative">
                            <div class="w-12 h-12 rounded-xl flex items-center justify-center font-bold text-white shadow-md
                                ${status.index == 0 ? 'bg-gradient-to-br from-yellow-400 to-yellow-600' :
                                  status.index == 1 ? 'bg-gradient-to-br from-gray-300 to-gray-500' :
                                  status.index == 2 ? 'bg-gradient-to-br from-amber-500 to-amber-700' :
                                  'bg-gradient-to-br from-indigo-400 to-indigo-600'}">
                                    ${status.index + 1}
                            </div>
                            <c:if test="${status.index < 3}">
                                <div class="absolute -top-1 -right-1 w-5 h-5 bg-white rounded-full flex items-center justify-center shadow">
                                    <i class="fas fa-crown text-xs text-yellow-500"></i>
                                </div>
                            </c:if>
                        </div>
                        <div class="ml-4 flex-1">
                            <div class="flex items-center justify-between mb-2">
                                <span class="font-semibold text-gray-900">${entry.key}</span>
                                <span class="text-sm font-bold text-indigo-600 bg-indigo-50 px-3 py-1 rounded-lg">
                                    ${entry.value} <span class="text-xs font-normal">consultations</span>
                                </span>
                            </div>
                            <div class="w-full bg-gray-100 rounded-full h-2.5 overflow-hidden">
                                <c:set var="maxValue" value="${topDocteurs[0].value}"/>
                                <c:set var="percentage" value="${(entry.value * 100.0) / maxValue}"/>
                                <div class="bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 h-2.5 rounded-full transition-all duration-1000 shadow-sm"
                                     style="width: ${percentage}%"></div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Départements -->
        <div class="bg-white rounded-2xl shadow-lg p-8 hover-lift">
            <div class="flex items-center justify-between mb-6">
                <h3 class="text-xl font-bold text-gray-900 flex items-center">
                    <div class="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center mr-3">
                        <i class="fas fa-building text-purple-600"></i>
                    </div>
                    Départements
                </h3>
                <span class="text-xs font-semibold text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
                    ${departementStats.size()} total
                </span>
            </div>
            <div class="space-y-3">
                <c:forEach var="entry" items="${departementStats}" varStatus="status">
                    <div class="flex items-center justify-between p-4 bg-gradient-to-r from-purple-50 to-indigo-50 rounded-xl hover:shadow-md transition-all slide-in"
                         style="animation-delay: ${status.index * 0.1}s;">
                        <div class="flex items-center">
                            <div class="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center mr-3">
                                <i class="fas fa-hospital text-purple-600"></i>
                            </div>
                            <span class="font-semibold text-gray-900">${entry.key}</span>
                        </div>
                        <div class="flex items-center space-x-2">
                            <span class="text-2xl font-bold text-purple-600">${entry.value}</span>
                            <span class="text-xs text-gray-500">docteur(s)</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Occupation & Résumé -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-10 fade-in">

        <!-- Occupation des Salles -->
        <div class="bg-white rounded-2xl shadow-lg p-8 hover-lift">
            <h3 class="text-xl font-bold text-gray-900 mb-6 flex items-center">
                <div class="w-10 h-10 bg-orange-100 rounded-lg flex items-center justify-center mr-3">
                    <i class="fas fa-door-open text-orange-600"></i>
                </div>
                Occupation Salles
            </h3>
            <div class="flex flex-col items-center justify-center py-8">
                <div class="relative inline-flex items-center justify-center mb-6">
                    <svg class="w-40 h-40 transform -rotate-90">
                        <circle cx="80" cy="80" r="70" fill="none" stroke="#f3f4f6" stroke-width="12"/>
                        <circle cx="80" cy="80" r="70" fill="none" stroke="url(#gradient)" stroke-width="12"
                                stroke-dasharray="${tauxOccupationMoyen * 4.4} 440"
                                stroke-linecap="round" class="transition-all duration-1000"/>
                        <defs>
                            <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="100%">
                                <stop offset="0%" style="stop-color:#f97316;stop-opacity:1" />
                                <stop offset="100%" style="stop-color:#ea580c;stop-opacity:1" />
                            </linearGradient>
                        </defs>
                    </svg>
                    <div class="absolute flex flex-col items-center">
                        <p class="text-4xl font-bold text-gray-900">${tauxOccupationMoyen}%</p>
                        <p class="text-xs text-gray-500 mt-1">Occupation</p>
                    </div>
                </div>
                <div class="text-center">
                    <p class="text-sm text-gray-600">Taux d'Occupation Moyen</p>
                    <p class="text-xs text-gray-400 mt-1">${totalSalles} salles disponibles</p>
                </div>
            </div>
        </div>

        <!-- Résumé Consultations -->
        <div class="lg:col-span-2 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-2xl shadow-xl p-8 text-white hover-lift">
            <h3 class="text-2xl font-bold mb-6 flex items-center">
                <div class="w-10 h-10 bg-white bg-opacity-20 rounded-lg flex items-center justify-center mr-3 backdrop-blur-sm">
                    <i class="fas fa-list-check"></i>
                </div>
                Résumé des Consultations
            </h3>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div class="bg-white bg-opacity-10 backdrop-blur-sm rounded-xl p-5 hover:bg-opacity-20 transition">
                    <div class="w-12 h-12 bg-yellow-400 rounded-lg flex items-center justify-center mb-3 shadow-lg">
                        <i class="fas fa-hourglass-half text-white text-xl"></i>
                    </div>
                    <p class="text-3xl font-bold mb-1">${reservees}</p>
                    <p class="text-sm opacity-90">Réservées</p>
                </div>
                <div class="bg-white bg-opacity-10 backdrop-blur-sm rounded-xl p-5 hover:bg-opacity-20 transition">
                    <div class="w-12 h-12 bg-green-400 rounded-lg flex items-center justify-center mb-3 shadow-lg">
                        <i class="fas fa-check-circle text-white text-xl"></i>
                    </div>
                    <p class="text-3xl font-bold mb-1">${validees}</p>
                    <p class="text-sm opacity-90">Validées</p>
                </div>
                <div class="bg-white bg-opacity-10 backdrop-blur-sm rounded-xl p-5 hover:bg-opacity-20 transition">
                    <div class="w-12 h-12 bg-blue-400 rounded-lg flex items-center justify-center mb-3 shadow-lg">
                        <i class="fas fa-flag-checkered text-white text-xl"></i>
                    </div>
                    <p class="text-3xl font-bold mb-1">${terminees}</p>
                    <p class="text-sm opacity-90">Terminées</p>
                </div>
                <div class="bg-white bg-opacity-10 backdrop-blur-sm rounded-xl p-5 hover:bg-opacity-20 transition">
                    <div class="w-12 h-12 bg-red-400 rounded-lg flex items-center justify-center mb-3 shadow-lg">
                        <i class="fas fa-times-circle text-white text-xl"></i>
                    </div>
                    <p class="text-3xl font-bold mb-1">${annulees}</p>
                    <p class="text-sm opacity-90">Annulées</p>
                </div>
            </div>
        </div>
    </div>

</div>

<script>
    // Configuration commune pour les graphiques
    Chart.defaults.font.family = 'Inter, system-ui, -apple-system, sans-serif';
    Chart.defaults.color = '#6b7280';

    // Graphique Donut - Répartition par statut
    const statutCtx = document.getElementById('statutChart').getContext('2d');
    new Chart(statutCtx, {
        type: 'doughnut',
        data: {
            labels: [
                <c:forEach var="entry" items="${repartitionStatuts}" varStatus="status">
                '${entry.key}'${!status.last ? ',' : ''}
                </c:forEach>
            ],
            datasets: [{
                data: [
                    <c:forEach var="entry" items="${repartitionStatuts}" varStatus="status">
                    ${entry.value}${!status.last ? ',' : ''}
                    </c:forEach>
                ],
                backgroundColor: [
                    'rgba(251, 191, 36, 0.8)',
                    'rgba(16, 185, 129, 0.8)',
                    'rgba(59, 130, 246, 0.8)',
                    'rgba(239, 68, 68, 0.8)'
                ],
                borderColor: '#fff',
                borderWidth: 3,
                hoverOffset: 15
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 20,
                        font: { size: 13, weight: '600' },
                        usePointStyle: true,
                        pointStyle: 'circle'
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 12,
                    titleFont: { size: 14, weight: 'bold' },
                    bodyFont: { size: 13 },
                    cornerRadius: 8
                }
            },
            cutout: '65%'
        }
    });

    // Graphique Ligne - Consultations par mois
    const monthCtx = document.getElementById('monthChart').getContext('2d');
    const gradient = monthCtx.createLinearGradient(0, 0, 0, 300);
    gradient.addColorStop(0, 'rgba(99, 102, 241, 0.2)');
    gradient.addColorStop(1, 'rgba(99, 102, 241, 0)');

    new Chart(monthCtx, {
        type: 'line',
        data: {
            labels: [
                <c:forEach var="entry" items="${consultationsParMois}" varStatus="status">
                '${entry.key}'${!status.last ? ',' : ''}
                </c:forEach>
            ],
            datasets: [{
                label: 'Consultations',
                data: [
                    <c:forEach var="entry" items="${consultationsParMois}" varStatus="status">
                    ${entry.value}${!status.last ? ',' : ''}
                    </c:forEach>
                ],
                borderColor: '#6366f1',
                backgroundColor: gradient,
                borderWidth: 3,
                tension: 0.4,
                fill: true,
                pointRadius: 6,
                pointHoverRadius: 8,
                pointBackgroundColor: '#fff',
                pointBorderColor: '#6366f1',
                pointBorderWidth: 3,
                pointHoverBackgroundColor: '#6366f1',
                pointHoverBorderColor: '#fff'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                intersect: false,
                mode: 'index'
            },
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 12,
                    titleFont: { size: 14, weight: 'bold' },
                    bodyFont: { size: 13 },
                    cornerRadius: 8
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1,
                        font: { size: 12, weight: '500' }
                    },
                    grid: {
                        color: 'rgba(0, 0, 0, 0.05)',
                        drawBorder: false
                    }
                },
                x: {
                    ticks: {
                        font: { size: 12, weight: '500' }
                    },
                    grid: {
                        display: false
                    }
                }
            }
        }
    });
</script>

</body>
</html>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">
            <i class="fas fa-chart-pie text-pink-600 mr-3"></i>
            Statistiques et Rapports
        </h1>
        <p class="text-gray-600 mt-1">Vue d'ensemble des performances de la clinique</p>
    </div>

    <!-- Statistiques principales -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Total Patients -->
        <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl shadow-lg p-6 text-white">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <p class="text-blue-100 text-sm mb-1">Total Patients</p>
                    <p class="text-4xl font-bold">${totalPatients}</p>
                </div>
                <div class="w-16 h-16 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                    <i class="fas fa-users text-3xl"></i>
                </div>
            </div>
        </div>

        <!-- Total Docteurs -->
        <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-xl shadow-lg p-6 text-white">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <p class="text-green-100 text-sm mb-1">Total Docteurs</p>
                    <p class="text-4xl font-bold">${totalDocteurs}</p>
                </div>
                <div class="w-16 h-16 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                    <i class="fas fa-user-md text-3xl"></i>
                </div>
            </div>
        </div>

        <!-- Total Consultations -->
        <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl shadow-lg p-6 text-white">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <p class="text-purple-100 text-sm mb-1">Total Consultations</p>
                    <p class="text-4xl font-bold">${totalConsultations}</p>
                </div>
                <div class="w-16 h-16 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                    <i class="fas fa-calendar-check text-3xl"></i>
                </div>
            </div>
        </div>

        <!-- Taux d'annulation -->
        <div class="bg-gradient-to-br from-red-500 to-red-600 rounded-xl shadow-lg p-6 text-white">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <p class="text-red-100 text-sm mb-1">Taux d'Annulation</p>
                    <p class="text-4xl font-bold">${tauxAnnulation}%</p>
                </div>
                <div class="w-16 h-16 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                    <i class="fas fa-times-circle text-3xl"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Graphiques principaux -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">

        <!-- Répartition des consultations par statut -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <h3 class="text-lg font-bold text-gray-900 mb-4">
                <i class="fas fa-chart-pie text-pink-600 mr-2"></i>
                Répartition par Statut
            </h3>
            <canvas id="statutChart" height="250"></canvas>
        </div>

        <!-- Consultations par mois -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <h3 class="text-lg font-bold text-gray-900 mb-4">
                <i class="fas fa-chart-line text-indigo-600 mr-2"></i>
                Évolution sur 6 Mois
            </h3>
            <canvas id="monthChart" height="250"></canvas>
        </div>
    </div>

    <!-- Top 5 Docteurs -->
    <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
        <h3 class="text-xl font-bold text-gray-900 mb-6">
            <i class="fas fa-trophy text-yellow-500 mr-2"></i>
            Top 5 Docteurs (par nombre de consultations)
        </h3>
        <div class="space-y-4">
            <c:forEach var="entry" items="${topDocteurs}" varStatus="status">
                <div class="flex items-center">
                    <div class="w-8 h-8 rounded-full flex items-center justify-center font-bold text-white
                        ${status.index == 0 ? 'bg-yellow-500' :
                          status.index == 1 ? 'bg-gray-400' :
                          status.index == 2 ? 'bg-amber-600' : 'bg-blue-500'}">
                            ${status.index + 1}
                    </div>
                    <div class="ml-4 flex-1">
                        <div class="flex items-center justify-between">
                            <span class="font-medium text-gray-900">${entry.key}</span>
                            <span class="text-sm font-bold text-indigo-600">${entry.value} consultations</span>
                        </div>
                        <div class="mt-1 w-full bg-gray-200 rounded-full h-2">
                            <c:set var="maxValue" value="${topDocteurs[0].value}"/>
                            <c:set var="percentage" value="${(entry.value * 100.0) / maxValue}"/>
                            <div class="bg-gradient-to-r from-indigo-500 to-purple-500 h-2 rounded-full transition-all duration-500"
                                 style="width: ${percentage}%"></div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Statistiques par département -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">

        <!-- Départements -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <h3 class="text-xl font-bold text-gray-900 mb-6">
                <i class="fas fa-building text-purple-600 mr-2"></i>
                Docteurs par Département
            </h3>
            <div class="space-y-3">
                <c:forEach var="entry" items="${departementStats}">
                    <div class="flex items-center justify-between p-3 bg-purple-50 rounded-lg">
                        <span class="font-medium text-gray-900">${entry.key}</span>
                        <span class="px-3 py-1 bg-purple-600 text-white rounded-full text-sm font-bold">
                            ${entry.value} docteur(s)
                        </span>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Taux d'occupation salles -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <h3 class="text-xl font-bold text-gray-900 mb-6">
                <i class="fas fa-door-open text-orange-600 mr-2"></i>
                Occupation des Salles
            </h3>
            <div class="flex items-center justify-center h-48">
                <div class="text-center">
                    <div class="relative inline-flex items-center justify-center">
                        <svg class="w-32 h-32">
                            <circle cx="64" cy="64" r="56" fill="none" stroke="#e5e7eb" stroke-width="8"/>
                            <circle cx="64" cy="64" r="56" fill="none" stroke="#f97316" stroke-width="8"
                                    stroke-dasharray="${tauxOccupationMoyen * 3.52} 352"
                                    stroke-linecap="round" transform="rotate(-90 64 64)"/>
                        </svg>
                        <div class="absolute">
                            <p class="text-3xl font-bold text-gray-900">${tauxOccupationMoyen}%</p>
                        </div>
                    </div>
                    <p class="mt-4 text-sm text-gray-600">Taux d'Occupation Moyen</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Résumé des consultations -->
    <div class="bg-white rounded-xl shadow-lg p-6">
        <h3 class="text-xl font-bold text-gray-900 mb-6">
            <i class="fas fa-list-check text-indigo-600 mr-2"></i>
            Résumé des Consultations
        </h3>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
            <div class="text-center p-4 bg-yellow-50 rounded-lg border-2 border-yellow-200">
                <i class="fas fa-hourglass-half text-yellow-600 text-3xl mb-2"></i>
                <p class="text-2xl font-bold text-gray-900">${reservees}</p>
                <p class="text-sm text-gray-600">Réservées</p>
            </div>
            <div class="text-center p-4 bg-green-50 rounded-lg border-2 border-green-200">
                <i class="fas fa-check-circle text-green-600 text-3xl mb-2"></i>
                <p class="text-2xl font-bold text-gray-900">${validees}</p>
                <p class="text-sm text-gray-600">Validées</p>
            </div>
            <div class="text-center p-4 bg-blue-50 rounded-lg border-2 border-blue-200">
                <i class="fas fa-flag-checkered text-blue-600 text-3xl mb-2"></i>
                <p class="text-2xl font-bold text-gray-900">${terminees}</p>
                <p class="text-sm text-gray-600">Terminées</p>
            </div>
            <div class="text-center p-4 bg-red-50 rounded-lg border-2 border-red-200">
                <i class="fas fa-times-circle text-red-600 text-3xl mb-2"></i>
                <p class="text-2xl font-bold text-gray-900">${annulees}</p>
                <p class="text-sm text-gray-600">Annulées</p>
            </div>
        </div>
    </div>

</div>

<script>
    // Graphique en camembert - Répartition par statut
    const statutCtx = document.getElementById('statutChart').getContext('2d');
    new Chart(statutCtx, {
        type: 'doughnut',
        data: {
            labels: [
                <c:forEach var="entry" items="${repartitionStatuts}" varStatus="status">
                '${entry.key}'${!status.last ? ',' : ''}
                </c:forEach>
            ],
            datasets: [{
                data: [
                    <c:forEach var="entry" items="${repartitionStatuts}" varStatus="status">
                    ${entry.value}${!status.last ? ',' : ''}
                    </c:forEach>
                ],
                backgroundColor: ['#fbbf24', '#10b981', '#3b82f6', '#ef4444'],
                borderWidth: 2,
                borderColor: '#fff'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                }
            }
        }
    });

    // Graphique en ligne - Consultations par mois
    const monthCtx = document.getElementById('monthChart').getContext('2d');
    new Chart(monthCtx, {
        type: 'line',
        data: {
            labels: [
                <c:forEach var="entry" items="${consultationsParMois}" varStatus="status">
                '${entry.key}'${!status.last ? ',' : ''}
                </c:forEach>
            ],
            datasets: [{
                label: 'Consultations',
                data: [
                    <c:forEach var="entry" items="${consultationsParMois}" varStatus="status">
                    ${entry.value}${!status.last ? ',' : ''}
                    </c:forEach>
                ],
                borderColor: '#6366f1',
                backgroundColor: 'rgba(99, 102, 241, 0.1)',
                tension: 0.4,
                fill: true,
                pointRadius: 4,
                pointBackgroundColor: '#6366f1'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            }
        }
    });
</script>

</body>
</html>