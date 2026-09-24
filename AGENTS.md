---
description: 'terraform-github-gkvm-res-repository — a glueckkanja Verified Module (GKVM) for GitHub'
applyTo: '**/*.terraform, **/*.tf, **/*.tfvars, **/*.tfstate, **/*.tflint.hcl, **/*.tf.json, **/*.tfvars.json'
---

# terraform-github-gkvm-res-repository

A **glueckkanja Verified Module (GKVM)** that manages GitHub repositories, and nothing else.

| | |
|---|---|
| Registry address | `glueckkanja/gkvm-res-repository/github` |
| Repository | `glueckkanja/terraform-github-gkvm-res-repository` |
| Provider | `integrations/github` — the only one |
| Submodules | `modules/ruleset`, `modules/file`, `modules/secrets`, `modules/environment`, `modules/custom_property` |

This repository was originally generated from the Azure Verified Modules (AVM) template, but it is **not an AVM module** and is not governed by AVM rules or tooling. Treat any leftover AVM convention you encounter as an artefact to remove, not a standard to uphold.

## Hard rules

- **`integrations/github` is the only provider.** The module never authenticates against Azure. Do not add `azapi`, `azurerm`, `modtm` or `random` provider requirements.
- **No telemetry.** The module collects nothing and makes no network calls beyond the GitHub API. Do not add telemetry resources, data sources or variables.
- **Tooling is gkvm-tools, not AVM.** Checks and fixes run through [glueckkanja/gkvm-tools](https://github.com/glueckkanja/gkvm-tools) (`./gkvm pre-commit`, `./gkvm pr-check`); the Azure-only AVM pipeline (`Makefile`, `avm`, `make autofix`, the `azterraform` image) is gone and must not come back. gkvm-tools detects the `github` profile from `terraform.tf` and never adds Azure providers or telemetry.
- **`for_each` keys are state addresses.** This module is consumed across many states. Changing a `for_each` key expression forces a destroy and recreate of every affected resource in every state, and `moved` blocks cannot repair keys computed from a variable — leaving consumers to run `terraform state mv` by hand. Treat key expressions as immutable unless you are deliberately shipping a migration, and say so explicitly in the pull request.

## Repository layout

```
main.tf                  github_repository, github_branch_default, submodule calls
variables.tf             root inputs
outputs.tf               root outputs
terraform.tf             required_version + required_providers
modules/ruleset/         github_repository_ruleset
modules/file/            github_repository_file
modules/secrets/         Actions / Codespaces / Dependabot secrets and Actions variables
modules/environment/     Deployment environments, protection rules, env secrets and variables
modules/custom_property/ Organization custom property values, for org-ruleset targeting
examples/default/        the published example
_header.md / _footer.md  terraform-docs fragments for the root README
tests/unit/              tofu test suites with a mock provider, see tests/README.md
```

## Validating

Run the same checks CI runs before opening a pull request. Both need Docker (the pinned `ghcr.io/glueckkanja/gkvm-tools` image) and no credentials:

```bash
./gkvm pre-commit   # tofu fmt, avmfix block ordering, terrafmt, terraform-docs — writes files
./gkvm pr-check     # fmt, fix, docs drift, validate, tflint, unit tests, zizmor — read-only
```

Commit whatever `pre-commit` changes: CI fails on README or formatting drift.

A change to an input validation or to a `for_each` key expression needs a matching unit test in `tests/unit/`; the state-address keys are asserted there on purpose.

Example READMEs embed their own HCL source via `{{ include }}`, so they are generated too -- with `examples/.terraform-docs.yml`, never with the root config, which would strip the embedded block. gkvm-tools resolves the config per scope automatically.

## Conventions

- **Commits:** Conventional Commits; `!` marks a breaking change.
- **Identifiers:** `snake_case` throughout.
- **Documentation:** every variable and output carries a `description`. Submodule usage examples live in that submodule's `_header.md`, not in its generated `README.md`.
- **Versioning:** semver. A breaking change means a major bump.
- **Module sources:** registry addresses are `<NAMESPACE>/<NAME>/<PROVIDER>`, so a submodule is `glueckkanja/gkvm-res-repository/github//modules/<name>`. The trailing `github` is the *provider* segment, derived from the `terraform-<PROVIDER>-<NAME>` repository naming pattern — it is not a path component.

## Secrets handling

`modules/secrets` manages values that must never leak into output:

- `plaintext_value` is marked `sensitive`, and is still written to Terraform state in plaintext, as with any Terraform secret.
- The submodule deliberately exports **metadata only** — never the resource objects, which carry `plaintext_value`. Keep it that way when adding outputs.

## Further reading

- [`CONTRIBUTING.md`](CONTRIBUTING.md) — contribution workflow and the pull request checklist
- [`SECURITY.md`](SECURITY.md) — vulnerability reporting
