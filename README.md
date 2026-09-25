# ReadYoutube

Turn any YouTube tutorial into a working Claude Code agent. Two AIs watch the video separately, their notes are reconciled into one labelled spec, and skill-creator builds the agent from it.

1. **Claude reads it.** The [`watch`](https://github.com/bradautomates/claude-video) skill gives Claude timestamped frames plus the transcript.
2. **Gemini reads it.** Gemini watches the same video natively, through `watch --engine gemini` or the Gemini app.
3. **Reconcile.** Both reads are merged into `specs/<slug>/spec.md`, and every line is labelled `CONFIRMED`, `SINGLE SOURCE` or `CONFLICT`.
4. **You check only the conflicts.**
5. **Build.** skill-creator writes the agent into `.claude/skills/<slug>/`.

The pipeline lives in [`.claude/skills/youtube-to-agent/SKILL.md`](.claude/skills/youtube-to-agent/SKILL.md).

## Setup

1. **Install the `watch` skill** (third-party, MIT, by bradautomates). Inside Claude Code:
   ```
   /plugin marketplace add bradautomates/claude-video
   /plugin install watch@claude-video
   ```
   In the Claude Desktop app, use Customize → Plugins → Add marketplace → `https://github.com/bradautomates/claude-video`, then install **Watch**. The interactive `/plugin` installer isn't available in Claude Code on the web.
2. **Media tools**: Python 3.10+, `ffmpeg`, the latest `yt-dlp`, and Deno (needed for YouTube). Ask Claude to "run the watch skill's setup.py to check dependencies".
3. **Gemini key** (optional but recommended): get a free key at https://aistudio.google.com/apikey and put it in `~/.config/watch/.env` as `GEMINI_API_KEY=...`. Never commit it. Without a key, paste the extraction prompt from the skill into the Gemini app yourself.

## Use

In a Claude Code session in this repo:

```
Use the youtube-to-agent skill on https://www.youtube.com/watch?v=...
```
