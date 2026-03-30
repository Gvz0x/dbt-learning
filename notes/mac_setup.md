# Mac Setup Checklist

Follow these steps in order when setting up on a new Mac.

---

## Step 1 — Install prerequisites

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to shell (Apple Silicon Macs)
echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# Install pyenv and xz (required for Python builds)
brew install pyenv xz

# Add pyenv to shell
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zprofile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zprofile
echo 'eval "$(pyenv init -)"' >> ~/.zprofile
source ~/.zprofile

# Install Python 3.11.9
pyenv install 3.11.9

# Install GitHub CLI
brew install gh
```

---

## Step 2 — Authenticate GitHub and clone the repo

```bash
gh auth login
git clone https://github.com/Gvz0x/dbt-learning.git ~/Dbt
cd ~/Dbt
```

---

## Step 3 — Set up the learn_dbt venv

```bash
cd ~/Dbt
pyenv local 3.11.9
python3 -m venv .venv
source .venv/bin/activate
pip install dbt-snowflake
dbt --version   # confirm it shows 1.11.7
```

---

## Step 4 — Recreate .env (not in git — credentials stay off GitHub)

```bash
cat > ~/Dbt/.env << 'EOF'
DBT_ACCOUNT="kf42605.southeast-asia.azure"
DBT_USER="Gio"
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
  target: dev
  outputs:
    dev:
      type: snowflake
      account: kf42605.southeast-asia.azure
      user: Gio
      password: your-password-here
      role: dbt_role
      warehouse: dbt_warehouse
      database: dbt_database
      schema: learning_dbt
      threads: 4
EOF
```

Test the connection:
```bash
cd ~/Dbt/learn_dbt
source ~/Dbt/.venv/bin/activate
dbt debug
```

---

## Step 6 — Add shell shortcuts to ~/.zshrc

```bash
cat >> ~/.zshrc << 'EOF'

# ── dbt shortcut ──────────────────────────────────────────────────────────────
newdbt() {
  bash ~/Dbt/new_project.sh "$1"
}

# ── dbt learning session shortcut ─────────────────────────────────────────────
dbt-learn() {
  cd ~/Dbt/learn_dbt
  source ~/Dbt/.venv/bin/activate
  claude
}
EOF

source ~/.zshrc
```

---

## Step 7 — Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

---

## Step 8 — Verify everything works

```bash
source ~/Dbt/.venv/bin/activate
cd ~/Dbt/learn_dbt
dbt debug
dbt compile -s fct_funnel
dbt-learn
```

---

## Summary of path changes (Windows → Mac)

| What | Windows | Mac |
|------|---------|-----|
| Projects folder | `/c/Users/Angelo/Documents/dbt-projects` | `~/Dbt` |
| Venv location | `shared-venv/` (one for all) | `.venv/` (one per project) |
| Venv activate | `Scripts/activate` | `bin/activate` |
| Shell config | `~/.bashrc` | `~/.zshrc` |
| Python binary | `python` | `python3` (managed by pyenv) |
