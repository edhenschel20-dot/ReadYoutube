# ReadYoutube

Turn any YouTube tutorial into a working Claude Code agent. Two AIs watch the video separately, their notes are reconciled into one labelled spec, and skill-creator builds the agent from it.

1. **Claude reads it.** The [`watch`](https://github.com/bradautomates/claude-video) skill gives Claude timestamped frames plus the transcript.
2. **Gemini reads it.** Gemini watches the same video natively, through `watch --engine gemini` or the Gemini app.
3. **Reconcile.** Both reads are merged into `specs/<slug>/spec.md`, and every line is labelled `CONFIRMED`, `SINGLE SOURCE` or `CONFLICT`.
4. **You check only the conflicts.**
5. **Build.** skill-creator writes the agent into `.claude/skills/<slug>/`.

The pipeline lives in [`.claude/skills/youtube-to-agent/SKILL.md`](.claude/skills/youtube-to-agent/SKILL.md).

## Setup

Everything lives in this repo, so it works in Claude Code on the web as well as locally:

- **`watch` skill**: copied into `.claude/skills/watch/` from [bradautomates/claude-video](https://github.com/bradautomates/claude-video) v0.3.2 (commit `03ceb42`, MIT). To update it, copy `skills/watch/` from a newer release over this folder.
- **Media tools**: `.claude/hooks/session-start.sh` runs at the start of every web session. It installs `ffmpeg`, the latest `yt-dlp` and Deno, and applies watch's default settings (auto engine, balanced detail, captions only). Locally, install them yourself; see the watch skill's README.
- **Gemini key**: set `GEMINI_API_KEY` as an environment secret (web) or in `~/.config/watch/.env` (local). Get one free at https://aistudio.google.com/apikey. Never commit it.
- **Network (web only)**: the Gemini read only needs `generativelanguage.googleapis.com`. The Claude read downloads the video, so the environment must allow `youtube.com`, `www.youtube.com`, `googlevideo.com` and `*.googlevideo.com`. Otherwise run it in local Claude Code, or hand it a video file.

## Use

In a Claude Code session in this repo:

```
Use the youtube-to-agent skill on https://www.youtube.com/watch?v=...
```
