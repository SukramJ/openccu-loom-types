# SPDX-License-Identifier: MIT
# Copyright (C) 2026 OpenCCU-Loom authors.

"""Constants for openccu-loom-types."""

from typing import Final

VERSION: Final = "0.3.12"

# Contract identity of the daemon build these types were generated
# from. Stamped by scripts/stamp_const.py (run via `make generate`);
# do not edit by hand. A client compares SCHEMA_DIGEST against the
# `schema_digest` field of `GET /api/v1/info`: equality means the
# types match the daemon build exactly; inequality means they were
# generated from a different build — fall back to DAEMON_API_VERSION
# vs `api_version` for compatibility reasoning.
SCHEMA_DIGEST: Final = "sha256:897b6b935e3a160412aa46261e1fde6431560df3aee3b7b08f4bcd6293924c3b"
DAEMON_API_VERSION: Final = "5.17.0"
