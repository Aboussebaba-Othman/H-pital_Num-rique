<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Erreur</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gradient-to-br from-gray-900 to-gray-800 min-h-screen flex items-center justify-center">
<div class="text-center text-white">
    <i class="fas fa-exclamation-triangle text-6xl text-yellow-500 mb-6"></i>
    <h1 class="text-4xl font-bold mb-4">Une erreur est survenue</h1>
    <p class="text-gray-300 mb-8">${error != null ? error : "Erreur système"}</p>
    <a href="${pageContext.request.contextPath}/admin/dashboard"
       class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 inline-block">
        <i class="fas fa-home mr-2"></i>
        Retour au tableau de bord
    </a>
</div>
</body>
</html>