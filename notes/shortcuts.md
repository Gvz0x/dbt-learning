# dbt Shortcuts & Setup

## Create a new dbt project instantly

```bash
newdbt <project_name>
```

### What it does
1. Asks whether it's an experiment or a real project
2. Scaffolds the dbt project in `experiments/` or `projects/` accordingly
3. Creates a per-project `.venv` and installs `dbt-snowflake`
4. Adds a Snowflake profile to `~/.dbt/profiles.yml` automatically
5. Uses the project name as the Snowflake schema
6. Runs `dbt debug` to confirm the connection

### Where things live
| File | Location | Purpose |
|------|----------|---------|
| Shortcut function | `~/.zshrc` | Makes `newdbt` available in every terminal |
| Script | `~/Dbt/new_project.sh` | The actual logic |
| Credentials | `~/Dbt/.env` | Update here if Snowflake details change (never commit this file) |
| Per-project venv | `<project>/.venv/` | Isolated Python env per dbt project |

### If `newdbt` is not recognised in a terminal
Run this once to reload your shortcuts:
```bash
source ~/.zshrc
```

---

## Continue a learning session

```bash
dbt-learn
```

Navigates to `learn_dbt`, activates the venv, and opens Claude.
Session notes are at: `~/Dbt/notes/session_progress.md`
Update that file at the end of each session to track progress.

---

## Activate the learn_dbt venv manually

```bash
source ~/Dbt/.venv/bin/activate
```

Each dbt project has its own `.venv`. Activate it once per terminal session.

---

## Common dbt commands

```bash
dbt run              # build all models in Snowflake
dbt run -s my_model  # build one model
dbt debug            # test your Snowflake connection
dbt test             # run data tests
dbt build            # run + test together
dbt compile          # compile SQL without running it
dbt docs generate    # generate docs site
dbt docs serve       # open docs in browser
```

---

## Folder structure

```
~/Dbt/
├── learn_dbt/         ← permanent concept sandbox
│   └── .venv/         ← Python venv for this project
├── experiments/       ← throwaway projects (one per concept)
│   └── <name>/.venv/  ← each gets its own venv
├── projects/          ← real projects you plan to keep
├── airflow/dags/      ← Airflow DAGs that orchestrate dbt runs
├── notes/             ← learning notes, cheatsheet, session progress
├── .env               ← Snowflake credentials (never commit)
└── new_project.sh     ← project scaffolding script
```
