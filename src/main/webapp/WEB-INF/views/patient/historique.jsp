<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique des Consultations - Clinique</title>
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
        .timeline-item {
            border-left: 3px solid #dee2e6;
            padding-left: 20px;
            padding-bottom: 20px;
            position: relative;
        }
        .timeline-item:last-child {
            border-left: none;
        }
        .timeline-dot {
            position: absolute;
            left: -9px;
            width: 15px;
            height: 15px;
            border-radius: 50%;
            background-color: #6c757d;
        }
        .timeline-dot.success {
            background-color: #28a745;
        }
        .timeline-dot.danger {
            background-color: #dc3545;
        }
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/consultations">
                        <i class="fas fa-calendar-check"></i> Mes Consultations
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/patient/historique">
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
            <h2><i class="fas fa-history text-primary"></i> Historique des Consultations</h2>
            <p class="text-muted">Consultez votre historique médical complet</p>
        </div>
    </div>

    <!-- Statistiques -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card border-success">
                <div class="card-body text-center">
                    <i class="fas fa-check-circle fa-3x text-success mb-2"></i>
                    <h3 class="mb-0">${consultationsTerminees}</h3>
                    <p class="text-muted mb-0">Consultations terminées</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-danger">
                <div class="card-body text-center">
                    <i class="fas fa-times-circle fa-3x text-danger mb-2"></i>
                    <h3 class="mb-0">${consultationsAnnulees}</h3>
                    <p class="text-muted mb-0">Consultations annulées</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-primary">
                <div class="card-body text-center">
                    <i class="fas fa-calendar-alt fa-3x text-primary mb-2"></i>
                    <h3 class="mb-0">${historique.size()}</h3>
                    <p class="text-muted mb-0">Total consultations</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Filtres -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Filtrer par année</label>
                    <select class="form-select" name="annee" onchange="this.form.submit()">
                        <option value="">Toutes les années</option>
                        <c:forEach items="${anneesDisponibles}" var="annee">
                            <option value="${annee}" ${annee == anneeFiltre ? 'selected' : ''}>
                                    ${annee}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Affichage</label>
                    <select class="form-select" id="viewMode">
                        <option value="table">Vue tableau</option>
                        <option value="timeline">Vue chronologique</option>
                    </select>
                </div>
            </form>
        </div>
    </div>

    <!-- Vue Tableau -->
    <div id="tableView" class="card">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0"><i class="fas fa-list"></i> Historique détaillé</h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty historique}">
                    <div class="text-center py-5">
                        <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                        <p class="text-muted mb-0">Aucune consultation dans l'historique</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>Réf.</th>
                                <th>Date</th>
                                <th>Heure</th>
                                <th>Docteur</th>
                                <th>Motif</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${historique}" var="consultation">
                                <tr>
                                    <td><strong>#${consultation.idConsultation}</strong></td>
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
                                        <c:if test="${consultation.statut == 'TERMINEE' && not empty consultation.compteRendu}">
                                            <button type="button" class="btn btn-sm btn-outline-info"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#compteRenduModal${consultation.idConsultation}">
                                                <i class="fas fa-file-alt"></i>
                                            </button>
                                        </c:if>
                                    </td>
                                </tr>

                                <!-- Modal Compte-rendu -->
                                <c:if test="${consultation.statut == 'TERMINEE' && not empty consultation.compteRendu}">
                                    <div class="modal fade" id="compteRenduModal${consultation.idConsultation}" tabindex="-1">
                                        <div class="modal-dialog modal-lg">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">
                                                        <i class="fas fa-file-medical"></i> Compte-rendu de consultation
                                                    </h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="row mb-3">
                                                        <div class="col-md-6">
                                                            <p class="mb-1"><strong>Référence:</strong> #${consultation.idConsultation}</p>
                                                            <p class="mb-1"><strong>Date:</strong>
                                                                <fmt:formatDate value="${consultation.date}" pattern="dd/MM/yyyy"/>
                                                            </p>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <p class="mb-1"><strong>Docteur:</strong>
                                                                Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom}
                                                            </p>
                                                            <p class="mb-1"><strong>Spécialité:</strong>
                                                                    ${consultation.docteur.specialite}
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <hr>
                                                    <h6 class="mb-3"><i class="fas fa-notes-medical"></i> Compte-rendu médical</h6>
                                                    <div class="bg-light p-3 rounded">
                                                        <p class="mb-0">${consultation.compteRendu}</p>
                                                    </div>
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

    <!-- Vue Chronologique (Timeline) -->
    <div id="timelineView" class="card" style="display: none;">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0"><i class="fas fa-stream"></i> Vue chronologique</h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty historique}">
                    <div class="text-center py-5">
                        <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                        <p class="text-muted mb-0">Aucune consultation dans l'historique</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="mt-4">
                        <c:forEach items="${historique}" var="consultation">
                            <div class="timeline-item">
                                <div class="timeline-dot ${consultation.statut == 'TERMINEE' ? 'success' : consultation.statut == 'ANNULEE' ? 'danger' : ''}"></div>
                                <div class="card mb-3">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h6 class="card-title mb-2">
                                                    <fmt:formatDate value="${consultation.date}" pattern="dd MMMM yyyy"/>
                                                    à
                                                    <fmt:formatDate value="${consultation.heure}" pattern="HH:mm"/>
                                                </h6>
                                                <p class="mb-1">
                                                    <i class="fas fa-user-md text-primary"></i>
                                                    <strong>Dr. ${consultation.docteur.prenom} ${consultation.docteur.nom}</strong>
                                                    - ${consultation.docteur.specialite}
                                                </p>
                                                <p class="mb-2">
                                                    <i class="fas fa-notes-medical text-primary"></i>
                                                        ${consultation.motifConsultation}
                                                </p>
                                            </div>
                                            <span class="status-badge status-${consultation.statut}">
                                                    <c:choose>
                                                        <c:when test="${consultation.statut == 'TERMINEE'}">Terminée</c:when>
                                                        <c:when test="${consultation.statut == 'ANNULEE'}">Annulée</c:when>
                                                    </c:choose>
                                                </span>
                                        </div>
                                        <c:if test="${consultation.statut == 'TERMINEE' && not empty consultation.compteRendu}">
                                            <button type="button" class="btn btn-sm btn-outline-info mt-2"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#compteRenduModal${consultation.idConsultation}">
                                                <i class="fas fa-file-alt"></i> Voir le compte-rendu
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Gestion du changement de vue
    document.getElementById('viewMode').addEventListener('change', function() {
        const tableView = document.getElementById('tableView');
        const timelineView = document.getElementById('timelineView');

        if (this.value === 'timeline') {
            tableView.style.display = 'none';
            timelineView.style.display = 'block';
        } else {
            tableView.style.display = 'block';
            timelineView.style.display = 'none';
        }
    });
</script>
</body>
</html>