<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gérer Salles - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- Définir la page active pour la sidebar -->
<c:set var="pageParam" value="salles" scope="request"/>

<!-- Inclure la sidebar -->
<%@ include file="../common/admin-nav.jsp" %>

    <!-- Header -->
    <div class="flex justify-between items-center mb-8">
        <div>
            <h1 class="text-3xl font-bold text-gray-900">Gestion des Salles</h1>
            <p class="text-gray-600 mt-1">Créer, modifier ou supprimer des salles de consultation</p>
        </div>
        <button onclick="openCreateModal()"
                class="px-6 py-3 bg-orange-600 text-white rounded-lg hover:bg-orange-700 transition shadow-lg">
            <i class="fas fa-plus mr-2"></i>
            Nouvelle Salle
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

    <!-- Liste des salles -->
    <div class="bg-white rounded-xl shadow-lg overflow-hidden">
        <div class="p-6 border-b border-gray-200">
            <h2 class="text-xl font-bold text-gray-900">
                <i class="fas fa-door-open mr-2 text-orange-600"></i>
                Liste des Salles (${salles.size()})
            </h2>
        </div>

        <c:choose>
            <c:when test="${empty salles}">
                <div class="p-12 text-center">
                    <i class="fas fa-door-open text-gray-300 text-6xl mb-4"></i>
                    <p class="text-gray-500 text-lg">Aucune salle enregistrée</p>
                    <button onclick="openCreateModal()"
                            class="mt-4 px-6 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700">
                        Créer la première salle
                    </button>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 p-6">
                    <c:forEach var="salle" items="${salles}">
                        <div class="bg-gradient-to-br from-orange-50 to-amber-50 border-2 border-orange-200 rounded-xl p-6 hover:shadow-lg transition">
                            <div class="flex items-center justify-between mb-4">
                                <div class="flex items-center">
                                    <div class="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center">
                                        <i class="fas fa-door-open text-orange-600 text-xl"></i>
                                    </div>
                                    <div class="ml-3">
                                        <h3 class="text-lg font-bold text-gray-900">${salle.nomSalle}</h3>
                                        <p class="text-sm text-gray-600">
                                            <i class="fas fa-users text-gray-400 mr-1"></i>
                                            Capacité: ${salle.capacite}
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <!-- Taux d'occupation -->
                            <div class="mb-4">
                                <div class="flex justify-between text-sm mb-1">
                                    <span class="text-gray-600">Occupation aujourd'hui</span>
                                    <span class="font-semibold text-gray-900">
                                        <fmt:formatNumber value="${tauxOccupation[salle.idSalle]}" pattern="0.0"/>%
                                    </span>
                                </div>
                                <div class="w-full bg-gray-200 rounded-full h-2">
                                    <div class="bg-orange-600 h-2 rounded-full transition-all duration-500"
                                         style="width: ${tauxOccupation[salle.idSalle]}%"></div>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="flex space-x-2">
                                <button onclick='editSalle(${salle.idSalle}, "${salle.nomSalle}", ${salle.capacite})'
                                        class="flex-1 px-3 py-2 bg-blue-600 text-white text-sm rounded-lg hover:bg-blue-700 transition">
                                    <i class="fas fa-edit mr-1"></i>
                                    Modifier
                                </button>
                                <button onclick="confirmDelete(${salle.idSalle}, '${salle.nomSalle}')"
                                        class="flex-1 px-3 py-2 bg-red-600 text-white text-sm rounded-lg hover:bg-red-700 transition">
                                    <i class="fas fa-trash mr-1"></i>
                                    Supprimer
                                </button>
                            </div>
                        </div>
                    </c:forEach>
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
        <form id="salleForm" method="post" action="${pageContext.request.contextPath}/admin/salles">
            <div class="p-6">
                <input type="hidden" name="action" id="formAction">
                <input type="hidden" name="id" id="salleId">

                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Nom de la Salle *
                    </label>
                    <input type="text"
                           name="nomSalle"
                           id="nomSalle"
                           required
                           placeholder="Ex: Salle 101"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Capacité *
                    </label>
                    <input type="number"
                           name="capacite"
                           id="capacite"
                           required
                           min="1"
                           max="100"
                           placeholder="Ex: 5"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent">
                    <p class="mt-1 text-xs text-gray-500">Entre 1 et 100 personnes</p>
                </div>
            </div>
            <div class="p-6 bg-gray-50 flex justify-end space-x-3">
                <button type="button"
                        onclick="closeModal()"
                        class="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400">
                    Annuler
                </button>
                <button type="submit"
                        class="px-4 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700">
                    <i class="fas fa-save mr-2"></i>
                    Enregistrer
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openCreateModal() {
        document.getElementById('modalTitle').textContent = 'Nouvelle Salle';
        document.getElementById('formAction').value = 'create';
        document.getElementById('salleId').value = '';
        document.getElementById('nomSalle').value = '';
        document.getElementById('capacite').value = '';
        document.getElementById('modal').classList.remove('hidden');
    }

    function editSalle(id, nomSalle, capacite) {
        document.getElementById('modalTitle').textContent = 'Modifier la Salle';
        document.getElementById('formAction').value = 'update';
        document.getElementById('salleId').value = id;
        document.getElementById('nomSalle').value = nomSalle;
        document.getElementById('capacite').value = capacite;
        document.getElementById('modal').classList.remove('hidden');
    }

    function closeModal() {
        document.getElementById('modal').classList.add('hidden');
    }

    function confirmDelete(id, nom) {
        if (confirm('Êtes-vous sûr de vouloir supprimer la salle "' + nom + '" ?\n\nCette action est irréversible.')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/salles';

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
</script>

</main>
</div>

</body>
</html>