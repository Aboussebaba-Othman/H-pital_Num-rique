<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Consultations - Clinique</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        .status-RESERVEE { background-color: #fff3cd; color: #856404; }
        .status-VALIDEE { background-color: #d1ecf1; color: #0c5460; }
        .status-TERMINEE { background-color: #d4edda; color: #155724; }
        .status-ANNULEE { background-color: #f8d7da; color: #721c24; }
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/dashboard">
                        <i class="fas fa-home"></i> Tableau de bord
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/docteurs">
                        <i class="fas fa-user-md"></i> Docteurs
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/patient/consultations">
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
            <h2><i class="fas fa-calendar-check text-primary"></i> Mes Consultations</h2>
            <p class="text-muted">Gérez vos rendez-vous médicaux</p>
        </div>
        <div class="col-md-4 text-end">
            <a href="${pageContext.request.contextPath}/patient/reserver" class="btn btn-primary">
                <i class="fas fa-plus"></i> Nouvelle consultation
            </a>
        </div>
    </div>

    <!-- Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle"></i> ${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle"></i> ${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <!-- Filtre par statut -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Filtrer par statut</label>
                    <select class="form-select" name="statut" onchange="this.form.submit()">
                        <option value="">Tous les statuts</option>
                        <option value="RESERVEE" ${statutFiltre == 'RESERVEE' ? 'selected' : ''}>Réservée</option>
                        <option value="VALIDEE" ${statutFiltre == 'VALIDEE' ? 'selected' : ''}>Validée</option>
                        <option value="TERMINEE" ${statutFiltre == 'TERMINEE' ? 'selected' : ''}>Terminée</option>
                        <option value="ANNULEE" ${statutFiltre == 'ANNULEE' ? 'selected' : ''}>Annulée</option>
                    </select>
                </div>
            </form>
        </div>
    </div>

    <!-- Consultations Futures -->
    <div class="card mb-4">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0"><i class="fas fa-calendar-alt"></i> Consultations à venir</h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty consultationsFutures}">
                    <p class="text-muted mb-0">Aucune consultation à venir</p>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Heure</th>
                                <th>Docteur</th>
                                <th>Motif</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${consultationsFutures}" var="consultation">
                                <tr>
                                    <td>
                                        <fmt:formatDate value="${consultation.date}" pattern="dd/MM/yyyy" var="dateFormatted"/>
                                            ${dateFormatted}
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${consultation.heure}" pattern="HH:mm" var="heureFormatted"/>
                                            ${heureFormatted}
                                    </td>
                                    <td>
                                        <strong>Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom}</strong>
                                        <br>
                                        <small class="text-muted">${consultation.docteur.specialite}</small>
                                    </td>
                                    <td>
                                                <span class="d-inline-block text-truncate" style="max-width: 200px;"
                                                      title="${consultation.motifConsultation}">
                                                        ${consultation.motifConsultation}
                                                </span>
                                    </td>
                                    <td>
                                                <span class="status-badge status-${consultation.statut}">
                                                    <c:choose>
                                                        <c:when test="${consultation.statut == 'RESERVEE'}">Réservée</c:when>
                                                        <c:when test="${consultation.statut == 'VALIDEE'}">Validée</c:when>
                                                        <c:when test="${consultation.statut == 'TERMINEE'}">Terminée</c:when>
                                                        <c:when test="${consultation.statut == 'ANNULEE'}">Annulée</c:when>
                                                    </c:choose>
                                                </span>
                                    </td>
                                    <td>
                                        <c:if test="${consultation.statut == 'RESERVEE' || consultation.statut == 'VALIDEE'}">
                                            <button type="button" class="btn btn-sm btn-outline-danger"
                                                    onclick="annulerConsultation(${consultation.idConsultation})">
                                                <i class="fas fa-times"></i> Annuler
                                            </button>
                                        </c:if>
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

    <!-- Consultations Passées -->
    <div class="card">
        <div class="card-header bg-secondary text-white">
            <h5 class="mb-0"><i class="fas fa-history"></i> Consultations passées</h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty consultationsPassees}">
                    <p class="text-muted mb-0">Aucune consultation passée</p>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Heure</th>
                                <th>Docteur</th>
                                <th>Motif</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${consultationsPassees}" var="consultation">
                                <tr>
                                    <td>
                                        <fmt:formatDate value="${consultation.date}" pattern="dd/MM/yyyy" var="dateFormatted"/>
                                            ${dateFormatted}
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${consultation.heure}" pattern="HH:mm" var="heureFormatted"/>
                                            ${heureFormatted}
                                    </td>
                                    <td>
                                        <strong>Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom}</strong>
                                        <br>
                                        <small class="text-muted">${consultation.docteur.specialite}</small>
                                    </td>
                                    <td>
                                                <span class="d-inline-block text-truncate" style="max-width: 200px;"
                                                      title="${consultation.motifConsultation}">
                                                        ${consultation.motifConsultation}
                                                </span>
                                    </td>
                                    <td>
                                                <span class="status-badge status-${consultation.statut}">
                                                    <c:choose>
                                                        <c:when test="${consultation.statut == 'TERMINEE'}">Terminée</c:when>
                                                        <c:when test="${consultation.statut == 'ANNULEE'}">Annulée</c:when>
                                                    </c:choose>
                                                </span>
                                    </td>
                                    <td>
                                        <c:if test="${consultation.statut == 'TERMINEE' && not empty consultation.compteRendu}">
                                            <button type="button" class="btn btn-sm btn-outline-info"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#compteRenduModal${consultation.idConsultation}">
                                                <i class="fas fa-file-alt"></i> Compte-rendu
                                            </button>
                                        </c:if>
                                    </td>
                                </tr>

                                <!-- Modal Compte-rendu -->
                                <c:if test="${consultation.statut == 'TERMINEE' && not empty consultation.compteRendu}">
                                    <div class="modal fade" id="compteRenduModal${consultation.idConsultation}" tabindex="-1">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">
                                                        <i class="fas fa-file-alt"></i> Compte-rendu de consultation
                                                    </h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <p><strong>Date:</strong>
                                                        <fmt:formatDate value="${consultation.date}" pattern="dd/MM/yyyy"/>
                                                    </p>
                                                    <p><strong>Docteur:</strong>
                                                        Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom}
                                                    </p>
                                                    <hr>
                                                    <p class="mb-0">${consultation.compteRendu}</p>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                                        Fermer
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Statistiques -->
    <div class="alert alert-light border mt-4">
        <i class="fas fa-chart-bar text-primary"></i>
        <strong>Total:</strong> ${totalConsultations} consultation(s)
    </div>
</div>

<!-- Modal de confirmation d'annulation -->
<div class="modal fade" id="annulerModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-exclamation-triangle text-warning"></i> Confirmer l'annulation
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir annuler cette consultation ?</p>
                <p class="text-muted small mb-0">
                    <i class="fas fa-info-circle"></i> Cette action est irréversible.
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Non, garder</button>
                <form id="annulerForm" method="post">
                    <input type="hidden" name="action" value="annuler">
                    <input type="hidden" name="consultationId" id="consultationIdToCancel">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-times"></i> Oui, annuler
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function annulerConsultation(consultationId) {
        document.getElementById('consultationIdToCancel').value = consultationId;
        const modal = new bootstrap.Modal(document.getElementById('annulerModal'));
        modal.show();
    }
</script>
</body>
</html>