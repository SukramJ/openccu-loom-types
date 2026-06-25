# Version 0.1.38 (2026-06-25)

- Feat: regenerate from openccu-loom v0.14.3 for daemon api 2.0.0. `DAEMON_API_VERSION` → 2.0.0 and `SCHEMA_DIGEST` refreshed; see the generated module diff for added/changed types.

# Version 0.1.37 (2026-06-25)

- Feat: regenerate from openccu-loom v0.14.2 for daemon api 2.0.0. `DAEMON_API_VERSION` → 2.0.0 and `SCHEMA_DIGEST` refreshed; see the generated module diff for added/changed types.

# Version 0.1.36 (2026-06-25)

- Feat: regenerate from openccu-loom v0.14.1 for daemon api 2.0.0. `DAEMON_API_VERSION` → 2.0.0 and `SCHEMA_DIGEST` refreshed; see the generated module diff for added/changed types.

# Version 0.1.35 (2026-06-25)

- Feat: regenerate from openccu-loom v0.14.0 for daemon api 2.0.0. `DAEMON_API_VERSION` → 2.0.0 and `SCHEMA_DIGEST` refreshed; see the generated module diff for added/changed types.

# Version 0.1.34 (2026-06-25)

- Feat: regenerate from openccu-loom v0.13.3 for daemon api 2.0.0. `DAEMON_API_VERSION` → 2.0.0 and `SCHEMA_DIGEST` refreshed; see the generated module diff for added/changed types.

# Version 0.1.33 (2026-06-24)

- Feat: regenerate from openccu-loom v0.12.0 for daemon api 1.24.0. `DAEMON_API_VERSION` → 1.24.0 and `SCHEMA_DIGEST` refreshed; see the generated module diff for added/changed types.

# Version 0.1.32 (2026-06-24)

- Feat: regenerate from openccu-loom v0.11.3 for daemon api 1.21.0. `DAEMON_API_VERSION` → 1.21.0 and `SCHEMA_DIGEST` refreshed; see the generated module diff for added/changed types.

# Version 0.1.31 (2026-06-23)

- Feat: regenerate from openccu-loom v0.11.2 for daemon api 1.21.0. `DAEMON_API_VERSION` → 1.21.0 and `SCHEMA_DIGEST` refreshed; see the generated module diff for added/changed types.

# Version 0.1.30 (2026-06-23)

- Feat: regenerate from openccu-loom v0.11.1 for daemon api 1.21.0. `DAEMON_API_VERSION` → 1.21.0 and `SCHEMA_DIGEST` refreshed; see the generated module diff for added/changed types.

# Version 0.1.29 (2026-06-22)

- Feat: regenerate from openccu-loom v0.11.0 for daemon api 1.21.0. `DAEMON_API_VERSION` → 1.21.0 and `SCHEMA_DIGEST` refreshed; see the generated module diff for added/changed types.

# Version 0.1.28 (2026-06-22)

- CI: automate the regeneration release end to end. A new `ci.yml` runs the test suite on every PR (the `Test` status check) plus a `Regen clean` check that, for `regen/daemon-*` branches, re-runs `make generate` against the daemon tag encoded in the branch name and fails on any drift — catching hand-edits to the generated modules or the stamped `const.py` block. `regenerate-on-daemon-release.yml` now opens its PR under a PAT (so CI actually triggers) and enables auto-merge; once the checks are green the PR squash-merges, and the new `tag-on-regen-merge.yml` reads the bumped `VERSION` and pushes the `v<version>` tag, which drives the existing `release-on-tag.yml` → GitHub Release → PyPI publish. No package code changes — `DAEMON_API_VERSION` / `SCHEMA_DIGEST` are unchanged from 0.1.27. Requires a `RELEASE_PAT` secret and branch protection requiring the `Test` / `Regen clean` checks.

# Version 0.1.27 (2026-06-22)

- Feat: regenerate from openccu-loom v0.10.0 for daemon api 1.20.0. `DAEMON_API_VERSION` → 1.20.0 and `SCHEMA_DIGEST` refreshed; see the generated module diff for added/changed types.

# Version 0.1.26 (2026-06-22)

