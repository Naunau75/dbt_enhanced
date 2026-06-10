# 🚀 dbt_enhanced - E-Commerce Analytics Pipeline

> Une pipeline de données complète et production-ready pour transformer les données brutes d'une plateforme e-commerce en un modèle de données analytique robuste.

## 📋 Vue d'ensemble

**dbt_enhanced** est un projet dbt moderne qui implémente une architecture de transformation de données complète (ELT) pour l'e-commerce **GreenShop** avec :
- ✅ Modélisation en étoile (Star Schema)
- ✅ Tests de qualité automatisés
- ✅ CI/CD via GitHub Actions
- ✅ DuckDB comme data warehouse analytique
- ✅ Documentation complète des modèles
- ✅ Conventions SQL standardisées

**Stack technique :**
| Composant | Technologie |
|-----------|-------------|
| **Data Transformation** | dbt-core 1.8+ |
| **Adaptateur dbt** | dbt-duckdb 1.10.1+ |
| **Data Warehouse** | DuckDB (in-process, zéro configuration) |
| **Runtime Python** | Python 3.12+ |
| **Gestionnaire de dépendances** | uv (ultra-rapide) |
| **Données sources** | CSV (dbt seed) |
| **Versioning & CI/CD** | Git + GitHub Actions |

---

## 🏗 Architecture du Projet

```
dbt_enhanced/
├── 📁 dbt_ecommerce/              # Cœur du projet dbt
│   ├── 📁 models/
│   │   ├── staging/              # Nettoyage et typage (raw → staging)
│   │   ├── intermediate/         # Jointures complexes et dérivations
│   │   └── marts/                # Tables finales en étoile (analytique)
│   ├── 📁 seeds/                 # Données sources (CSV)
│   │   ├── raw_customers.csv
│   │   ├── raw_products.csv
│   │   ├── raw_orders.csv
│   │   └── raw_payments.csv
│   ├── 📁 tests/                 # Tests de qualité des données
│   ├── 📁 macros/                # Macros réutilisables dbt
│   ├── 📁 analyses/              # Analyses ad-hoc et reporting
│   ├── 📁 snapshots/             # Capture de l'historique des données
│   ├── dbt_project.yml           # Configuration dbt
│   ├── profiles.yml              # Connexion DuckDB
│   └── README.md                 # Documentation locale dbt
│
├── 📁 .github/
│   └── workflows/                # Pipelines CI/CD (GitHub Actions)
│       └── dbt_pipeline.yml      # Validation & déploiement dbt
│
├── 📁 logs/                       # Logs générés par dbt
├── pyproject.toml                # Configuration UV + dépendances
├── uv.lock                       # Lock file des dépendances
├── .python-version               # Python 3.12
├── .gitignore                    # Fichiers ignorés par Git
├── .cursorrules                  # Conventions du projet
├── projet_specification_duckdb.md # Spécifications détaillées (FR)
└── README.md                     # Ce fichier
```

---

## 🎯 Modèles de Données

### 1️⃣ **Staging Layer** (`models/staging/`)
Préparation des données brutes : typage, renommage, validations basiques.

**Modèles :**
- `stg_customers` : Clients nettoyés
- `stg_products` : Produits typés
- `stg_orders` : Commandes harmonisées
- `stg_payments` : Paiements validés

### 2️⃣ **Intermediate Layer** (`models/intermediate/`)
Résolution des jointures complexes et dérivations métier.

**Modèles :**
- `int_orders_with_customers` : Jointure Commandes ↔ Clients
- `int_orders_with_payments` : Enrichissement avec paiements
- `int_revenue_metrics` : Calcul des métriques de revenus

### 3️⃣ **Marts Layer** (`models/marts/`)
Tables finales optimisées pour la BI en architecture étoile.

**Fact Tables :**
- `fct_orders` : Table de faits principale (materialized: incremental)
  - PK: `order_id`
  - Colonnes: `customer_id`, `product_id`, `ordered_at`, `status`, `total_amount_cents`

**Dimension Tables :**
- `dim_customers` : Dimensions clients
- `dim_products` : Dimensions produits
- `dim_dates` : Calendrier (optionnel pour les analytics)

---

## 🔧 Installation & Setup

