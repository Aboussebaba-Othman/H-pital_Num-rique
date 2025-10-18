<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Planning - Dr. ${docteur.nom}</title>
    <!-- Tailwind & FontAwesome to keep consistent styling with dashboard.jsp -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Bootstrap icons (kept for existing markup that uses them) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #0d6efd;
            --success-color: #198754;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #0dcaf0;
        }

        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .calendar-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 20px;
            margin-top: 20px;
        }

        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
            color: white;
        }

        .calendar-header h2 {
            margin: 0;
            font-size: 1.8rem;
            font-weight: 600;
        }

        .calendar-nav {
            display: flex;
            gap: 10px;
        }

        .calendar-nav .btn {
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            transition: all 0.3s;
        }

        .calendar-nav .btn:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 10px;
            margin-top: 20px;
        }

        .calendar-day-header {
            text-align: center;
            font-weight: 600;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 5px;
            color: #495057;
        }

        .calendar-day {
            min-height: 120px;
            padding: 10px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            background: white;
            transition: all 0.3s;
            position: relative;
        }

        .calendar-day:hover {
            border-color: var(--primary-color);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }

        .calendar-day.empty {
            background: #f8f9fa;
            border-color: transparent;
        }

        .calendar-day.today {
            border-color: var(--primary-color);
            background: #e7f1ff;
        }

        .day-number {
            font-weight: 600;
            font-size: 1.1rem;
            color: #495057;
            margin-bottom: 5px;
        }

        .calendar-day.today .day-number {
            color: var(--primary-color);
            background: white;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            margin: 0 auto 10px;
        }

        .consultation-badge {
            font-size: 0.75rem;
            padding: 4px 8px;
            border-radius: 4px;
            margin: 3px 0;
            display: block;
            cursor: pointer;
            transition: all 0.2s;
        }

        .consultation-badge:hover {
            transform: scale(1.05);
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }

        .badge-reservee {
            background: #fff3cd;
            color: #856404;
            border-left: 3px solid var(--warning-color);
        }

        .badge-validee {
            background: #cfe2ff;
            color: #084298;
            border-left: 3px solid var(--primary-color);
        }

        .badge-terminee {
            background: #d1e7dd;
            color: #0f5132;
            border-left: 3px solid var(--success-color);
        }

        .badge-annulee {
            background: #f8d7da;
            color: #842029;
            border-left: 3px solid var(--danger-color);
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .stat-card .icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        .stat-card.total {
            border-left: 4px solid #6c757d;
        }

        .stat-card.total .icon {
            color: #6c757d;
        }

        .stat-card.reservee {
            border-left: 4px solid var(--warning-color);
        }

        .stat-card.reservee .icon {
            color: var(--warning-color);
        }

        .stat-card.validee {
            border-left: 4px solid var(--primary-color);
        }

        .stat-card.validee .icon {
            color: var(--primary-color);
        }

        .stat-card.terminee {
            border-left: 4px solid var(--success-color);
        }

        .stat-card.terminee .icon {
            color: var(--success-color);
        }

        .stat-card.annulee {
            border-left: 4px solid var(--danger-color);
        }

        .stat-card.annulee .icon {
            color: var(--danger-color);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            margin: 10px 0;
        }

        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
            text-transform: uppercase;
        }

        .legend {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
            margin: 20px 0;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .legend-color {
            width: 20px;
            height: 20px;
            border-radius: 4px;
        }

        @media (max-width: 768px) {
            .calendar-grid {
                gap: 5px;
            }

            .calendar-day {
                min-height: 80px;
                padding: 5px;
            }

            .consultation-badge {
                font-size: 0.65rem;
                padding: 2px 4px;
            }

            .calendar-header {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen">

<!-- Navigation -->
<jsp:include page="/WEB-INF/views/common/docteur-nav.jsp" />

<div class="container my-4">
    <!-- Statistics Cards -->
    <div class="stats-container">
        <div class="stat-card total">
            <div class="icon">
                <i class="bi bi-calendar-check"></i>
            </div>
            <div class="stat-number">${totalConsultations}</div>
            <div class="stat-label">Total Consultations</div>
        </div>

        <div class="stat-card reservee">
            <div class="icon">
                <i class="bi bi-clock-history"></i>
            </div>
            <div class="stat-number">${reservees}</div>
            <div class="stat-label">Réservées</div>
        </div>

        <div class="stat-card validee">
            <div class="icon">
                <i class="bi bi-check-circle"></i>
            </div>
            <div class="stat-number">${validees}</div>
            <div class="stat-label">Validées</div>
        </div>

        <div class="stat-card terminee">
            <div class="icon">
                <i class="bi bi-check2-all"></i>
            </div>
            <div class="stat-number">${terminees}</div>
            <div class="stat-label">Terminées</div>
        </div>

        <div class="stat-card annulee">
            <div class="icon">
                <i class="bi bi-x-circle"></i>
            </div>
            <div class="stat-number">${annulees}</div>
            <div class="stat-label">Annulées</div>
        </div>
    </div>

    <!-- Calendar -->
    <div class="calendar-container">
        <div class="calendar-header">
            <h2>
                <i class="bi bi-calendar3"></i>
                ${monthName}
            </h2>
            <div class="calendar-nav">
                <a href="?month=${moisPrecedent}&year=${anneePrecedente}" class="btn">
                    <i class="bi bi-chevron-left"></i> Précédent
                </a>
                <a href="?" class="btn">
                    <i class="bi bi-calendar-today"></i> Aujourd'hui
                </a>
                <a href="?month=${moisSuivant}&year=${anneeSuivante}" class="btn">
                    Suivant <i class="bi bi-chevron-right"></i>
                </a>
            </div>
        </div>

        <!-- Legend -->
        <div class="legend">
            <div class="legend-item">
                <div class="legend-color" style="background: #fff3cd; border-left: 3px solid var(--warning-color);"></div>
                <span>Réservée</span>
            </div>
            <div class="legend-item">
                <div class="legend-color" style="background: #cfe2ff; border-left: 3px solid var(--primary-color);"></div>
                <span>Validée</span>
            </div>
            <div class="legend-item">
                <div class="legend-color" style="background: #d1e7dd; border-left: 3px solid var(--success-color);"></div>
                <span>Terminée</span>
            </div>
            <div class="legend-item">
                <div class="legend-color" style="background: #f8d7da; border-left: 3px solid var(--danger-color);"></div>
                <span>Annulée</span>
            </div>
        </div>

        <!-- Calendar Grid -->
        <div class="calendar-grid">
            <!-- Day Headers -->
            <div class="calendar-day-header">Lun</div>
            <div class="calendar-day-header">Mar</div>
            <div class="calendar-day-header">Mer</div>
            <div class="calendar-day-header">Jeu</div>
            <div class="calendar-day-header">Ven</div>
            <div class="calendar-day-header">Sam</div>
            <div class="calendar-day-header">Dim</div>

            <!-- Empty cells before first day -->
            <c:forEach begin="1" end="${premierJourSemaine - 1}">
                <div class="calendar-day empty"></div>
            </c:forEach>

            <!-- Calendar days -->
            <c:forEach var="day" begin="1" end="${nombreDeJours}">
                <jsp:useBean id="yearMonth" scope="request" type="java.time.YearMonth"/>
                <jsp:useBean id="currentDate" scope="request" type="java.time.LocalDate"/>
                <c:set var="date" value="${yearMonth.atDay(day)}"/>
                <c:set var="isToday" value="${date.equals(currentDate)}"/>

                <div class="calendar-day ${isToday ? 'today' : ''}">
                    <div class="day-number">${day}</div>

                    <c:set var="consultations" value="${consultationsParDate[date]}"/>
                    <c:if test="${not empty consultations}">
                        <c:forEach var="consultation" items="${consultations}">
                                <div class="consultation-badge badge-${consultation.statut.toString().toLowerCase()}"
                                 title="${consultation.patient.nom} ${consultation.patient.prenom} - ${consultation.heure}"
                                 onclick="showConsultationDetails('${consultation.idConsultation}')">
                                <i class="bi bi-clock"></i> ${consultation.heure}
                                <br>
                                <small>${consultation.patient.nom}</small>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Consultations List -->
    <div class="calendar-container mt-4">
        <h3 class="mb-4">
            <i class="bi bi-list-ul"></i>
            Liste des consultations du mois
        </h3>

        <c:choose>
            <c:when test="${empty consultationsDuMois}">
                <div class="alert alert-info">
                    <i class="bi bi-info-circle"></i>
                    Aucune consultation prévue pour ce mois.
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Date</th>
                            <th>Heure</th>
                            <th>Patient</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="consultation" items="${consultationsDuMois}">
                            <tr>
                                <td>
                                    <i class="bi bi-calendar-event"></i>
                                        ${consultation.date.dayOfMonth}/${consultation.date.monthValue}/${consultation.date.year}
                                </td>
                                <td>
                                    <i class="bi bi-clock"></i>
                                        ${consultation.heure}
                                </td>
                                <td>
                                    <strong>${consultation.patient.nom} ${consultation.patient.prenom}</strong>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${consultation.statut == 'RESERVEE'}">
                                                    <span class="badge bg-warning text-dark">
                                                        <i class="bi bi-clock-history"></i> Réservée
                                                    </span>
                                        </c:when>
                                        <c:when test="${consultation.statut == 'VALIDEE'}">
                                                    <span class="badge bg-primary">
                                                        <i class="bi bi-check-circle"></i> Validée
                                                    </span>
                                        </c:when>
                                        <c:when test="${consultation.statut == 'TERMINEE'}">
                                                    <span class="badge bg-success">
                                                        <i class="bi bi-check2-all"></i> Terminée
                                                    </span>
                                        </c:when>
                                        <c:when test="${consultation.statut == 'ANNULEE'}">
                                                    <span class="badge bg-danger">
                                                        <i class="bi bi-x-circle"></i> Annulée
                                                    </span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/docteur/consultation?id=${consultation.idConsultation}"
                                       class="btn btn-sm btn-primary">
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function showConsultationDetails(consultationId) {
        window.location.href = '${pageContext.request.contextPath}/docteur/consultation?id=' + consultationId;
    }
</script>
</body>
</html>