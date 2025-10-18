<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Planning - Clinique</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .time-slot {
            padding: 15px;
            border-left: 4px solid #dee2e6;
            margin-bottom: 10px;
            transition: all 0.3s;
        }
        .time-slot:hover {
            background-color: #f8f9fa;
            transform: translateX(5px);
        }
        .time-slot.occupied {
            border-left-color: #0d6efd;
            background-color: #e7f1ff;
        }
        .time-slot.reserved {
            border-left-color: #ffc107;
            background-color: #fff3cd;
        }
        .calendar-day {
            cursor: pointer;
            transition: all 0.2s;
        }
        .calendar-day:hover {
            background-color: #f8f9fa;
        }
        .calendar-day.active {
            background-color: #0d6efd;
            color: white;
        }
    </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/docteur/dashboard">
            <i class="fas fa-hospital"></i> Clinique - Espace Docteur
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/docteur/dashboard">
                        <i class="fas fa-home"></i> Tableau de bord
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/docteur/planning">
                        <i class="fas fa-calendar-alt"></i> Planning
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-md"></i> Dr. ${docteur.prenom} ${docteur.nom}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i> Déconnexion
                        </a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <!-- En-tête -->
    <div class="row mb-4">
        <div class="col-md-8">
            <h2><i class="fas fa-calendar-alt text-success"></i> Mon Planning</h2>
            <p class="text-muted">Gérez vos consultations et votre emploi du temps</p>
        </div>
    </div>

    <!-- Sélecteur de date -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-body">
                    <form method="get" class="row g-3 align-items-end">
                        <div class="col-md-4">
                            <label class="form-label">
                                <i class="fas fa-calendar"></i> Sélectionner une date
                            </label>
                            <input type="date" class="form-control" name="date"
                                   value="<fmt:formatDate value='${dateSelectionnee}' pattern='yyyy-MM-dd'/>"
                                   onchange="this.form.submit()">
                        </div>
                        <div class="col-md-8">
                            <div class="btn-group" role="group">
                                <a href="?date=<fmt:formatDate value='${dateSelectionnee.minusDays(1)}' pattern='yyyy-MM-dd'/>"
                                   class="btn btn-outline-primary">
                                    <i class="fas fa-chevron-left"></i> Jour précédent
                                </a>
                                <a href="?date=<fmt:formatDate value='<%= java.time.LocalDate.now() %>' pattern='yyyy-MM-dd'/>"
                                   class="btn btn-outline-primary">
                                    Aujourd'hui
                                </a>
                                <a href="?date=<fmt:formatDate value='${dateSelectionnee.plusDays(1)}' pattern='yyyy-MM-dd'/>"
                                   class="btn btn-outline-primary">
                                    Jour suivant <i class="fas fa-chevron-right"></i>
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Statistiques du jour -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card border-primary">
                <div class="card-body text-center">
                    <i class="fas fa-calendar-check fa-2x text-primary mb-2"></i>
                    <h4 class="mb-0">${consultationsJour}</h4>
                    <p class="text-muted mb-0">Consultations</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-success">
                <div class="card-body text-center">
                    <i class="fas fa-check-circle fa-2x text-success mb-2"></i>
                    <h4 class="mb-0">${consultationsValidees}</h4>
                    <p class="text-muted mb-0">Validées</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-warning">
                <div class="card-body text-center">
                    <i class="fas fa-clock fa-2x text-warning mb-2"></i>
                    <h4 class="mb-0">${consultationsReservees}</h4>
                    <p class="text-muted mb-0">En attente</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Planning du jour -->
    <div class="card shadow mb-4">
        <div class="card-header bg-success text-white">
            <h5 class="mb-0">
                <i class="fas fa-clock"></i> Planning du
                <fmt:formatDate value="${dateSelectionnee}" pattern="EEEE dd MMMM yyyy"/>
            </h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty planning}">
                    <div class="text-center py-5">
                        <i class="fas fa-calendar-times fa-4x text-muted mb-3"></i>
                        <p class="text-muted mb-0">Aucune consultation prévue pour cette date</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${planning}" var="consultation">
                        <div class="time-slot ${consultation.statut == 'VALIDEE' ? 'occupied' : 'reserved'}">
                            <div class="row">
                                <div class="col-md-2">
                                    <h5 class="mb-0">
                                        <i class="fas fa-clock"></i>
                                        <fmt:formatDate value="${consultation.heure}" pattern="HH:mm"/>
                                    </h5>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="mb-1">
                                        <i class="fas fa-user"></i>
                                            ${consultation.patient.prenom} ${consultation.patient.nom}
                                    </h6>
                                    <p class="mb-1 small">
                                        <i class="fas fa-notes-medical"></i>
                                            ${consultation.motifConsultation}
                                    </p>
                                    <p class="mb-0 text-muted small">
                                        <i class="fas fa-door-open"></i>
                                        Salle: ${consultation.salle.nomSalle}
                                    </p>
                                </div>
                                <div class="col-md-2">
                                        <span class="badge bg-${consultation.statut == 'VALIDEE' ? 'success' : 'warning'} w-100">
                                                ${consultation.statut == 'VALIDEE' ? 'Validée' : 'En attente'}
                                        </span>
                                </div>
                                <div class="col-md-2 text-end">
                                    <a href="${pageContext.request.contextPath}/docteur/gerer-consultation?id=${consultation.idConsultation}"
                                       class="btn btn-sm btn-outline-success">
                                        <i class="fas fa-eye"></i> Gérer
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Consultations de la semaine -->
    <div class="card shadow">
        <div class="card-header bg-info text-white">
            <h5 class="mb-0">
                <i class="fas fa-calendar-week"></i> Aperçu de la semaine
            </h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty consultationsSemaine}">
                    <p class="text-muted mb-0">Aucune consultation prévue cette semaine</p>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Heure</th>
                                <th>Patient</th>
                                <th>Motif</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${consultationsSemaine}" var="consultation">
                                <tr>
                                    <td>
                                        <fmt:formatDate value="${consultation.date}" pattern="EEE dd/MM"/>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${consultation.heure}" pattern="HH:mm"/>
                                    </td>
                                    <td>
                                            ${consultation.patient.prenom} ${consultation.patient.nom}
                                    </td>
                                    <td>
                                                <span class="d-inline-block text-truncate" style="max-width: 200px;">
                                                        ${consultation.motifConsultation}
                                                </span>
                                    </td>
                                    <td>
                                                <span class="badge bg-${consultation.statut == 'VALIDEE' ? 'success' : 'warning'}">
                                                        ${consultation.statut == 'VALIDEE' ? 'Validée' : 'Réservée'}
                                                </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/docteur/gerer-consultation?id=${consultation.idConsultation}"
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-eye"></i>
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
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>