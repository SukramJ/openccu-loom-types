# CLAUDE.md

## This repository is retired

`openccu-loom-types` no longer publishes any Python modules. The generated
Pydantic models and enum catalogue moved into
[`openccu-loom-client`](https://github.com/SukramJ/openccu-loom-client) as
`openccu_loom_client/wire/` (that repository's issue #122).

What remains here is a metadata-only distribution whose sole purpose is to let
an environment that still holds `openccu-loom-types` upgrade onto the package
that actually carries the bindings. Home Assistant never uninstalls an
abandoned requirement, which is why the alias exists at all.

**Do not add modules here.** A wheel from this repository that ships anything
outside `.dist-info` would put a second copy of the wire bindings into
environments that already have them; `.github/workflows/ci.yml` fails the build
if one appears.

Work on the wire contract belongs in one of two places:

- the **daemon** (`SukramJ/openccu-loom`) owns the contract assets —
  `assets/openapi.yaml`, `assets/wsapi.json`, `assets/schemas/enums.json`;
- the **client** (`SukramJ/openccu-loom-client`) owns the generators
  (`script/gen/`), the generated output (`openccu_loom_client/wire/`), the
  regeneration workflow and the reproducibility guard.
