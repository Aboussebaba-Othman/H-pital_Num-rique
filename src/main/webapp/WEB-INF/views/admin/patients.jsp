<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gérer Patients - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">

<%@ include file="../common/admin-nav.jsp" %>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header -->
    <div class="flex justify-between items-center mb-8">
        <div>
            <h1 class="text-3xl font-bold text-gray-900">Gestion des Patients</h1>
            <p class="text-gray-600 mt-1">Consulter et modifier les informations des patients</p>
        </div>
        <a href="${pageContext.request.contextPath}/inscription-patient"
           class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition shadow-lg">
            <i class="fas fa-user-plus mr-2"></i>
            Nouveau Patient
        </a>
    </div>

    <!-- Messages -->
    <c:if test="${param.success != null}">
        <div class="mb-6 p-4 bg-green-100 border-l-4 border-green-500 text-green-700 rounded">
            <i class="fas fa-check-circle mr-2"></i>
                ${param.success}
        </div>
    </c:if>

    <c:if test="${param.error != null}">
        <div class="mb-6 p-4 bg-red-100 border-l-4 border-red-500 text-red-700 rounded">
            <i class="fas fa-exclamation-triangle mr-2"></i>
                ${param.error}
        </div>
    </c:if>

    <!-- Barre de recherche -->
    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
        <form method="get" action="${pageContext.request.contextPath}/admin/patients" class="flex gap-4">
            <input type="hidden" name="action" value="search">

            <div class="flex-1">
                <input type="text"
                       name="search"
                       value="${searchTerm}"
                       placeholder="Rechercher un patient (nom, prénom, email)..."
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
            </div>

            <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                <i class="fas fa-search mr-2"></i>Rechercher
            </button>

            <a href="${pageContext.request.contextPath}/admin/patients"
               class="px-6 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400">
                <i class="fas fa-redo"></i>
            </a>
        </form>
    </div>

    <!-- Liste des patients -->
    <div class="bg-white rounded-xl shadow-lg overflow-hidden">
        <div class="p-6 border-b border-gray-200">
            <h2 class="text-xl font-bold text-gray-900">
                <i class="fas fa-users mr-2 text-blue-600"></i>
                Liste des Patients (${patients.size()})
            </h2>
        </div>

        <c:choose>
            <c:when test="${empty patients}">
                <div class="p-12 text-center">
                    <i class="fas fa-users text-gray-300 text-6xl mb-4"></i>
                    <p class="text-gray-500 text-lg">Aucun patient trouvé</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Patient</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Contact</th>
                            <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">Mesures</th>
                            <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">IMC</th>
                            <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">Consultations</th>
                            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Actions</th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach var="patient" items="${patients}">
                            <tr class="hover:bg-gray-50 transition">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-12 w-12 bg-blue-100 rounded-full flex items-center justify-center">
                                            <i class="fas fa-user text-blue-600 text-xl"></i>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900">
                                                    ${patient.nom} ${patient.prenom}
                                            </div>
                                            <div class="text-xs text-gray-500">ID: ${patient.idPatient}</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    <i class="fas fa-envelope text-gray-400 mr-2"></i>
                                        ${patient.email}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-center text-sm">
                                    <div class="text-gray-900">
                                        <i class="fas fa-weight text-orange-500 mr-1"></i>
                                        <c:choose>
                                            <c:when test="${patient.poids != null}">
                                                <fmt:formatNumber value="${patient.poids}" pattern="0.0"/> kg
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="text-gray-500 text-xs">
                                        <i class="fas fa-ruler-vertical text-indigo-500 mr-1"></i>
                                        <c:choose>
                                            <c:when test="${patient.taille != null}">
                                                <fmt:formatNumber value="${patient.taille}" pattern="0.00"/> m
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-center">
                                    <c:if test="${patient.imc != null}">
                                        <c:choose>
                                            <c:when test="${patient.imc < 18.5}">
                                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                                        ${patient.imc}
                                                </span>
                                            </c:when>
                                            <c:when test="${patient.imc >= 18.5 && patient.imc < 25}">
                                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                        ${patient.imc}
                                                </span>
                                            </c:when>
                                            <c:when test="${patient.imc >= 25 && patient.imc < 30}">
                                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-orange-100 text-orange-800">
                                                        ${patient.imc}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                                        ${patient.imc}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                    <c:if test="${patient.imc == null}">
                                        <span class="text-gray-400 text-xs">Non calculé</span>
                                    </c:if>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-center">
                                    <span class="px-3 py-1 text-xs font-semibold rounded-full bg-indigo-100 text-indigo-800">
                                        ${patient.consultations.size()} total
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                    <button onclick='editPatient(${patient.idPatient}, "${patient.nom}", "${patient.prenom}", "${patient.email}", ${patient.poids}, ${patient.taille})'
                                            class="text-blue-600 hover:text-blue-900 mr-3">
                                        <i class="fas fa-edit"></i> Modifier
                                    </button>
                                    <button onclick="confirmDelete(${patient.idPatient}, '${patient.nom} ${patient.prenom}')"
                                            class="text-red-600 hover:text-red-900">
                                        <i class="fas fa-trash"></i> Supprimer
                                    </button>
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

