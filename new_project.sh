#!/bin/bash
# Usage: newdbt <project_name>

set -e

PROJECTS_DIR="$HOME/Dbt"
PROFILES="$HOME/.dbt/profiles.yml"

# ── Load credentials from .env ─────────────────────────────────────────────────
ENV_FILE="$PROJECTS_DIR/.env"
if [ ! -f "$ENV_FILE" ]; then
  echo "Error: credentials file not found at $ENV_FILE"
  echo "Create it with your Snowflake credentials before running this script."
  exit 1
fi
source "$ENV_FILE"

# ── Prompt for project name if not passed as argument ──────────────────────────
if [ -z "$1" ]; then
  read -p "Project name (use underscores, no spaces): " PROJECT_NAME
else
  PROJECT_NAME="$1"
fi

# ── Prompt for project type ────────────────────────────────────────────────────
echo ""
echo "Where should this project live?"
echo "  1) experiments/  — throwaway, for learning a concept"
echo "  2) projects/     — real project you plan to keep"
read -p "Choose 1 or 2 (default: 1): " PROJECT_TYPE
PROJECT_TYPE="${PROJECT_TYPE:-1}"

if [ "$PROJECT_TYPE" = "2" ]; then
  PROJECT_DIR="$PROJECTS_DIR/projects/$PROJECT_NAME"
else
  PROJECT_DIR="$PROJECTS_DIR/experiments/$PROJECT_NAME"
fi

# ── Create the dbt project ─────────────────────────────────────────────────────
echo ""
echo "Creating dbt project: $PROJECT_NAME"
mkdir -p "$(dirname "$PROJECT_DIR")"
cd "$(dirname "$PROJECT_DIR")"
dbt init "$PROJECT_NAME" --skip-profile-setup

# ── Create a per-project venv ──────────────────────────────────────────────────
echo ""
echo "Creating virtual environment for $PROJECT_NAME..."
cd "$PROJECT_DIR"
python3 -m venv .venv
source .venv/bin/activate
pip install --quiet dbt-snowflake
echo "Virtual environment ready."

# ── Add profile to profiles.yml ────────────────────────────────────────────────
echo ""
echo "Adding Snowflake profile to profiles.yml..."

cat >> "$PROFILES" <<EOF

${PROJECT_NAME}:
  outputs:
    dev:
      type: snowflake
      account: ${DBT_ACCOUNT}
      user: ${DBT_USER}
      password: ${DBT_PASSWORD}
      role: ${DBT_ROLE}
      warehouse: ${DBT_WAREHOUSE}
      database: ${DBT_DATABASE}
      schema: ${PROJECT_NAME}
      threads: 4
  target: dev
EOF

# ── Test the connection ────────────────────────────────────────────────────────
echo ""
echo "Testing Snowflake connection..."
dbt debug

echo ""
echo "Done! Your project is ready at: $PROJECT_DIR"
echo "To activate this project's venv:"
echo "  cd $PROJECT_DIR && source .venv/bin/activate"
