# Generate Session Handover Note

Generate a handover note at the end of a session or at a natural stopping point.

## Steps

1. Review what was accomplished in the current session
2. Create the `.claude/handovers/` directory in the project root if it does not exist
3. Generate a handover note with the filename `YYYY-MM-DD_HHmm.md` (e.g. `2026-02-17_1430.md`)
4. If a file with the same name already exists, append a suffix such as `_2`

## Handover Note Structure

Always include the following sections. Write "None" for any section that does not apply.

### What Was Done

- Bullet list of work completed and progress made

### Decisions Made

- Confirmed design decisions, policies, and rules

### Discarded Options and Reasons

- Approaches considered but not adopted, and why

### Blockers and Gotchas

- Points where progress stalled, errors encountered, unexpected behavior

### Learnings

- Insights and discoveries gained in this session

### Next Steps

- Incomplete tasks and what to tackle in the next session
- Include priority where possible

### Related Files

- List of key file paths touched in this session

## Rules

- Be concise
- Use bullet points throughout
- Stick to facts; avoid speculation or vague language
- "Discarded Options and Reasons" is especially important — prevents relitigating the same decisions next session