<!-- Modal Modifier Patient -->
<div id="modal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center">
    <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full mx-4">
        <div class="p-6 border-b border-gray-200">
            <h3 class="text-xl font-bold text-gray-900">Modifier le Patient</h3>
        </div>
        <form id="patientForm" method="post" action="${pageContext.request.contextPath}/admin/patients">
            <div class="p-6 grid grid-cols-2 gap-4">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="patientId">

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Nom *</label>
                    <input type="text" name="nom" id="nom" required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Prénom *</label>
                    <input type="text" name="prenom" id="prenom" required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                </div>

                <div class="col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Email *</label>
                    <input type="email" name="email" id="email" required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Poids (kg) *</label>
                    <input type="number" name="poids" id="poids" step="0.1" min="1" max="500" required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Taille (m) *</label>
                    <input type="number" name="taille" id="taille" step="0.01" min="0.5" max="3" required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                </div>
            </div>
            <div class="p-6 bg-gray-50 flex justify-end space-x-3">
                <button type="button" onclick="closeModal()"
                        class="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400">
                    Annuler
                </button>
                <button type="submit"
                        class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                    <i class="fas fa-save mr-2"></i>Enregistrer
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function editPatient(id, nom, prenom, email, poids, taille) {
        document.getElementById('patientId').value = id;
        document.getElementById('nom').value = nom;
        document.getElementById('prenom').value = prenom;
        document.getElementById('email').value = email;
        document.getElementById('poids').value = poids || '';
        document.getElementById('taille').value = taille || '';
        document.getElementById('modal').classList.remove('hidden');
    }

    function closeModal() {
        document.getElementById('modal').classList.add('hidden');
    }

    function confirmDelete(id, nom) {
        if (confirm('Êtes-vous sûr de vouloir supprimer le patient ' + nom + ' ?\n\nCette action est irréversible et supprimera également toutes ses consultations passées.')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/patients';

            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'delete';

            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'id';
            idInput.value = id;

            form.appendChild(actionInput);
            form.appendChild(idInput);
            document.body.appendChild(form);
            form.submit();
        }
    }

    document.getElementById('modal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });

    // Calcul automatique de l'IMC lors de la saisie
    const poidsInput = document.getElementById('poids');
    const tailleInput = document.getElementById('taille');

    function calculateIMC() {
        const poids = parseFloat(poidsInput.value);
        const taille = parseFloat(tailleInput.value);

        if (poids && taille && taille > 0) {
            const imc = poids / (taille * taille);
            console.log('IMC calculé:', imc.toFixed(1));
        }
    }

    poidsInput.addEventListener('input', calculateIMC);
    tailleInput.addEventListener('input', calculateIMC);
</script>

</body>
</html>