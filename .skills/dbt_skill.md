Instructions pour l'assistant IA : Ce fichier définit le standard de développement pour ce projet. Lorsque l'utilisateur te demande de l'aider à coder ou de créer un modèle, tu DOIS appliquer strictement les règles et le workflow définis ci-dessous.

📏 1. Règles de Code (dbt Style Guide)
1.1 Structure des requêtes (CTEs)
Chaque modèle SQL doit obligatoirement respecter l'architecture suivante :

CTEs d'importation en haut du fichier (utilisation de ref() ou source()).
CTEs logiques au milieu (les transformations).
CTE finale nommée final.
Requête terminale qui est toujours un simple select * from final.
1.2 Nommage et Conventions
Toutes les clés primaires doivent être explicitement nommées et se terminer par _id (ex: order_id, et non juste id).
Tous les champs booléens doivent commencer par is_ ou has_ (ex: is_successful).
Les noms de modèles doivent être au pluriel (ex: stg_customers, fct_orders).
1.3 DRY (Don't Repeat Yourself)
Ne jamais coder de valeurs "en dur" (Hardcoding) dans la logique métier.
Utiliser la macro cents_to_euros() à chaque fois qu'un montant monétaire brut en centimes est rencontré.
🔄 2. Workflow Automatisé : "Création d'un Modèle"
Lorsque l'utilisateur te demande de créer un nouveau modèle dbt, tu dois exécuter les étapes suivantes de manière séquentielle :

Étape 1 : Création du fichier SQL
Crée le fichier .sql dans le sous-dossier approprié (models/staging/, models/intermediate/, ou models/marts/).
Rédige la requête en respectant la règle des CTEs.
Étape 2 : Ajout de la documentation YAML
Ouvre (ou crée) le fichier de documentation YAML correspondant (ex: _stg_models.yml).
Ajoute l'entrée pour le nouveau modèle.
Rédige une description claire du modèle (le description:).
Documente au minimum la clé primaire et les colonnes ayant subi une transformation métier importante.
Étape 3 : Implémentation des Tests
Dans le même fichier YAML, ajoute obligatoirement les tests génériques unique et not_null sur la colonne servant de clé primaire.
Si le modèle contient un champ status, ajoute un test accepted_values.
Étape 4 : Validation (Console)
Propose immédiatement à l'utilisateur d'exécuter la commande de build restreinte à ce modèle : dbt build --select nom_du_nouveau_modele
Si la commande échoue, analyse l'erreur et corrige le code de façon autonome jusqu'à ce que le build passe au vert.