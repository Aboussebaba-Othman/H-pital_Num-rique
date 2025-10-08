package com.othman.clinique.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.logging.Level;
import java.util.logging.Logger;

public final class JPAUtil {

    private static final Logger LOGGER = Logger.getLogger(JPAUtil.class.getName());
    private static final String PERSISTENCE_UNIT_NAME = "cliniquePU";

    /**
     * Holder pour lazy initialization thread-safe
     */
    private static class EntityManagerFactoryHolder {
        private static final EntityManagerFactory INSTANCE = createEntityManagerFactory();

        private static EntityManagerFactory createEntityManagerFactory() {
            try {
                LOGGER.info("Initialisation de l'EntityManagerFactory...");
                EntityManagerFactory emf = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);

                // Shutdown hook pour fermer proprement
                Runtime.getRuntime().addShutdownHook(new Thread(() -> {
                    LOGGER.info("Fermeture de l'EntityManagerFactory...");
                    if (emf.isOpen()) {
                        emf.close();
                    }
                }));

                LOGGER.info("EntityManagerFactory initialisé avec succès");
                return emf;
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Erreur lors de l'initialisation de l'EntityManagerFactory", e);
                throw new ExceptionInInitializerError("Impossible de créer l'EntityManagerFactory: " + e.getMessage());
            }
        }
    }

    /**
     * Constructeur privé pour empêcher l'instanciation
     */
    private JPAUtil() {
        throw new AssertionError("Cette classe ne doit pas être instanciée");
    }

    /**
     * Retourne l'instance unique de l'EntityManagerFactory
     * Lazy-loaded et thread-safe
     *
     * @return EntityManagerFactory
     */
    public static EntityManagerFactory getEntityManagerFactory() {
        return EntityManagerFactoryHolder.INSTANCE;
    }

    /**
     * Crée un nouvel EntityManager
     * ATTENTION: L'appelant DOIT fermer l'EntityManager après usage
     *
     * @return EntityManager nouveau
     * @throws IllegalStateException si l'EMF n'est pas disponible
     */
    public static EntityManager getEntityManager() {
        EntityManagerFactory emf = getEntityManagerFactory();

        if (emf == null || !emf.isOpen()) {
            LOGGER.severe("EntityManagerFactory n'est pas disponible");
            throw new IllegalStateException("EntityManagerFactory n'est pas disponible");
        }

        return emf.createEntityManager();
    }

    /**
     * Ferme un EntityManager de manière sécurisée
     * Gère le rollback automatique si une transaction est active
     *
     * @param em EntityManager à fermer (peut être null)
     */
    public static void close(EntityManager em) {
        if (em != null && em.isOpen()) {
            try {
                // Rollback si transaction active
                if (em.getTransaction().isActive()) {
                    LOGGER.warning("Transaction active lors de la fermeture - Rollback effectué");
                    em.getTransaction().rollback();
                }
                em.close();
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Erreur lors de la fermeture de l'EntityManager", e);
            }
        }
    }

    /**
     * Ferme l'EntityManagerFactory
     * À utiliser uniquement lors de l'arrêt de l'application
     */
    public static void closeFactory() {
        EntityManagerFactory emf = getEntityManagerFactory();
        if (emf != null && emf.isOpen()) {
            LOGGER.info("Fermeture manuelle de l'EntityManagerFactory");
            emf.close();
        }
    }

    /**
     * Vérifie si l'EntityManagerFactory est disponible
     *
     * @return true si disponible et ouvert
     */
    public static boolean isFactoryOpen() {
        try {
            EntityManagerFactory emf = getEntityManagerFactory();
            return emf != null && emf.isOpen();
        } catch (Exception e) {
            return false;
        }
    }
}