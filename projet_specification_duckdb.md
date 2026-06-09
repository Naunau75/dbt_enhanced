# 🚀 Cahier des Charges : Projet E-Commerce Analytics (dbt + DuckDB)

## 🎯 Objectif du Projet
Transformer les données brutes d'une entreprise e-commerce fictive ("GreenShop") en un modèle de données en étoile robuste, testé, et documenté, prêt pour la Business Intelligence. Le tout en utilisant **DuckDB**, une base de données analytique locale ultra-rapide.

---

## 🛠 Stack Technique
- **Data Warehouse :** DuckDB (Base de données analytique in-process, zéro configuration).
- **Transformation :** `dbt-core` avec l'adaptateur `dbt-duckdb`.
- **Orchestration / CI-CD :** GitHub Actions.
- **Versionnement :** `uv` (Python), Git & GitHub.

---

## 📦 Phase 1 : Base de Données & Ingestion (DuckDB)

### 1.1 Configuration DuckDB
Contrairement à Postgres, DuckDB ne nécessite aucun compte ni serveur distant. La base de données sera simplement un fichier local géré de manière invisible par votre projet dbt.

### 1.2 Le Schéma Brut (Données sources via `dbt seed`)
Plutôt que d'insérer des requêtes SQL dans une base, vous utiliserez des fichiers `.csv`. Ces fichiers sont à placer dans le dossier `seeds/` de votre projet. Lors de la commande `dbt seed`, DuckDB va instantanément les lire et les transformer en tables SQL.

> [!IMPORTANT]
> **Spécifications des tables sources (`seeds`) :**
> - **`raw_customers.csv`** : `id` (int), `first_name` (varchar), `last_name` (varchar), `email` (varchar), `created_at` (timestamp), `country` (varchar).
> - **`raw_products.csv`** : `sku` (varchar), `name` (varchar), `category` (varchar), `price_cents` (int).
> - **`raw_orders.csv`** : `id` (int), `customer_id` (int), `ordered_at` (timestamp), `status` (varchar: 'pending', 'shipped', 'cancelled').
> - **`raw_payments.csv`** : `id` (int), `order_id` (int), `amount_cents` (int), `payment_method` (varchar), `is_successful` (boolean).

---

## 🏗 Phase 2 : Modélisation dbt (Les Specs)

Initialisez votre projet en local (`dbt init dbt_ecommerce`). Configurez votre fichier `profiles.yml` pour utiliser DuckDB en spécifiant simplement un nom de fichier local :
```yaml
dbt_ecommerce:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: 'dev.duckdb'