### Prérequis
- **Python 3.12+** (spécifié dans `.python-version`)
- **Git**
- **Accès à GitHub** (clone du repo)

### 1. Cloner le repo
```bash
git clone https://github.com/Naunau75/dbt_enhanced.git
cd dbt_enhanced
```

### 2. Installer les dépendances avec `uv`
```bash
# Installation de uv (si pas fait)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Créer l'environnement Python et installer les dépendances
uv sync
```

### 3. Vérifier l'installation
```bash
# Activer l'environnement
source .venv/bin/activate  # Linux/macOS
# ou
.venv\Scripts\activate     # Windows

# Vérifier dbt
dbt --version
# Output: dbt version 1.8.x
```

---

## 🚀 Commandes Essentielles

### Initialiser la base de données
```bash
cd dbt_ecommerce

# 1. Charger les données sources (CSV → DuckDB)
dbt seed

# 2. Générer et compiler les modèles
dbt parse

# 3. Lancer les transformations
dbt run

# 4. Exécuter les tests de qualité
dbt test

# 5. Générer la documentation
dbt docs generate
dbt docs serve  # Ouvre http://localhost:8000
```

### Commandes pratiques
```bash
# 🔍 Compiler et examiner une requête générée
dbt compile --select stg_customers

# 🧪 Exécuter uniquement les tests d'un modèle
dbt test --select stg_customers

# 🔄 Réexécuter les modèles « incremental »
dbt run --full-refresh

# 📊 Générer un DAG des dépendances (require: Graphviz)
dbt docs generate && dbt docs serve

# 🧹 Nettoyer les artefacts
dbt clean
```

---

## 📊 Architecture des Transformations

```
┌─────────────────────────────────────────┐
│         Raw Data (CSV / Seeds)          │
│  - raw_customers.csv                    │
│  - raw_products.csv                     │
│  - raw_orders.csv                       │
│  - raw_payments.csv                     │
└──────────────────┬──────────────────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │   STAGING LAYER      │
        │  (typage, nettoyage) │
        │  - stg_customers     │
        │  - stg_products      │
        │  - stg_orders        │
        │  - stg_payments      │
        └──────────┬───────────┘
                   │
                   ▼
        ┌──────────────────────────┐
        │  INTERMEDIATE LAYER      │
        │  (jointures complexes)   │
        │  - int_orders_customers  │
        │  - int_orders_payments   │
        │  - int_revenue_metrics   │
        └──────────┬───────────────┘
                   │
                   ▼
        ┌──────────────────────────┐
        │   MARTS LAYER (BI)       │
        │   (Star Schema)          │
        │                          │
        │  Dimension Tables:       │
        │  - dim_customers         │
        │  - dim_products          │
        │                          │
        │  Fact Tables:            │
        │  - fct_orders (INCREMENTAL)
        └──────────────────────────┘
```

---

## 🧪 Qualité des Données

Chaque modèle dbt inclut un fichier YAML avec des tests de qualité génériques :

```yaml
# dbt_ecommerce/models/marts/schema.yml
models:
  - name: fct_orders
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
      - name: customer_id
        tests:
          - not_null
          - relationships:
              to: ref('dim_customers')
              field: customer_id
```

**Tests automatisés :**
- ✅ `unique` : Pas de doublons
- ✅ `not_null` : Pas de valeurs NULL
- ✅ `relationships` : Intégrité référentielle (FK)
- ✅ Tests personnalisés : logique métier

---

## 🔄 CI/CD avec GitHub Actions

La pipeline `.github/workflows/dbt_pipeline.yml` automatise :

1. **Parse & Validate** : Compilation et validation de la syntaxe dbt
2. **dbt run** : Exécution des modèles
3. **dbt test** : Validation de la qualité des données
4. **Docs Generate** : Génération de la documentation
5. **Notifications** : Slack / Email en cas d'erreur

**Déclenchement :**
- ✅ À chaque push sur `main`
- ✅ Sur demande (workflow_dispatch)
- ✅ À chaque Pull Request

---

## 📝 Conventions de Code

