<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gérer Docteurs - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">

<%@ include file="../common/admin-nav.jsp" %>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header -->
    <div class="flex justify-between items-center mb-8">
        <div>
            <h1 class="text-3xl font-bold text-gray-900">Gestion des Docteurs</h1>
            <p class="text-gray-600 mt-1">Créer, modifier ou supprimer des docteurs</p>
        </div>
        <button onclick="openCreateModal()"
                class="px-6 py-3 bg-green-600 text-white rounded-lg hover:bg-green-700 transition shadow-lg">
            <i class="fas fa-user-plus mr-2"></i>
            Nouveau Docteur
        </button>
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

    <!-- Filtres de recherche -->
    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
        <form method="get" action="${pageContext.request.contextPath}/admin/docteurs" class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <input type="hidden" name="action" value="search">

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Rechercher</label>
                <input type="text"
                       name="search"
                       value="${searchTerm}"
                       placeholder="Nom, prénom, email..."
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Spécialité</label>
                <input type="text"
                       name="specialite"
                       placeholder="Ex: Cardiologie"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Département</label>
                <select name="departementId" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                    <option value="">Tous</option>
                    <c:forEach var="dept" items="${departements}">
                        <option value="${dept.idDepartement}">${dept.nom}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="flex items-end">
                <button type="submit" class="w-full px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">
                    <i class="fas fa-search mr-2"></i>Filtrer
                </button>
            </div>
        </form>
    </div>

    <!-- Liste des docteurs -->
    <div class="bg-white rounded-xl shadow-lg overflow-hidden">
        <div class="p-6 border-b border-gray-200">
            <h2 class="text-xl font-bold text-gray-900">
                <i class="fas fa-user-md mr-2 text-green-600"></i>
                Liste des Docteurs (${docteurs.size()})
            </h2>
        </div>

        <c:choose>
            <c:when test="${empty docteurs}">
                <div class="p-12 text-center">
                    <i class="fas fa-user-md text-gray-300 text-6xl mb-4"></i>
                    <p class="text-gray-500 text-lg">Aucun docteur trouvé</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Docteur</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Spécialité</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Département</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Contact</th>
                            <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">Consultations</th>
                            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Actions</th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach var="doc" items="${docteurs}">
                            <tr class="hover:bg-gray-50 transition">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-12 w-12 bg-green-100 rounded-full flex items-center justify-center">
                                            <i class="fas fa-user-md text-green-600 text-xl"></i>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900">
                                                Dr. ${doc.nom} ${doc.prenom}
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                                            ${doc.specialite}
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    <i class="fas fa-building text-purple-600 mr-2"></i>
                                        ${doc.departement.nom}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    <i class="fas fa-envelope text-gray-400 mr-2"></i>
                                        ${doc.email}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-center">
                                    <span class="px-2 py-1 text-xs font-semibold rounded bg-indigo-100 text-indigo-800">
                                        ${doc.planning.size()} total
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                    <button onclick='editDocteur(${doc.idDocteur}, "${doc.nom}", "${doc.prenom}", "${doc.email}", "${doc.specialite}", ${doc.departement.idDepartement})'
                                            class="text-blue-600 hover:text-blue-900 mr-4">
                                        <i class="fas fa-edit"></i> Modifier
                                    </button>
                                    <button onclick="confirmDelete(${doc.idDocteur}, '${doc.nom} ${doc.prenom}')"
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

<div id="modalCreate" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center">
    <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto">
        <div class="p-6 border-b border-gray-200 sticky top-0 bg-white">
            <h3 class="text-xl font-bold text-gray-900">Créer un Nouveau Docteur</h3>
        </div>
        <form id="createForm" method="post" action="${pageContext.request.contextPath}/admin/docteurs">
            <div class="p-6 grid grid-cols-2 gap-4">
                <input type="hidden" name="action" value="create">

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Nom *</label>
                    <input type="text" name="nom" id="createNom" required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Prénom *</label>
                    <input type="text" name="prenom" id="createPrenom" required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                </div>

                <div class="col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Email *</label>
                    <input type="email" name="email" id="createEmail" required
                           placeholder="exemple@clinique.com"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                </div>

                <div class="col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Mot de passe *</label>
                    <input type="password" name="password" id="createPassword" required
                           minlength="8"
                           placeholder="Minimum 8 caractères"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                    <p class="mt-1 text-xs text-gray-500">Le mot de passe doit contenir au moins 8 caractères</p>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Spécialité *</label>
                    <input type="text" name="specialite" id="createSpecialite" required
                           placeholder="Ex: Cardiologie"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Département *</label>
                    <select name="departementId" id="createDepartementId" required
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                        <option value="">Sélectionner un département</option>
                        <c:forEach var="dept" items="${departements}">
                            <option value="${dept.idDepartement}">${dept.nom}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="p-6 bg-gray-50 flex justify-end space-x-3 sticky bottom-0">
                <button type="button" onclick="closeCreateModal()"
                        class="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400">
                    Annuler
                </button>
                <button type="submit"
                        class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">
                    <i class="fas fa-save mr-2"></i>Créer le Docteur
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Modifier Docteur -->
<div id="modalEdit" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center">
    <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full mx-4">
        <div class="p-6 border-b border-gray-200">
            <h3 class="text-xl font-bold text-gray-900">Modifier le Docteur</h3>
        </div>
        <form id="editForm" method="post" action="${pageContext.request.contextPath}/admin/docteurs">
            <div class="p-6 grid grid-cols-2 gap-4">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="editDocteurId">

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Nom *</label>
                    <input type="text" name="nom" id="editNom" required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Prénom *</label>
                    <input type="text" name="prenom" id="editPrenom" required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                </div>

                <div class="col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Email *</label>
                    <input type="email" name="email" id="editEmail" required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Spécialité *</label>
                    <input type="text" name="specialite" id="editSpecialite" required
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Département *</label>
                    <select name="departementId" id="editDepartementId" required
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                        <c:forEach var="dept" items="${departements}">
                            <option value="${dept.idDepartement}">${dept.nom}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="p-6 bg-gray-50 flex justify-end space-x-3">
                <button type="button" onclick="closeEditModal()"
                        class="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400">
                    Annuler
                </button>
                <button type="submit"
                        class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">
                    <i class="fas fa-save mr-2"></i>Enregistrer
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Modal de création
    function openCreateModal() {
        document.getElementById('createForm').reset();
        document.getElementById('modalCreate').classList.remove('hidden');
    }

    function closeCreateModal() {
        document.getElementById('modalCreate').classList.add('hidden');
    }

    // Modal d'édition
    function editDocteur(id, nom, prenom, email, specialite, departementId) {
        document.getElementById('editDocteurId').value = id;
        document.getElementById('editNom').value = nom;
        document.getElementById('editPrenom').value = prenom;
        document.getElementById('editEmail').value = email;
        document.getElementById('editSpecialite').value = specialite;
        document.getElementById('editDepartementId').value = departementId;
        document.getElementById('modalEdit').classList.remove('hidden');
    }

    function closeEditModal() {
        document.getElementById('modalEdit').classList.add('hidden');
    }

    function confirmDelete(id, nom) {
        if (confirm('Êtes-vous sûr de vouloir supprimer le Dr. ' + nom + ' ?\n\nCette action est irréversible.')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/docteurs';

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

    document.getElementById('modalCreate').addEventListener('click', function(e) {
        if (e.target === this) closeCreateModal();
    });

    document.getElementById('modalEdit').addEventListener('click', function(e) {
        if (e.target === this) closeEditModal();
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeCreateModal();
            closeEditModal();
        }
    });
</script>

</body>
</html>