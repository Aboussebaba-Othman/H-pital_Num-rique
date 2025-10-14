<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gérer Départements - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
*<body class="bg-gray-50">

<%@ include file="../common/admin-nav.jsp" %>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Header -->
    <div class="flex justify-between items-center mb-8">
        <div>
            <h1 class="text-3xl font-bold text-gray-900">Gestion des Départements</h1>
            <p class="text-gray-600 mt-1">Créer, modifier ou supprimer des départements médicaux</p>
        </div>
        <button onclick="openCreateModal()"
                class="px-6 py-3 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition shadow-lg">
            <i class="fas fa-plus mr-2"></i>
            Nouveau Département
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

    <!-- Liste des départements -->
    <div class="bg-white rounded-xl shadow-lg overflow-hidden">
        <div class="p-6 border-b border-gray-200">
            <h2 class="text-xl font-bold text-gray-900">
                <i class="fas fa-list mr-2 text-purple-600"></i>
                Liste des Départements (${departements.size()})
            </h2>
        </div>

        <c:choose>
            <c:when test="${empty departements}">
                <div class="p-12 text-center">
                    <i class="fas fa-building text-gray-300 text-6xl mb-4"></i>
                    <p class="text-gray-500 text-lg">Aucun département enregistré</p>
                    <button onclick="openCreateModal()"
                            class="mt-4 px-6 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700">
                        Créer le premier département
                    </button>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nom du Département</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nombre de Docteurs</th>
                            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Actions</th>
                        </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach var="dept" items="${departements}">
                            <tr class="hover:bg-gray-50 transition">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10 bg-purple-100 rounded-lg flex items-center justify-center">
                                            <i class="fas fa-building text-purple-600"></i>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900">${dept.nom}</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                        ${docteursCount[dept.idDepartement]} docteur(s)
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                    <button onclick='editDepartement(${dept.idDepartement}, "${dept.nom}")'
                                            class="text-blue-600 hover:text-blue-900 mr-4">
                                        <i class="fas fa-edit"></i> Modifier
                                    </button>
                                    <button onclick="confirmDelete(${dept.idDepartement}, '${dept.nom}')"
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

<!-- Modal Créer/Modifier -->
<div id="modal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center">
    <div class="bg-white rounded-xl shadow-2xl max-w-md w-full mx-4">
        <div class="p-6 border-b border-gray-200">
            <h3 id="modalTitle" class="text-xl font-bold text-gray-900"></h3>
        </div>
        <form id="departementForm" method="post" action="${pageContext.request.contextPath}/admin/departements">
            <div class="p-6">
                <input type="hidden" name="action" id="formAction">
                <input type="hidden" name="id" id="departementId">

                <label class="block text-sm font-medium text-gray-700 mb-2">
                    Nom du Département *
                </label>
                <input type="text"
                       name="nom"
                       id="nomDepartement"
                       required
                       placeholder="Ex: Cardiologie"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent">
            </div>
            <div class="p-6 bg-gray-50 flex justify-end space-x-3">
                <button type="button"
                        onclick="closeModal()"
                        class="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400">
                    Annuler
                </button>
                <button type="submit"
                        class="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700">
                    <i class="fas fa-save mr-2"></i>
                    Enregistrer
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openCreateModal() {
        document.getElementById('modalTitle').textContent = 'Nouveau Département';
        document.getElementById('formAction').value = 'create';
        document.getElementById('departementId').value = '';
        document.getElementById('nomDepartement').value = '';
        document.getElementById('modal').classList.remove('hidden');
    }

    function editDepartement(id, nom) {
        document.getElementById('modalTitle').textContent = 'Modifier le Département';
        document.getElementById('formAction').value = 'update';
        document.getElementById('departementId').value = id;
        document.getElementById('nomDepartement').value = nom;
        document.getElementById('modal').classList.remove('hidden');
    }

    function closeModal() {
        document.getElementById('modal').classList.add('hidden');
    }

    function confirmDelete(id, nom) {
        if (confirm('Êtes-vous sûr de vouloir supprimer le département "' + nom + '" ?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/departements';

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

    // Fermer modal en cliquant à l'extérieur
    document.getElementById('modal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });
</script>

</body>
</html>