- Feat: regenerate for daemon api 1.19.0 — openccu-loom v0.9.1, which closes the post-`asks.md` north-bound wire gaps D1–D4 found during the `py-openccu-loom-client` integration. (The v0.9.0 auto-regeneration never landed: its `openapi.yaml` was missing the D1/D2/D3 schemas the daemon already emitted, so `gen_ws` could not resolve the broadcast payload; v0.9.1 completes the published contract and this release picks it up.) New WS payload `HubSystemUpdateChangedPayload` (`central`, `current_firmware`, `available_firmware`, `update_available`, `in_progress`) for the `hub.{central}.system_update` broadcast, re-exported from `ws.py` (**D1**). New optional `DataPointSummary.value_translations` (raw `value_list` entry → localised label, ENUM only) (**D2**). New optional `ChannelSummary.functions` (channel-level "Gewerk" labels, the twin of `DeviceSummary.functions`) (**D3**). New optional `SchemaField.default` (the config field's effective default) (**D4**). Pure additions; `DAEMON_API_VERSION` → 1.19.0 and `SCHEMA_DIGEST` refreshed.

# Version 0.1.25 (2026-06-21)

- Feat: regenerate for daemon api 1.18.0 — openccu-loom v0.8.0's hub-datapoint and device-trigger contract. New WS event payloads `HubCountChangedPayload` (alarm/service/inbox counts), `HubMetricChangedPayload` (`system_health`, `connection_latency_ms`, `last_event_age_seconds` with optional unit) and `HubConnectivityChangedPayload` (per-interface reachability + probe `latency_ms`), all re-exported from `ws.py`. New REST device-trigger summaries `EventGroupSummary` (channel-level trigger group: `kind`, `event_types`, `parameters`, `available`) carrying a nested `TriggeredEventSummary` (`parameter`, `value`, `triggered_at`) for the last fire. New REST hub-datapoint bundle `HubDataPoints` (`alarm_messages`, `service_messages`, `inbox`, `update`, plus optional `metrics`/`connectivity`/`install_mode` lists) over `HubCountDataPoint`, `HubUpdateDataPoint`, `HubMetricDataPoint`, `HubConnectivityDataPoint` and `HubInstallModeDataPoint`. Pure additions; `DAEMON_API_VERSION` → 1.18.0 and `SCHEMA_DIGEST` refreshed.

# Version 0.1.24 (2026-06-21)

- Feat: regenerate for daemon api 1.17.0 — openccu-loom v0.7.1's REST
  config-reload endpoints (`POST /devices/{addr}/reload`, `POST
  /devices/{addr}/channels/{no}/reload`). The endpoints take only path params
  and return a simple result, so no new named types are added; `DAEMON_API_VERSION`
  → 1.17.0 and `SCHEMA_DIGEST` refreshed.

# Version 0.1.23 (2026-06-20)

- Feat: regenerate for daemon api 1.16.0 — openccu-loom v0.7.0's device-action services. New REST request/response types for the schedule-copy (`POST .../schedules/copy`, `.../week_profile/copy`) and system-variable fetch (`POST /sysvars/fetch`) endpoints; the new device actions (climate away-mode, on-time, cover combined, siren, text-display) and the `central.*` / `recording.*` / `reload_channel_config` commands ride the existing `cdp.invoke` / WS surface. Pure addition; `DAEMON_API_VERSION` → 1.16.0 and `SCHEMA_DIGEST` refreshed.

# Version 0.1.22 (2026-06-19)

- Feat: regenerate for daemon api 1.13.0 — new `HistoryBucket` REST type (`ts`, `avg`, `min`, `max`, `count`): a downsampled time-series aggregate, each bucket carrying the mean/min/max of its raw samples plus the sample `count` over the bucket's UTC time span. Pure addition; `DAEMON_API_VERSION` → 1.13.0 and `SCHEMA_DIGEST` refreshed.

# Version 0.1.21 (2026-06-16)

- Feat: regenerate for daemon api 1.10.0. No type/schema changes — `rest.py`, `ws.py`, `enums.py` are byte-identical apart from the regeneration timestamp. Only the contract identity moves: `DAEMON_API_VERSION` → 1.10.0 and `SCHEMA_DIGEST` refreshed so clients keep an exact build-parity check against `GET /api/v1/info`.

# Version 0.1.20 (2026-06-14)

- Feat: regenerate for daemon api 1.9.0. `SysvarSummary` / `ProgramSummary` gain `enabled_default: bool | None` — the daemon's resolved marker-driven enabled-by-default flag, so clients no longer re-derive it from markers (which the daemon strips from the description). Also catches up the api 1.8.0 additions skipped since 0.1.19: `CentralBehavior` (per-central behaviour toggles) plus the `SysvarMarker` / `ProgramMarker` enums and the reworked central config schema. `DAEMON_API_VERSION` → 1.9.0; schema digest refreshed.

# Version 0.1.19 (2026-06-13)

- Feat: regenerate for daemon api 1.7.0 — `WeekProfileResponse` gains `available_target_channels` (a map of channel-lock key → `TargetChannelSummary` with `channel_no`, `channel_address`, `name`, `channel_type`). Lets external clients name a per-channel schedule switch after the actuator channel it controls. Pure addition.

# Version 0.1.18 (2026-06-12)

- Feat: regenerate for daemon api 1.6.0 — `ChannelSummary` gains the channel-group contract: `group_no`, `is_group_master`, `is_in_multi_group`, `sub_device_name` plus the group-master-resolved `room`. Drives the HA sub-device split in external clients. Pure additions.

# Version 0.1.17 (2026-06-12)

- Feat: regenerate for daemon api 1.5.0 — `CalculatedDPSummary.translated_name` (REST calc-dps + WS calc_dp.*; locale-aware label, same chain as generic DPs). Pure addition.

# Version 0.1.16 (2026-06-12)

- Feat: regenerate REST types for daemon api 1.4.0 — new hub-singleton/schedule contract: `SystemUpdateEntry` (GET /system/update), `HubMetricsEntry` (GET /system/metrics), `InstallModeInterfaceEntry`/`InstallModeInterfaceRequest` (GET+POST /install-mode/interfaces), `ChannelLockRequest` (PUT …/week_profile/channel-locks/{key}). Pure additions.

# Version 0.1.15 (2026-06-11)

- Feat: regenerate REST types — `SysvarSummary` gains `vid` (CCU-internal numeric variable ID / ise_id; clients apply the reference stack's fixed-ID exclusions 40/41 = alarm/service messages). `SCHEMA_DIGEST`/`DAEMON_API_VERSION` are stamped for the first time (api_version 1.3.0). Pure additions.

# Version 0.1.14 (2026-06-11)

- Feat: regenerate REST types — `SysvarSummary` gains `is_internal` (CCU bookkeeping variables; clients skip them) and `is_extended` (description marker; clients expose the writable entity flavour). Pure additions.

# Version 0.1.13 (2026-06-11)

- Feat: **contract identity constants** — `const.py` gains `SCHEMA_DIGEST` and `DAEMON_API_VERSION` (exported at package level), stamped by the new `scripts/stamp_const.py` via `make generate`. The digest mirrors the daemon's contract-digest definition (daemon ADR 0028); clients compare it against `GET /api/v1/info`.`schema_digest` for an exact type/daemon build-parity check. Stamps ship empty until the first regeneration against a daemon release that serves the field.
- Feat: **automated regeneration** — the `regenerate-on-daemon-release` workflow (repository_dispatch from the daemon's release pipeline, manual `workflow_dispatch` fallback) regenerates all modules from the released tag, stamps the constants, bumps the patch version and opens a PR.

# Version 0.1.12 (2026-06-11)

- Feat: regenerate REST types — `DataPointSummary` gains `usage` (the daemon pipeline's visibility verdict: `data_point`, `no_create`, `ignored`, `ce_primary`, `ce_secondary`, `ce_visible`, `event`; clients skip entity creation for `no_create`/`ignored`, the same gate the MQTT discovery plane applies). Pure addition.

# Version 0.1.11 (2026-06-11)

- Feat: regenerate REST types — `ProgramSummary` gains `central`, `last_executed`, `is_internal` (CCU-internal helper programs; clients skip them for HA entities) and `SysvarSummary` gains `central`, `min`, `max`. The daemon already sent all of these; the spec omission made pydantic drop them, so clients could neither filter foreign-central hub entries nor exclude internal programs. Pure additions.

# Version 0.1.10 (2026-06-10)

- Feat: regenerate REST types from updated `openapi.yaml` — `CustomDPSummary` gains `config` (static configuration block: `min_temp`/`max_temp`/`temp_step`, available `hvac_modes`, `preset_modes`; previously sent by the daemon but silently dropped by the generated model) and `state` (live state snapshot with the same semantic keys as the WS `custom_data_point.state_changed` event, for bootstrap seeding). Pure additions — no existing field changed.

# Version 0.1.9 (2026-06-10)

- Feat: regenerate REST types from updated `openapi.yaml` — `MatterExposure` gains `parameter_label` (ready-to-display caption for the data point behind `dp_key`: the locale-aware channel-typed translation when one exists, otherwise the title-cased key; same resolution as `DataPointSummary.parameter_label`), and `DataPointSummary.parameter_label` gains its schema description (ready-to-display row caption, always non-empty, carries text even when `label_omitted` is true). Pure additions — no existing field changed.

# Version 0.1.8 (2026-06-10)

- Feat: regenerate REST types from updated `openapi.yaml` — `DataPointSummary` gains `translated_name` (the daemon's locale-aware per-entity name, identical to the MQTT discovery `name`; the parameter portion only, HA prepends the device name; empty when omitted) and `label_omitted` (true when the parameter is the "primary" one, so consumers collapse the entity name to the device name alone). Pure additions — no existing field changed.

# Version 0.1.7 (2026-06-09)

- Fix: `Info.capabilities` is now a forward-compatible `list[str]` instead of `list[Capability]` (closed enum). A daemon advertising capabilities the bindings don't yet know — e.g. `system.restart.supervised.v1`, `mcp.v1`, `mcp.write.v1` — no longer fails `Info` validation in older clients. The `Capability` enum (only ever referenced by this field) was dropped. The source `openapi.yaml` was changed in lock-step: `Info.capabilities.items` is now an open `type: string` (known values kept as `examples`), so regeneration reproduces the open type. Capabilities are a feature-gating set and must stay forward-compatible by design.

# Version 0.1.6 (2026-06-07)

- Feat: regenerate REST types from updated `openapi.yaml` — `ChannelSummary` gains `name` (user-defined channel name, empty when none is set) and `category` (OCCU channel-type string, mirroring `type` under its own key so consumers can route on channel purpose without parsing `type`). Pure additions — no existing field changed.

# Version 0.1.5 (2026-06-07)

- Feat: regenerate REST types from updated `openapi.yaml` — `ChannelSummary` gains `type`, `type_label` and `paramset_keys` (for the HA drop-in config panel) and `DeviceSummary` gains `ise_id` (for rename-by-ise_id). Pure additions — no existing field changed.
- Chore: the package version is now read from `openccu_loom_types.const.VERSION` (single source of truth); `pyproject.toml` declares `version` as dynamic via `[tool.setuptools.dynamic]` and `__version__` re-exports `const.VERSION`.

# Version 0.1.4 (2026-06-01)

- Feat: regenerate REST/WS types from updated `openapi.yaml` — adds two new push payloads `OptimisticRollbackPayload` (central, device_address, channel, parameter, paramset_key, reason, optional sent/present) and `DeviceTriggerPayload` (central, interface_id, device_address, channel, event_type, parameter, optional value). The corresponding `components.schemas` entries were missing from the daemon's `openapi.yaml` even though `wsapi.json` already catalogued the `datapoint.optimistic_rolled_back` and `device.trigger` broadcasts; both payloads are now generated into `rest.py` and re-exported from `openccu_loom_types.ws`. Pure additions — no existing model changed.

# Version 0.1.3 (2026-05-31)

- Feat: regenerate REST types from `openapi.yaml`, which now carries proper `components.schemas` for the schedule, link and calculated-data-point surfaces (previously inline/empty, so no models were generated). Adds: `Schedule`, `ScheduleChannelRef`, `ClimateProfile`, `ClimateWeekday`, `ClimatePeriod`, `SimpleScheduleEntry`, `SetActiveProfileRequest`, `WeekProfileResponse` (schedules); `Link`, `AddLinkRequest`, `CentralLinksStatus` (links); `CalculatedDPSummary`, `CalculatedDPDetail` (calculated data points). Pure additions — no existing model changed.

# Version 0.1.2 (2026-05-24)

- Feat: regenerate REST/WS types from updated `openapi.yaml` — adds two new push payloads `DeviceCreatedPayload` (central, interface_id, device_address, model, optional source) and `DeviceRemovedPayload` (central, interface_id, device_address). Both are also re-exported from `openccu_loom_types.ws`.

# Version 0.1.1 (2026-05-24)

- Fix: `scripts/gen_enums.py` now escapes Python reserved words. Before this fix `pkg/hmenum` constants whose stripped member name resolved to a reserved word (`None`, `True`, `False`, `class`, …) were emitted verbatim — e.g. `class FailureReason(str, Enum): None = "none"` — which is a `SyntaxError` and made `openccu_loom_types.enums` unimportable. Affected members in 0.1.0: `FailureReason.None`, `Quantity.None`, `RPCServerType.None`, `ValueBehavior.None`. They are now exposed as `*.None_` (PEP 8 trailing-underscore convention); wire values are unchanged.
- Add: regression test `tests/test_reserved_words.py` covering the four affected members and a guard against future keyword regressions.
- Feat: generate-ws — populate ws.py as re-export from rest.py

# Version 0.1.0 (2026-05-24)

- Initial release: generated Pydantic / enum types for the openccu-loom REST + WebSocket contract.

# Version 0.0.0 (2026-05-24)

- Repository bootstrap (no published artifacts).
