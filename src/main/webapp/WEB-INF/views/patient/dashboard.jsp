<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord Patient - Clinique</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .stat-card {
            border-left: 4px solid;
            transition: transform 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-card.primary { border-color: #0d6efd; }
        .stat-card.warning { border-color: #ffc107; }
        .stat-card.success { border-color: #198754; }
        .stat-card.info { border-color: #0dcaf0; }
    </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/patient/dashboard">
            <i class="fas fa-hospital"></i> Clinique
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/patient/dashboard">
                        <i class="fas fa-home"></i> Tableau de bord
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/docteurs">
                        <i class="fas fa-user-md"></i> Docteurs
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/consultations">
                        <i class="fas fa-calendar-check"></i> Mes Consultations
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/historique">
                        <i class="fas fa-history"></i> Historique
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                       data-bs-toggle="dropdown">
                        <i class="fas fa-user"></i> ${patient.prenom} ${patient.nom}
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
    <!-- En-tête de bienvenue -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card bg-primary text-white">
                <div class="card-body">
                    <h2 class="mb-2">
                        <i class="fas fa-hand-wave"></i> Bonjour, ${patient.prenom} ${patient.nom}!
                    </h2>
                    <p class="mb-0">Bienvenue sur votre espace patient</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Statistiques -->
    <div class="row mb-4">
        <div class="col-md-3 mb-3">
            <div class="card stat-card primary shadow-sm">
                <div class="card-body text-center">
                    <i class="fas fa-calendar-alt fa-3x text-primary mb-2"></i>
                    <h3 class="mb-0">${totalConsultations}</h3>
                    <p class="text-muted mb-0">Total Consultations</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card stat-card warning shadow-sm">
                <div class="card-body text-center">
                    <i class="fas fa-clock fa-3x text-warning mb-2"></i>
                    <h3 class="mb-0">${consultationsEnAttente.size()}</h3>
                    <p class="text-muted mb-0">En Attente</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card stat-card success shadow-sm">
                <div class="card-body text-center">
                    <i class="fas fa-check-circle fa-3x text-success mb-2"></i>
                    <h3 class="mb-0">${nombreConsultationsTerminees}</h3>
                    <p class="text-muted mb-0">Terminées</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card stat-card info shadow-sm">
                <div class="card-body text-center">
                    <i class="fas fa-heartbeat fa-3x text-info mb-2"></i>
                    <h3 class="mb-0">
                        <c:choose>
                            <c:when test="${not empty patient.poids && not empty patient.taille}">
                                <fmt:formatNumber value="${patient.poids / ((patient.taille / 100) * (patient.taille / 100))}"
                                                  maxFractionDigits="1"/>
                            </c:when>
                            <c:otherwise>--</c:otherwise>
                        </c:choose>
                    </h3>
                    <p class="text-muted mb-0">IMC</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Prochaine Consultation -->
    <c:if test="${not empty prochaineConsultation}">
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-calendar-star"></i> Votre Prochaine Consultation
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-8">
                                <h5 class="mb-3">
                                    <fmt:formatDate value="${prochaineConsultation.date}" pattern="EEEE dd MMMM yyyy"/>
                                    à
                                    <fmt:formatDate value="${prochaineConsultation.heure}" pattern="HH:mm"/>
                                </h5>
                                <p class="mb-2">
                                    <i class="fas fa-user-md text-primary"></i>
                                    <strong>Docteur:</strong>
                                    Dr. ${prochaineConsultation.docteur.prenom} ${prochaineConsultation.docteur.nom}
                                </p>
                                <p class="mb-2">
                                    <i class="fas fa-stethoscope text-primary"></i>
                                    <strong>Spécialité:</strong>
                                        ${prochaineConsultation.docteur.specialite}
                                </p>
                                <p class="mb-0">
                                    <i class="fas fa-notes-medical text-primary"></i>
                                    <strong>Motif:</strong>
                                        ${prochaineConsultation.motifConsultation}
                                </p>
                            </div>
                            <div class="col-md-4 text-end">
                                    <span class="badge bg-${prochaineConsultation.statut == 'VALIDEE' ? 'success' : 'warning'} fs-6">
                                            ${prochaineConsultation.statut == 'VALIDEE' ? 'Confirmée' : 'En attente'}
                                    </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <div class="row">
        <!-- Consultations à venir -->
        <div class="col-md-6 mb-4">
            <div class="card shadow h-100">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-calendar-alt"></i> Consultations à Venir
                    </h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty consultationsAvenir}">
                            <div class="text-center py-4">
                                <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                <p class="text-muted mb-3">Aucune consultation programmée</p>
                                <a href="${pageContext.request.contextPath}/patient/reserver"
                                   class="btn btn-primary">
                                    <i class="fas fa-plus"></i> Réserver une consultation
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="list-group list-group-flush">
                                <c:forEach items="${consultationsAvenir}" var="consultation" varStatus="status">
                                    <c:if test="${status.index < 5}">
                                        <div class="list-group-item">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <h6 class="mb-1">
                                                        <fmt:formatDate value="${consultation.date}" pattern="dd/MM/yyyy"/>
                                                        à
                                                        <fmt:formatDate value="${consultation.heure}" pattern="HH:mm"/>
                                                    </h6>
                                                    <p class="mb-1 small">
                                                        Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom}
                                                    </p>
                                                    <p class="mb-0 text-muted small">
                                                            ${consultation.docteur.specialite}
                                                    </p>
                                                </div>
                                                <span class="badge bg-${consultation.statut == 'VALIDEE' ? 'success' : 'warning'}">
                                                        ${consultation.statut == 'VALIDEE' ? 'Validée' : 'Réservée'}
                                                </span>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                            <div class="card-footer bg-transparent">
                                <a href="${pageContext.request.contextPath}/patient/consultations"
                                   class="text-decoration-none">
                                    Voir toutes les consultations <i class="fas fa-arrow-right"></i>
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Actions Rapides -->
        <div class="col-md-6 mb-4">
            <div class="card shadow h-100">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-rocket"></i> Actions Rapides
                    </h5>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-3">
                        <a href="${pageContext.request.contextPath}/patient/reserver"
                           class="btn btn-lg btn-outline-primary text-start">
                            <i class="fas fa-calendar-plus me-2"></i>
                            Réserver une consultation
                        </a>
                        <a href="${pageContext.request.contextPath}/patient/docteurs"
                           class="btn btn-lg btn-outline-info text-start">
                            <i class="fas fa-user-md me-2"></i>
                            Trouver un docteur
                        </a>
                        <a href="${pageContext.request.contextPath}/patient/consultations"
                           class="btn btn-lg btn-outline-warning text-start">
                            <i class="fas fa-list me-2"></i>
                            Mes consultations
                        </a>
                        <a href="${pageContext.request.contextPath}/patient/historique"
                           class="btn btn-lg btn-outline-secondary text-start">
                            <i class="fas fa-history me-2"></i>
                            Historique médical
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Informations Patient -->
    <div class="row">
        <div class="col-12">
            <div class="card shadow">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-user-circle"></i> Mes Informations
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <p class="mb-2">
                                <i class="fas fa-envelope text-primary"></i>
                                <strong>Email:</strong> ${patient.email}
                            </p>
                            <p class="mb-2">
                                <i class="fas fa-weight text-primary"></i>
                                <strong>Poids:</strong>
                                <c:choose>
                                    <c:when test="${not empty patient.poids}">
                                        <fmt:formatNumber value="${patient.poids}" maxFractionDigits="1"/> kg
                                    </c:when>
                                    <c:otherwise>Non renseigné</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="col-md-6">
                            <p class="mb-2">
                                <i class="fas fa-id-card text-primary"></i>
                                <strong>ID Patient:</strong> #${patient.idPatient}
                            </p>
                            <p class="mb-2">
                                <i class="fas fa-ruler-vertical text-primary"></i>
                                <strong>Taille:</strong>
                                <c:choose>
                                    <c:when test="${not empty patient.taille}">
                                        <fmt:formatNumber value="${patient.taille}" maxFractionDigits="0"/> cm
                                    </c:when>
                                    <c:otherwise>Non renseignée</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>