# Guide d'utilisation de la Sidebar Admin

## Structure de la Sidebar

La sidebar admin est maintenant configurée comme un composant latéral fixe qui s'affiche sur toutes les pages administrateur.

## Comment utiliser la sidebar dans vos pages

### Structure de base d'une page admin

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Titre de votre page - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- Définir la page active pour la sidebar -->
<c:set var="pageParam" value="votre-page" scope="request"/>

<!-- Inclure la sidebar -->
<%@ include file="../common/admin-nav.jsp" %>

<!-- VOTRE CONTENU ICI -->
<div class="max-w-7xl mx-auto">
    <h1 class="text-3xl font-bold">Votre contenu</h1>
    <!-- ... reste du contenu ... -->
</div>

<!-- Fermeture des balises de la sidebar -->
</main>
</div>

</body>
</html>
```

### Étapes importantes

1. **Définir la page active** :
   ```jsp
   <c:set var="pageParam" value="nom-de-la-page" scope="request"/>
   ```
   Les valeurs possibles pour `pageParam` sont :
   - `dashboard` - Dashboard principal
   - `patients` - Gestion des patients
   - `docteurs` - Gestion des docteurs
   - `departements` - Gestion des départements
   - `salles` - Gestion des salles
   - `consultations` - Gestion des consultations
   - `statistiques` - Statistiques

2. **Inclure la sidebar** :
   ```jsp
   <%@ include file="../common/admin-nav.jsp" %>
   ```

3. **Ajouter votre contenu** :
   - Votre contenu sera automatiquement affiché dans la zone principale (avec un margin-left de 256px pour la sidebar)
   - Enveloppez votre contenu dans une div avec `max-w-7xl mx-auto` pour une largeur optimale

4. **Fermer les balises** :
   À la fin de votre page, fermez les balises ouvertes par la sidebar :
   ```jsp
   </main>
   </div>
   ```

## Structure de la sidebar (admin-nav.jsp)

La sidebar contient :
- **Header avec logo** : "Clinique Admin"
- **Menu de navigation** : Liens vers toutes les sections admin
- **Footer utilisateur** : Informations de l'utilisateur connecté et bouton de déconnexion

## Avantages de cette structure

✅ **Navigation cohérente** sur toutes les pages admin
✅ **Indicateur visuel** de la page active
✅ **Design moderne** avec Tailwind CSS
✅ **Responsive** (peut être étendu pour mobile)
✅ **Facile à maintenir** - un seul fichier pour la navigation

## Exemple complet

Consultez les fichiers suivants pour voir des implémentations complètes :
- `/src/main/webapp/WEB-INF/views/admin/dashboard.jsp`
- `/src/main/webapp/WEB-INF/views/admin/docteurs.jsp`
- `/src/main/webapp/WEB-INF/views/admin/departements.jsp`
- `/src/main/webapp/WEB-INF/views/admin/salles.jsp`
- `/src/main/webapp/WEB-INF/views/admin/statistiques.jsp`
