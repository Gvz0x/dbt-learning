# dbt Shortcuts & Setup

## Create a new dbt project instantly

```bash
newdbt <project_name>
```

### What it does
1. Asks whether it's an experiment or a real project
2. Scaffolds the dbt project in `experiments/` or `projects/` accordingly
3. Adds a Snowflake profile to `~/.dbt/profiles.yml` automatically
4. Uses the project name as the Snowflake schema
5. Activates the shared venv and runs `dbt debug` to confirm the connection

### Where things live
| File | Location | Purpose |
|------|----------|---------|
| Shortcut function | `~/.bashrc` | Makes `newdbt` available in every terminal |
| Script | `dbt-projects/new_project.sh` | The actual logic |
| Credentials | `dbt-projects/.env` | Update here if Snowflake details change (never commit this file) |
| Shared venv | `dbt-projects/shared-venv/` | One Python env for all dbt projects |

### If `newdbt` is not recognised in a terminal
Run this once to reload your shortcuts:
```bash
source ~/.bashrc
```

---

## Continue a learning session

```bash
dbt-learn
```

Navigates to `learning_dbt`, activates the shared venv, and opens Claude.
Claude automatically reads your session notes and picks up where you left off
via the `/dbt-learn` custom command.

Session notes are at: `dbt-projects/notes/session_progress.md`
Update that file at the end of each session to track progress.

---

## Activate the shared venv manually

```bash
source /c/Users/Angelo/Documents/dbt-projects/shared-venv/Scripts/activate
```

All dbt projects use this one venv. You only need to activate it once per terminal session.

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
dbt-projects/
├── learning_dbt/      ← permanent concept sandbox
├── experiments/       ← throwaway projects (one per concept)
├── projects/          ← real projects you plan to keep
├── airflow/dags/      ← Airflow DAGs that orchestrate dbt runs
├── shared-venv/       ← one Python venv for all dbt projects
├── notes/             ← learning notes, cheatsheet, session progress
├── .env               ← Snowflake credentials (never commit)
└── new_project.sh     ← project scaffolding script
```
