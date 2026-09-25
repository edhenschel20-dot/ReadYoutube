#!/bin/bash
# Installs the media tools the vendored watch skill needs (ffmpeg, latest
# yt-dlp, Deno for YouTube) in Claude Code on the web sessions.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

export PATH="$HOME/.local/bin:$PATH"
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$CLAUDE_ENV_FILE"
fi

if ! command -v ffmpeg >/dev/null 2>&1 || ! command -v ffprobe >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get install -y -qq --no-install-recommends ffmpeg >/dev/null 2>&1 \
    || { apt-get update -qq >/dev/null && apt-get install -y -qq --no-install-recommends ffmpeg >/dev/null; }
fi

# watch supports only the latest yt-dlp; --upgrade keeps it current.
uv tool install -q --upgrade "yt-dlp[default,curl-cffi]"
uv tool install -q --upgrade deno

# Answer the watch first-run wizard once (auto engine: Gemini when
# GEMINI_API_KEY is set, local otherwise). Never overwrites an existing config.
if [ ! -f "$HOME/.config/watch/.env" ]; then
  python3 "$CLAUDE_PROJECT_DIR/.claude/skills/watch/scripts/setup.py" \
    --engine auto --detail balanced --backend none >/dev/null
fi
