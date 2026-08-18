---
description: 'terraform-github-gkvm-res-repository — a Glückkanja Verified Module (GKVM) for GitHub'
applyTo: '**/*.terraform, **/*.tf, **/*.tfvars, **/*.tfstate, **/*.tflint.hcl, **/*.tf.json, **/*.tfvars.json'
---

# terraform-github-gkvm-res-repository

A **Glückkanja Verified Module (GKVM)** that manages GitHub repositories, and nothing else.

| | |
|---|---|
| Registry address | `glueckkanja/gkvm-res-repository/github` |
| Repository | `glueckkanja/terraform-github-gkvm-res-repository` |
| Provider | `integrations/github` — the only one |
| Submodules | `modules/ruleset`, `modules/file`, `modules/secrets`, `modules/environment` |

This repository was originally generated from the Azure Verified Modules (AVM) template, but it is **not an AVM module** and is not governed by AVM rules or tooling. Treat any leftover AVM convention you encounter as an artefact to remove, not a standard to uphold.

## Hard rules

- **`integrations/github` is the only provider.** The module never authenticates against Azure. Do not add `azapi`, `azurerm`, `modtm` or `random` provider requirements.
- **No telemetry.** The module collects nothing and makes no network calls beyond the GitHub API. Do not add telemetry resources, data sources or variables.
- **No AVM tooling.** `Makefile`, the `avm` / `avm.bat` / `avm.ps1` helpers and the `.github/actions/*` composite actions were removed; they depended on `Azure/avm-terraform-governance`, which is archived and deprecated. Do not run or reinstate `./avm pre-commit`, `./avm pr-check`, `make autofix` or `make pre-commit`. `avmfix` in particular rewrites `terraform.tf` to the AVM provider baseline and would re-add the Azure providers this module deliberately dropped.
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
examples/default/        the published example
_header.md / _footer.md  terraform-docs fragments for the root README
```

## Validating

Run these before opening a pull request. They need no Docker, no Azure and no credentials, and they mirror `.github/workflows/ci.yml` exactly:

```bash
terraform fmt -check -recursive -diff

for d in . modules/ruleset modules/file modules/secrets modules/environment examples/default; do
  terraform -chdir="$d" init -backend=false -input=false
  terraform -chdir="$d" validate
done

tflint --init
tflint --recursive --minimum-failure-severity=error

terraform-docs -c .terraform-docs.yml .
for m in modules/*/; do terraform-docs -c .terraform-docs.yml "$m"; done
```

Commit any regenerated documentation — CI fails on README drift.

`examples/default/README.md` embeds its own HCL source and is maintained by hand. Do not regenerate it with the root `.terraform-docs.yml`, which would strip that block.

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
