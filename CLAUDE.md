# CLAUDE.md — AI Assistant Guide for openccu-loom-types

## Project Overview

**openccu-loom-types** is a small Python package of **generated**
Pydantic v2 models and `str` enums for the
[openccu-loom](https://github.com/SukramJ/openccu-loom) daemon's
REST + WebSocket contract. It is the sister-repo/types package to the
Go daemon: rather than every Python consumer (`openccu-loom-client`,
a future `homematicip_local` refactor) hand-writing and re-drifting
its own model code, they all import this one package. Nearly
everything under `openccu_loom_types/` is machine-generated from
artifacts in a local `../openccu-loom` checkout — this repo never
re-parses Go source itself, it consumes the daemon's already-exported
schema assets.

- **Language**: Python >= 3.11 (CI runs 3.12)
- **Package name**: `openccu-loom-types` (import as `openccu_loom_types`)
- **Publishing**: PyPI, via automated tag → GitHub Release → `python-publish` workflow
- **License**: MIT
- **Key dependency**: `pydantic>=2.6` (runtime); `datamodel-code-generator`, `pytest`, `ruff` (dev only)
- **Versioning**: `openccu_loom_types.const.VERSION` (dynamic, read by `pyproject.toml`) — independent of the daemon's own version number

## What lives in `openccu_loom_types/`

| Module | Generated from | Generator |
| --- | --- | --- |
| `enums.py` | `$OPENCCU_LOOM_REPO/assets/schemas/enums.json` (mirrors the daemon's `pkg/hmenum`) | `scripts/gen_enums.py` |
| `rest.py` | `$OPENCCU_LOOM_REPO/assets/openapi.yaml` | `datamodel-codegen` (pydantic_v2.BaseModel output) |
| `ws.py` | `$OPENCCU_LOOM_REPO/assets/wsapi.json` + `rest.py` (WS envelope/push schemas re-exported from the OpenAPI `components.schemas`, per the daemon's ADR-0020) | `scripts/gen_ws.py` |
| `const.py` | Stamped, not hand-edited | `scripts/stamp_const.py` |
| `__init__.py` | Hand-written | re-exports `VERSION`, `SCHEMA_DIGEST`, `DAEMON_API_VERSION` |

**Do not hand-edit `enums.py`, `rest.py`, `ws.py`, or the stamped
constants in `const.py`.** CI's `regen-clean` job re-runs `make
generate` against the daemon tag on every `regen/daemon-*` PR and
fails the build on any diff (ignoring only the datamodel-codegen
timestamp header) — hand-edits get caught and rejected.

### Contract-identity constants (`const.py`)

- `SCHEMA_DIGEST` — digest of the daemon contract assets these types
  were generated from; compare against `GET /api/v1/info`'s
  `schema_digest` for exact type/daemon parity.
- `DAEMON_API_VERSION` — the daemon's `api_version` at generation time
  (minor bumps are additive; major bumps are breaking — daemon ADR-0020).

## Repository structure

```
openccu-loom-types/
├── openccu_loom_types/
│   ├── __init__.py       — hand-written re-exports
│   ├── const.py          — VERSION + stamped SCHEMA_DIGEST/DAEMON_API_VERSION
│   ├── enums.py          — generated (gen_enums.py)
│   ├── rest.py           — generated (datamodel-codegen)
│   ├── ws.py             — generated (gen_ws.py)
│   └── py.typed
├── scripts/
│   ├── gen_enums.py
│   ├── gen_ws.py
│   └── stamp_const.py
├── tests/
│   └── test_reserved_words.py   — regression test for the enum-generator's
│                                   Python-keyword escaping (e.g. `None_`)
├── Makefile              — generate / test targets
├── pyproject.toml
├── requirements.txt / requirements-dev.txt
└── .github/workflows/
    ├── ci.yml                          — `Test` + `Regen clean` (required checks)
    ├── regenerate-on-daemon-release.yml — reacts to daemon's `daemon-release` dispatch
    ├── tag-on-regen-merge.yml
    ├── release-on-tag.yml
    └── python-publish.yml
```

## Commands that actually exist

```sh
# Regenerate everything (requires OPENCCU_LOOM_REPO checkout, default ../openccu-loom)
make generate            # = generate-enums + generate-rest + generate-ws + stamp-const
make generate-enums      # openccu_loom_types/enums.py  <- assets/schemas/enums.json
make generate-rest       # openccu_loom_types/rest.py   <- assets/openapi.yaml (datamodel-codegen)
make generate-ws         # openccu_loom_types/ws.py     <- assets/wsapi.json + rest.py
make stamp-const         # stamps const.py with the daemon's schema digest + api_version
make clean               # rm enums.py rest.py ws.py
make test                # pytest -q

# Local dev install
pip install -e '.[dev]'
```

There is no `make lint` target; `ruff` is a dev dependency invoked
directly (e.g. `ruff check .`) and is also used as a `datamodel-codegen`
output formatter (`--formatters ruff-format ruff-check`) during
`generate-rest`.

`OPENCCU_LOOM_REPO` env var (default `../openccu-loom`) must point at
a local daemon checkout for any `generate-*` target — this repo reads
`assets/openapi.yaml`, `assets/wsapi.json`, and
`assets/schemas/enums.json` from it directly; run `make -C
"$OPENCCU_LOOM_REPO" export-schemas` first to ensure those exports are
fresh.

## Sync with upstream `openccu-loom`

This repo is entirely downstream of the daemon repo's contract
assets — it never re-implements or duplicates daemon logic, only
mirrors its already-published schema surface. The full loop is
automated:

1. The daemon's release workflow fires a `repository_dispatch`
   (`daemon-release`) at this repo.
2. `regenerate-on-daemon-release.yml` checks out the daemon at the
   released tag, runs `make generate`, stamps `const.py`, bumps the
   package version, seeds a changelog entry, and opens a
   `regen/daemon-<tag>` PR with auto-merge enabled.
3. `ci.yml` runs `Test` and `Regen clean` (re-running `make generate`
   against that daemon tag and diffing) as required status checks.
4. On merge, `tag-on-regen-merge.yml` pushes `v<version>`, which
   triggers `release-on-tag.yml` → GitHub Release → `python-publish.yml`
   → PyPI.

Manual fallback: trigger `regenerate-on-daemon-release.yml` via
`workflow_dispatch` with a tag, or just run the local two-step flow
(`make -C "$OPENCCU_LOOM_REPO" export-schemas && make generate`).

Required one-time repo settings for the automation to complete (see
README for detail): a `RELEASE_PAT` secret (default `GITHUB_TOKEN`
won't trigger downstream workflows), branch protection on `main`
requiring `Test` + `Regen clean`, and "Allow auto-merge" enabled.

## Conventions

- SPDX header on every `.py` file:
  ```python
  # SPDX-License-Identifier: MIT
  # Copyright (C) 2026 OpenCCU-Loom authors.
  ```
- Enum members that collide with Python keywords get a trailing
  underscore (e.g. `FailureReason.None_`) while keeping the original
  wire string as `.value` — enforced by `tests/test_reserved_words.py`.
  This convention lives in `scripts/gen_enums.py`.
- This package contains **types only** — no HTTP/WebSocket transport
  (that's `openccu-loom-client`) and no business logic.
- Generated files carry no hand-maintained history; treat diffs in
  `enums.py` / `rest.py` / `ws.py` as generator output to review, not
  as code to edit directly.
