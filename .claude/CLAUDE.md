# Global Claude Code Instructions

## Commit Message Convention

Always use **commitizen with cz-emoji** format for all git commits. The format is:

```
:emoji_code: scope: description
```

Max subject length: 72 characters. Pick the emoji code that best matches the change.

### Commit Type Reference

| Code | Scope | Description |
|------|-------|-------------|
| `:art:` | `fmt:` | Improve structure / format of the code |
| `:zap:` | `impr:` | Improve performance |
| `:fire:` | `rem:` | Remove code or files |
| `:bug:` | `fix:` | Fix a bug |
| `:ambulance:` | `hfix:` | Critical hotfix |
| `:sparkles:` | `feat:` | Introduce new features |
| `:pencil:` | `docs:` | Add or update documentation |
| `:rocket:` | `depl:` | Deploy stuff |
| `:lipstick:` | `ui:` | Add or update the UI and style files |
| `:tada:` | `init:` | Begin a project |
| `:white_check_mark:` | `test:` | Add, update, or pass tests |
| `:lock:` | `secu:` | Fix security or privacy issues |
| `:bookmark:` | `tags:` | Release / Version tags |
| `:rotating_light:` | `lint:` | Fix compiler / linter warnings |
| `:construction:` | `wip:` | Work in progress |
| `:arrow_down:` | `dwg:` | Downgrade dependencies |
| `:arrow_up:` | `upg:` | Upgrade dependencies |
| `:pushpin:` | `pin:` | Pin dependencies to specific versions |
| `:construction_worker:` | `ci:` | Add or update CI build system |
| `:chart_with_upwards_trend:` | `nltx:` | Add or update analytics or tracking code |
| `:recycle:` | `refa:` | Refactor code |
| `:whale:` | `dock:` | Work about Docker |
| `:heavy_plus_sign:` | `dpad:` | Add a dependency |
| `:heavy_minus_sign:` | `dprm:` | Remove a dependency |
| `:wrench:` | `conf:` | Add or update configuration files |
| `:globe_with_meridians:` | `i18n:` | Internationalization and localization |
| `:pencil2:` | `typo:` | Fix typos |
| `:rewind:` | `rvt:` | Revert changes |
| `:twisted_rightwards_arrows:` | `mrg:` | Merge branches |
| `:package:` | `dpup:` | Add or update compiled files or packages |
| `:alien:` | `api:` | Update code due to external API changes |
| `:truck:` | `mv:` | Move or rename resources |
| `:bento:` | `asst:` | Add or update assets |
| `:ok_hand:` | `rev:` | Update code due to code review changes |
| `:bulb:` | `cmt:` | Add or update comments in source code |
| `:speech_balloon:` | `text:` | Add or update text and literals |
| `:card_file_box:` | `db:` | Perform database related changes |
| `:loud_sound:` | `lgad:` | Add or update logs |
| `:mute:` | `lgrm:` | Remove logs |
| `:children_crossing:` | `ux:` | Improve user experience / usability |
| `:iphone:` | `resp:` | Work on responsive design |
| `:clown_face:` | `mock:` | Mock things |
| `:see_no_evil:` | `ign:` | Add or update a .gitignore file |
| `:camera_flash:` | `snap:` | Add or update snapshots |
| `:microscope:` | `expt:` | Perform experiments |
| `:mag:` | `seo:` | Improve SEO |
| `:label:` | `type:` | Add or update types |
| `:seedling:` | `seed:` | Add or update seed files |
| `:goal_net:` | `err:` | Handle or catch errors |
| `:dizzy:` | `anm:` | Add or update animations and transitions |
| `:passport_control:` | `auth:` | Work on authorization, roles and permissions |
| `:adhesive_bandage:` | `ish:` | Simple fix for a non-critical issue |
| `:coffin:` | `dead:` | Remove dead code |
| `:test_tube:` | `fail:` | Add a failing test |
| `:necktie:` | `lgc:` | Add or update business logic |
| `:stethoscope:` | `hlth:` | Add or update healthcheck |
| `:bricks:` | `infr:` | Infrastructure related changes |
| `:technologist:` | `tech:` | Improve developer experience |

## Test Code Requirements

### NEVER violate these rules

#### Test Quality
- Every test MUST verify actual behavior — never write meaningless assertions like `expect(true).toBe(true)`
- Each test case MUST validate specific inputs and their expected outputs
- Keep mocks to the absolute minimum; tests should reflect real behavior as closely as possible

#### No Hardcoding to Make Tests Pass
- NEVER hardcode values in production code just to make a test pass
- NEVER add `if (testMode)` or similar test-only branches in production code
- NEVER embed magic numbers or special test values in production code
- Use environment variables or config files to properly separate test and production environments

#### Test Implementation Principles
- Always start from a failing state (Red → Green → Refactor)
- Always test boundary values, abnormal inputs, and error cases
- Prioritize real quality over coverage metrics
- Test case names MUST clearly describe what is being tested

#### Before Writing Tests
- Fully understand the feature specification before writing any test
- If anything is unclear, ask the user rather than making assumptions or writing placeholder implementations

## Session Handover

- At the start of each session, check the `.claude/handovers/` directory in the project root and read the latest file if one exists
- At the end of a session or at a natural stopping point, prompt the user to run `/handover`
