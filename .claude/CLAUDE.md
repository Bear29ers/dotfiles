# Global Claude Code Instructions

## Commit Message Convention

Always use **commitizen with cz-emoji** format for all git commits. The format is:

```
:emoji_code: scope: description
```

Max subject length: 72 characters. Pick the emoji code that best matches the change.

### Commit Type Reference (frequently used)

| Code | Scope | Description |
|------|-------|-------------|
| `:sparkles:` | `feat:` | Introduce new features |
| `:bug:` | `fix:` | Fix a bug |
| `:wrench:` | `conf:` | Add or update configuration files |
| `:white_check_mark:` | `test:` | Add, update, or pass tests |
| `:recycle:` | `refa:` | Refactor code |
| `:lipstick:` | `ui:` | Add or update the UI and style files |
| `:fire:` | `rem:` | Remove code or files |
| `:pencil:` | `docs:` | Add or update documentation |
| `:truck:` | `mv:` | Move or rename resources |
| `:iphone:` | `resp:` | Work on responsive design |
| `:construction:` | `wip:` | Work in progress |
| `:heavy_plus_sign:` | `dpad:` | Add a dependency |
| `:bento:` | `asst:` | Add or update assets |
| `:adhesive_bandage:` | `ish:` | Simple fix for a non-critical issue |
| `:package:` | `dpup:` | Add or update compiled files or packages |
| `:label:` | `type:` | Add or update types |
| `:dizzy:` | `anm:` | Add or update animations and transitions |
| `:see_no_evil:` | `ign:` | Add or update a .gitignore file |

If none of the above fit, consult the full 59-type table in
`~/.claude/references/cz-emoji-types.md`.

## Test Code

When writing, modifying, or reviewing test code, ALWAYS use the `test-quality` skill.

## Session Handover

- At the start of each session, check the `.claude/handovers/` directory in the project root and read the latest file if one exists
- At the end of a session or at a natural stopping point, prompt the user to run `/handover`
