# SPDX-License-Identifier: MIT
# Copyright (C) 2026 OpenCCU-Loom authors.

"""Constants for openccu-loom-types."""

from typing import Final

VERSION: Final = "0.2.6"

# Contract identity of the daemon build these types were generated
# from. Stamped by scripts/stamp_const.py (run via `make generate`);
# do not edit by hand. A client compares SCHEMA_DIGEST against the
# `schema_digest` field of `GET /api/v1/info`: equality means the
# types match the daemon build exactly; inequality means they were
# generated from a different build — fall back to DAEMON_API_VERSION
# vs `api_version` for compatibility reasoning.
SCHEMA_DIGEST: Final = "sha256:2df49f4e3b74be40671aae4c38a2f5173ac402c91fd56ff3c99f0d47864f62ad"
DAEMON_API_VERSION: Final = "3.13.0"
