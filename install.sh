#!/usr/bin/env bash
set -euo pipefail

# Claude SEO Installer
# Wraps everything in main() to prevent partial execution on network failure
#
# [REPHLEX] This is the Rephlex Digital fork. Changes from upstream:
#   - Removed temp-dir git clone (installs from local repo checkout)
#   - Changed all cp operations to symlinks (ln -sfn)
#   - Main 'seo' skill dir stays real (venv lives inside it); contents are symlinked
#   - All fork changes are marked with [REPHLEX] for merge conflict resolution

main() {
    SKILL_DIR="${HOME}/.claude/skills/seo"
    AGENT_DIR="${HOME}/.claude/agents"
    # [REPHLEX] Upstream variables kept for reference but unused in fork mode:
    # REPO_URL="https://github.com/AgriciDaniel/claude-seo"
    # REPO_TAG="${CLAUDE_SEO_TAG:-v1.9.0}"

    # [REPHLEX] Install from local repo checkout instead of cloning
    REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

    echo "════════════════════════════════════════"
    echo "║   Claude SEO - Installer             ║"
    echo "║   Claude Code SEO Skill              ║"
    echo "║   [Rephlex fork — symlink mode]      ║"
    echo "════════════════════════════════════════"
    echo ""
    echo "Repo: ${REPO_DIR}"
    echo ""

    # Check prerequisites
    command -v python3 >/dev/null 2>&1 || { echo "✗ Python 3 is required but not installed."; exit 1; }
    # [REPHLEX] Removed git prerequisite check (not needed for local install)

    # Check Python version (3.10+ required)
    PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
    PYTHON_OK=$(python3 -c 'import sys; print(1 if sys.version_info >= (3, 10) else 0)')
    if [ "${PYTHON_OK}" = "0" ]; then
        echo "✗ Python 3.10+ is required but ${PYTHON_VERSION} was found."
        exit 1
    fi
    echo "✓ Python ${PYTHON_VERSION} detected"

    # Create directories
    mkdir -p "${SKILL_DIR}"
    mkdir -p "${AGENT_DIR}"

    # [REPHLEX] ── BEGIN FORK CHANGES ──────────────────────────────────
    # Upstream clones to a temp dir and copies files.
    # This fork symlinks from the local repo checkout instead.

    # Helper: create symlink, back up existing non-symlink targets
    symlink_item() {
        local source="$1"
        local target="$2"
        local name="$3"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            mv "$target" "${target}.bak"
        fi
        ln -sfn "$source" "$target"
        echo "  + $name"
    }

    # Main 'seo' skill — real directory with symlinked contents
    # (can't symlink the whole dir because the Python venv lives inside it)
    echo "→ Installing main seo skill (symlinks into real dir)..."
    for item in "${REPO_DIR}/skills/seo/"*; do
        [ -e "${item}" ] || continue
        item_name=$(basename "${item}")
        symlink_item "${item}" "${SKILL_DIR}/${item_name}" "seo/${item_name}"
    done

    # Symlink sub-skills
    echo "→ Installing sub-skills (symlinks)..."
    for skill_dir in "${REPO_DIR}/skills"/*/; do
        [ -d "${skill_dir}" ] || continue
        skill_name=$(basename "${skill_dir}")
        [ "${skill_name}" = "seo" ] && continue
        symlink_item "${skill_dir}" "${HOME}/.claude/skills/${skill_name}" "${skill_name}"
    done

    # Symlink schema templates into main seo skill dir
    if [ -d "${REPO_DIR}/schema" ]; then
        symlink_item "${REPO_DIR}/schema" "${SKILL_DIR}/schema" "seo/schema"
    fi

    # Symlink reference docs into main seo skill dir
    if [ -d "${REPO_DIR}/pdf" ]; then
        symlink_item "${REPO_DIR}/pdf" "${SKILL_DIR}/pdf" "seo/pdf"
    fi

    # Symlink agents
    echo "→ Installing subagents (symlinks)..."
    for agent_file in "${REPO_DIR}/agents/"*.md; do
        [ -f "${agent_file}" ] || continue
        agent_name=$(basename "${agent_file}")
        symlink_item "${agent_file}" "${AGENT_DIR}/${agent_name}" "${agent_name}"
    done

    # Symlink shared scripts into main seo skill dir
    if [ -d "${REPO_DIR}/scripts" ]; then
        symlink_item "${REPO_DIR}/scripts" "${SKILL_DIR}/scripts" "seo/scripts"
    fi

    # Symlink hooks into main seo skill dir
    if [ -d "${REPO_DIR}/hooks" ]; then
        symlink_item "${REPO_DIR}/hooks" "${SKILL_DIR}/hooks" "seo/hooks"
    fi

    # Symlink extensions (optional add-ons: dataforseo, banana, firecrawl)
    if [ -d "${REPO_DIR}/extensions" ]; then
        echo "→ Installing extensions (symlinks)..."
        for ext_dir in "${REPO_DIR}/extensions"/*/; do
            [ -d "${ext_dir}" ] || continue
            ext_name=$(basename "${ext_dir}")
            # Extension skills
            if [ -d "${ext_dir}skills" ]; then
                for ext_skill in "${ext_dir}skills"/*/; do
                    [ -d "${ext_skill}" ] || continue
                    ext_skill_name=$(basename "${ext_skill}")
                    symlink_item "${ext_skill}" "${HOME}/.claude/skills/${ext_skill_name}" "${ext_skill_name} (ext: ${ext_name})"
                done
            fi
            # Extension agents
            if [ -d "${ext_dir}agents" ]; then
                for agent_file in "${ext_dir}agents/"*.md; do
                    [ -f "${agent_file}" ] || continue
                    agent_name=$(basename "${agent_file}")
                    symlink_item "${agent_file}" "${AGENT_DIR}/${agent_name}" "${agent_name} (ext: ${ext_name})"
                done
            fi
            # Extension references
            if [ -d "${ext_dir}references" ]; then
                mkdir -p "${SKILL_DIR}/extensions/${ext_name}"
                symlink_item "${ext_dir}references" "${SKILL_DIR}/extensions/${ext_name}/references" "ext/${ext_name}/references"
            fi
            # Extension scripts
            if [ -d "${ext_dir}scripts" ]; then
                mkdir -p "${SKILL_DIR}/extensions/${ext_name}"
                symlink_item "${ext_dir}scripts" "${SKILL_DIR}/extensions/${ext_name}/scripts" "ext/${ext_name}/scripts"
            fi
        done
    fi

    # Symlink requirements.txt to skill dir so users can retry later
    symlink_item "${REPO_DIR}/requirements.txt" "${SKILL_DIR}/requirements.txt" "requirements.txt"

    # [REPHLEX] ── END FORK CHANGES ────────────────────────────────────

    # Install Python dependencies (venv preferred, --user fallback)
    echo "→ Installing Python dependencies..."
    VENV_DIR="${SKILL_DIR}/.venv"
    if [ -d "${VENV_DIR}" ] && [ -f "${VENV_DIR}/bin/python" ]; then
        echo "  ✓ Venv already exists at ${VENV_DIR} — skipping creation"
    elif python3 -m venv "${VENV_DIR}" 2>/dev/null; then
        # [REPHLEX] Use REPO_DIR path (requirements.txt symlink also works)
        "${VENV_DIR}/bin/pip" install --quiet -r "${REPO_DIR}/requirements.txt" 2>/dev/null && \
            echo "  ✓ Installed in venv at ${VENV_DIR}" || \
            echo "  ⚠  Venv pip install failed. Run: ${VENV_DIR}/bin/pip install -r ${SKILL_DIR}/requirements.txt"
    else
        pip install --quiet --user -r "${REPO_DIR}/requirements.txt" 2>/dev/null || \
        echo "  ⚠  Could not auto-install. Run: pip install --user -r ${SKILL_DIR}/requirements.txt"
    fi

    # Optional: Install Playwright browsers (for screenshot analysis)
    echo "→ Installing Playwright browsers (optional, for visual analysis)..."
    if [ -f "${VENV_DIR}/bin/playwright" ]; then
        "${VENV_DIR}/bin/python" -m playwright install chromium 2>/dev/null || \
        echo "  ⚠  Playwright install failed. Visual analysis will use WebFetch fallback."
    else
        python3 -m playwright install chromium 2>/dev/null || \
        echo "  ⚠  Playwright install failed. Visual analysis will use WebFetch fallback."
    fi

    echo ""
    echo "✓ Claude SEO installed successfully! (symlink mode)"
    echo ""
    echo "Usage:"
    echo "  1. Start Claude Code:  claude"
    echo "  2. Run commands:       /seo audit https://example.com"
    echo ""
    echo "Repo: ${REPO_DIR}"
    echo "Python deps: ${SKILL_DIR}/requirements.txt"
}

main "$@"
