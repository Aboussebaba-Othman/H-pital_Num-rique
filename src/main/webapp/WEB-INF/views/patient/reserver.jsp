<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réserver une Consultation - Clinique</title>
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
    <div class="row justify-content-center">
        <div class="col-md-8">
            <!-- En-tête -->
            <div class="mb-4">
                <h2><i class="fas fa-calendar-plus text-primary"></i> Réserver une Consultation</h2>
                <p class="text-muted">Remplissez le formulaire pour prendre rendez-vous</p>
            </div>

            <!-- Messages -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Docteur sélectionné (si applicable) -->
            <c:if test="${not empty docteurSelectionne}">
                <div class="card mb-4 border-primary">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="fas fa-user-md text-primary"></i> Docteur sélectionné
                        </h5>
                        <p class="mb-0">
                            <strong>Dr. ${docteurSelectionne.prenom} ${docteurSelectionne.nom}</strong>
                            <br>
                            <span class="text-muted">${docteurSelectionne.specialite}</span>
                        </p>
                    </div>
                </div>
            </c:if>

            <!-- Formulaire de réservation -->
            <div class="card shadow">
                <div class="card-body p-4">
                    <form method="post" action="${pageContext.request.contextPath}/patient/reserver">

                        <!-- Sélection du docteur -->
                        <div class="mb-3">
                            <label for="docteurId" class="form-label">
                                <i class="fas fa-user-md"></i> Docteur *
                            </label>
                            <select class="form-select" id="docteurId" name="docteurId" required>
                                <option value="">Choisir un docteur...</option>
                                <c:forEach items="${docteurs}" var="docteur">
                                    <option value="${docteur.idDocteur}"
                                        ${docteur.idDocteur == docteurSelectionne.idDocteur ? 'selected' : ''}>
                                        Dr. ${docteur.prenom} ${docteur.nom} - ${docteur.specialite}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Date -->
                        <div class="mb-3">
                            <label for="date" class="form-label">
                                <i class="fas fa-calendar"></i> Date de la consultation *
                            </label>
                            <input type="date" class="form-control" id="date" name="date" required
                                   min="<fmt:formatDate value='<%= new java.util.Date() %>' pattern='yyyy-MM-dd'/>">
                            <small class="form-text text-muted">
                                Les consultations doivent être réservées au moins 24h à l'avance
                            </small>
                        </div>

                        <!-- Heure -->
                        <div class="mb-3">
                            <label for="heure" class="form-label">
                                <i class="fas fa-clock"></i> Heure *
                            </label>
                            <select class="form-select" id="heure" name="heure" required>
                                <option value="">Choisir une heure...</option>
                                <option value="08:00">08:00</option>
                                <option value="08:30">08:30</option>
                                <option value="09:00">09:00</option>
                                <option value="09:30">09:30</option>
                                <option value="10:00">10:00</option>
                                <option value="10:30">10:30</option>
                                <option value="11:00">11:00</option>
                                <option value="11:30">11:30</option>
                                <option value="14:00">14:00</option>
                                <option value="14:30">14:30</option>
                                <option value="15:00">15:00</option>
                                <option value="15:30">15:30</option>
                                <option value="16:00">16:00</option>
                                <option value="16:30">16:30</option>
                                <option value="17:00">17:00</option>
                                <option value="17:30">17:30</option>
                            </select>
                            <small class="form-text text-muted">
                                Heures de consultation : 8h-12h et 14h-18h
                            </small>
                        </div>

                        <!-- Motif -->
                        <div class="mb-4">
                            <label for="motif" class="form-label">
                                <i class="fas fa-file-alt"></i> Motif de la consultation *
                            </label>
                            <textarea class="form-control" id="motif" name="motif" rows="4"
                                      required minlength="10" maxlength="500"
                                      placeholder="Décrivez brièvement la raison de votre consultation..."></textarea>
                            <small class="form-text text-muted">
                                Entre 10 et 500 caractères
                            </small>
                        </div>

                        <!-- Boutons -->
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-check"></i> Confirmer la réservation
                            </button>
                            <a href="${pageContext.request.contextPath}/patient/docteurs"
                               class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left"></i> Retour
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Informations -->
            <div class="card mt-4 bg-light border-0">
                <div class="card-body">
                    <h6 class="card-title"><i class="fas fa-info-circle text-info"></i> Informations importantes</h6>
                    <ul class="mb-0 small">
                        <li>Les consultations doivent être réservées au moins 24 heures à l'avance</li>
                        <li>Vous pouvez annuler votre rendez-vous jusqu'à 24 heures avant</li>
                        <li>Le docteur validera ou refusera votre demande de consultation</li>
                        <li>Vous recevrez une notification de la décision du docteur</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Définir la date minimale à demain
    const today = new Date();
    today.setDate(today.getDate() + 1);
    const tomorrow = today.toISOString().split('T')[0];
    document.getElementById('date').setAttribute('min', tomorrow);
</script>
</body>
</html>