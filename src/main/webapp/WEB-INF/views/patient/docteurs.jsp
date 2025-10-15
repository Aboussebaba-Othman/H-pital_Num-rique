<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Docteurs - Clinique</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/dashboard">
                        <i class="fas fa-home"></i> Tableau de bord
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/patient/docteurs">
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
                        <i class="fas fa-user"></i> ${sessionScope.userConnecte.prenom} ${sessionScope.userConnecte.nom}
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
            <h2><i class="fas fa-user-md text-primary"></i> Liste des Docteurs</h2>
            <p class="text-muted">Trouvez le médecin qui correspond à vos besoins</p>
        </div>
    </div>

    <!-- Filtres et Recherche -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/patient/docteurs" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Rechercher</label>
                    <input type="text" class="form-control" name="search"
                           placeholder="Nom, prénom..." value="${searchTerm}">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Département</label>
                    <select class="form-select" name="departementId">
                        <option value="">Tous les départements</option>
                        <c:forEach items="${departements}" var="dept">
                            <option value="${dept.idDepartement}"
                                ${dept.idDepartement == departementIdFiltre ? 'selected' : ''}>
                                    ${dept.nom}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Spécialité</label>
                    <input type="text" class="form-control" name="specialite"
                           placeholder="Spécialité..." value="${specialiteFiltre}">
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search"></i> Filtrer
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Liste des Docteurs -->
    <c:choose>
        <c:when test="${empty docteurs}">
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i> Aucun docteur trouvé.
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach items="${docteurs}" var="docteur">
                    <div class="col-md-6 col-lg-4 mb-4">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body">
                                <div class="d-flex align-items-center mb-3">
                                    <div class="avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                                         style="width: 60px; height: 60px; font-size: 24px;">
                                        <i class="fas fa-user-md"></i>
                                    </div>
                                    <div>
                                        <h5 class="card-title mb-0">
                                            Dr. ${docteur.prenom} ${docteur.nom}
                                        </h5>
                                        <p class="text-muted mb-0 small">${docteur.specialite}</p>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <p class="mb-1">
                                        <i class="fas fa-building text-primary"></i>
                                        <strong>Département:</strong> ${docteur.departement.nom}
                                    </p>
                                    <p class="mb-1">
                                        <i class="fas fa-envelope text-primary"></i>
                                        <strong>Email:</strong> ${docteur.email}
                                    </p>
                                </div>

                                <a href="${pageContext.request.contextPath}/patient/reserver?docteurId=${docteur.idDocteur}"
                                   class="btn btn-primary w-100">
                                    <i class="fas fa-calendar-plus"></i> Prendre rendez-vous
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Statistiques -->
            <div class="alert alert-light border mt-4">
                <i class="fas fa-info-circle text-primary"></i>
                <strong>${docteurs.size()}</strong> docteur(s) trouvé(s)
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>