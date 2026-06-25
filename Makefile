.PHONY: help generate generate-enums generate-rest generate-ws stamp-const clean test

OPENCCU_LOOM_REPO ?= ../openccu-loom
PKG := openccu_loom_types

help: ## show this help
	@awk -F':.*?## ' '/^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

generate: generate-enums generate-rest generate-ws stamp-const ## regenerate every Pydantic / Enum module from the daemon's schema assets

stamp-const: ## stamp const.py with the daemon's schema digest + api_version
	python3 scripts/stamp_const.py \
		--openccu-loom-repo $(OPENCCU_LOOM_REPO) \
		--const-py $(PKG)/const.py

generate-enums: ## regenerate openccu_loom_types/enums.py from $(OPENCCU_LOOM_REPO)/assets/schemas/enums.json
	python3 scripts/gen_enums.py \
		--enums-json $(OPENCCU_LOOM_REPO)/assets/schemas/enums.json \
		--out-py $(PKG)/enums.py

# --disable-timestamp is REQUIRED for deterministic output: without it
# datamodel-codegen stamps the current wall-clock time into the rest.py header,
# so every regeneration diffs against the last release even when the daemon API
# is byte-for-byte identical. That spurious diff defeats the
# "skip release when API unchanged" guard in regenerate-on-daemon-release.yml
# and forces a new types release for every daemon release.
generate-rest: ## regenerate openccu_loom_types/rest.py via datamodel-codegen
	@command -v datamodel-codegen >/dev/null 2>&1 || { \
		echo "datamodel-codegen not on PATH — install via 'pip install -e .[dev]'"; exit 1; }
	datamodel-codegen \
		--input $(OPENCCU_LOOM_REPO)/assets/openapi.yaml \
		--input-file-type openapi \
		--output $(PKG)/rest.py \
		--output-model-type pydantic_v2.BaseModel \
		--target-python-version 3.11 \
		--use-standard-collections \
		--use-double-quotes \
		--field-constraints \
		--disable-timestamp \
		--formatters ruff-format ruff-check

generate-ws: ## regenerate openccu_loom_types/ws.py (envelope + push-payload re-exports from rest.py)
	python3 scripts/gen_ws.py \
		--wsapi-json $(OPENCCU_LOOM_REPO)/assets/wsapi.json \
		--rest-py $(PKG)/rest.py \
		--out-py $(PKG)/ws.py

clean: ## remove generated modules
	rm -f $(PKG)/enums.py $(PKG)/rest.py $(PKG)/ws.py

test: ## run pytest
	pytest -q