### 📋 Naming
| Type | Exemple | Description |
|------|---------|-------------|
| **Table Staging** | `stg_customers` | Sources nettoyées |
| **Table Intermédiaire** | `int_orders_with_payments` | Jointures complexes |
| **Fact Table** | `fct_orders` | Table de faits (PK: `order_id`) |
| **Dim Table** | `dim_customers` | Dimension (PK: `customer_key`) |
| **Clé Primaire** | `order_id` | Suffixe `_id` |
| **Foreign Key** | `customer_id` | Référence à `dim_customers` |
| **Boolean** | `is_successful`, `has_payment` | Préfixe `is_` ou `has_` |

### 🎨 Formatage SQL
```sql
-- ✅ CORRECT
select
    order_id,
    customer_id,
    total_amount_cents,
    is_paid,
from {{ ref('stg_orders') }}
where status != 'cancelled'

-- ❌ INCORRECT
SELECT order_id, customer_id FROM {{ ref('stg_orders') }}
```

---

## 📦 Dépendances

```toml
# pyproject.toml
dependencies = [
    "dbt-duckdb>=1.10.1",  # Adaptateur dbt pour DuckDB
    "faker>=40.21.0",      # Génération de données de test
    "python-dotenv>=1.2.2" # Gestion des variables d'env
]
```

Installer ou mettre à jour :
```bash
uv sync
```

---

## 🔐 Variables d'Environnement

Créer un fichier `.env` à la racine du projet (non-committed) :

```env
# .env
DBT_PROJECT_DIR=./dbt_ecommerce
DUCKDB_PATH=./dbt_ecommerce/dev.duckdb
```

Charger les variables :
```bash
source .env  # Linux/macOS
# ou
set -a && source .env && set +a
```

---

## 🐛 Dépannage

### Erreur : `Profile 'dbt_ecommerce' not found`
```bash
# Solution : Vérifier le profil dans profiles.yml
cat dbt_ecommerce/profiles.yml

# Assurez-vous que dbt_ecommerce/ est bien le répertoire courant
cd dbt_ecommerce
```

### Erreur : `dbt-duckdb not installed`
```bash
# Solution : Réinstaller avec uv
uv sync --reinstall
```

### Erreur : `Test failed on fct_orders`
```bash
# Afficher le détail du test
dbt test --select fct_orders --debug

# Inspecter les données
dbt run-operation audit_table --args '{"table": "fct_orders"}'
```

---

## 📚 Documentation Complète

| Document | Lien | Description |
|----------|------|-------------|
| **Spécifications** | `projet_specification_duckdb.md` | Cahier des charges complet (FR) |
| **Conventions** | `.cursorrules` | Règles de code et conventions |
| **Docs dbt** | `dbt docs serve` | Documentation interactive des modèles |

---

## 👤 Auteur & Crédits

- **Auteur** : [@Naunau75](https://github.com/Naunau75)
- **Plateforme** : GitHub
- **Topics** : `#dbt` `#duckdb` `#analytics` `#cicd` `#elt`

---

## 📄 Licence & Contribution

Ce projet est **open source**. Les contributions sont bienvenues ! 🎉

---

## 🔗 Ressources Utiles

### Officiel
- 📖 [Documentation dbt](https://docs.getdbt.com/)
- 📖 [Documentation DuckDB](https://duckdb.org/docs/)
- 📖 [Documentation dbt-duckdb](https://github.com/dbt-labs/dbt-duckdb)
- 💬 [Community dbt Slack](https://community.getdbt.com/)

### Tutoriels
- 🎓 [Tutoriel dbt University](https://learn.getdbt.com/)
- 🎓 [DuckDB Getting Started](https://duckdb.org/docs/guides/index)

---

## 🚦 Statut du Projet

| Phase | Statut | Description |
|-------|--------|-------------|
| **Phase 1** | ✅ Complète | DB & Ingestion (Seeds DuckDB) |
| **Phase 2** | 🔄 En cours | Modélisation dbt (Staging → Marts) |
| **Phase 3** | ⏳ Planifiée | Tests & Documentation complète |
| **Phase 4** | ⏳ Planifiée | CI/CD & Orchestration (GitHub Actions) |

---

## 📧 Support

Pour toute question, création d'issue sur le repo :  
🔗 [GitHub Issues](https://github.com/Naunau75/dbt_enhanced/issues)

---

**Dernière mise à jour** : Juin 2026  
**Version du projet** : 0.1.0
