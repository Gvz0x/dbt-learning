# Mac Setup Checklist

Follow these steps in order when setting up on a new Mac.

---

## Step 1 — Install prerequisites

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/brew.sh/install.sh)"

# Install Python 3.11
brew install python@3.11

# Install git if not already installed
brew install git
```

---

## Step 2 — Clone the repo

```bash
cd ~/Documents
git clone <your-github-repo-url> dbt-projects
cd dbt-projects
```

---

## Step 3 — Create the shared venv

```bash
python3.11 -m venv shared-venv
source shared-venv/bin/activate
pip install dbt-snowflake
dbt --version   # confirm it shows 1.11.7
```

---

## Step 4 — Recreate .env (not in git — credentials stay off GitHub)

```bash
cat > ~/Documents/dbt-projects/.env << 'EOF'
DBT_ACCOUNT="kf42605.southeast-asia.azure"
DBT_USER="GIO"
DBT_PASSWORD="your-password-here"
DBT_ROLE="dbt_role"
DBT_WAREHOUSE="dbt_warehouse"
DBT_DATABASE="dbt_database"
EOF
```

---

## Step 5 — Set up dbt profile

```bash
mkdir -p ~/.dbt
cat > ~/.dbt/profiles.yml << 'EOF'
learning_dbt:
  outputs:
    dev:
      type: snowflake
      account: kf42605.southeast-asia.azure
      user: GIO
      password: your-password-here
      role: dbt_role
      warehouse: dbt_warehouse
      database: dbt_database
      schema: learning_dbt
      threads: 4
  target: dev
EOF
```

Test the connection:
```bash
cd ~/Documents/dbt-projects/learning_dbt
source ~/Documents/dbt-projects/shared-venv/bin/activate
dbt debug
```

---

## Step 6 — Fix Windows paths in these files

### `learning_dbt/.claude/settings.json`
Change `Scripts/activate` → `bin/activate` and update the path:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "source /Users/angelo/Documents/dbt-projects/shared-venv/bin/activate 2>/dev/null; true"
          }
        ]
      }
    ]
  }
}
```

### `new_project.sh`
Change line 6:
```bash
PROJECTS_DIR="/Users/angelo/Documents/dbt-projects"   # was /c/Users/Angelo/...
```
Change the venv activate lines from `Scripts/activate` → `bin/activate`.

---

## Step 7 — Set up shell shortcuts

Mac uses **zsh** by default (not bash). Add shortcuts to `~/.zshrc`:

```bash
cat >> ~/.zshrc << 'EOF'

# ── dbt shortcut ──────────────────────────────────────────────────────────────
newdbt() {
  bash /Users/angelo/Documents/dbt-projects/new_project.sh "$1"
}

# ── dbt learning session shortcut ─────────────────────────────────────────────
dbt-learn() {
  cd /Users/angelo/Documents/dbt-projects/learning_dbt
  source /Users/angelo/Documents/dbt-projects/shared-venv/bin/activate
  claude
}
EOF

source ~/.zshrc
```

---

## Step 8 — Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

Then copy your custom commands:
```bash
mkdir -p ~/.claude/commands
# Copy dbt-learn.md and dbt-quiz.md from your Windows machine
# or recreate them — they're in ~/.claude/commands/ on Windows
```

---

## Step 9 — Verify everything works

```bash
# Activate venv
source ~/Documents/dbt-projects/shared-venv/bin/activate

# Go to project
cd ~/Documents/dbt-projects/learning_dbt

# Test connection
dbt debug

# Test compile
dbt compile -s fct_funnel

# Launch Claude and continue learning
dbt-learn
```

---

## Summary of path changes (Windows → Mac)

| What | Windows | Mac |
|------|---------|-----|
| Projects folder | `/c/Users/Angelo/Documents/dbt-projects` | `/Users/angelo/Documents/dbt-projects` |
| Venv activate | `shared-venv/Scripts/activate` | `shared-venv/bin/activate` |
| Shell config | `~/.bashrc` | `~/.zshrc` |
| Python binary | `python` | `python3` or `python3.11` |
