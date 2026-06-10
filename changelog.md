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
