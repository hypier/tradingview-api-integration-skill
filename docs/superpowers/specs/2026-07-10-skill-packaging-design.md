# TradingView Skill Packaging Design

## Goal

Keep the existing GitHub installation commands working while ensuring the installed skill contains its required `scripts/` and `references/` resources.

## Selected Structure

Keep repository-facing files at the root and move the complete skill into a named child directory:

```text
tradingview-api-integration/
├── README.md
├── LICENSE
├── .gitignore
└── skills/
    └── tradingview-api-integration/
        ├── SKILL.md
        ├── scripts/
        │   └── tv_api.py
        └── references/
            ├── endpoint-catalog.md
            ├── openapi.json
            └── examples/
```

The skill name and installation commands remain unchanged. The nested directory matches the `skills` CLI's multi-skill repository layout, so its GitHub download path treats all files below the skill directory as one installable unit.

## Documentation Changes

Update root `README.md` links and source-checkout command examples to point into `skills/tradingview-api-integration/`. Keep paths inside `SKILL.md` relative to the installed skill root; those paths remain unchanged.

## Validation

1. Validate the nested `SKILL.md` frontmatter and folder name.
2. Install from the local repository into a temporary Git project with `npx skills add ... --copy`.
3. Assert the installed directory contains `SKILL.md`, `scripts/tv_api.py`, `references/endpoint-catalog.md`, and `references/openapi.json`.
4. Run `tv_api.py --help` and verify the missing-key error path without making a network request.
5. After the change is pushed, repeat the documented GitHub install command in a clean temporary project to cover the remote download path.

## Non-Goals

- No TradingView API behavior changes.
- No reference-content rewrites.
- No change to the skill name or public install command.
