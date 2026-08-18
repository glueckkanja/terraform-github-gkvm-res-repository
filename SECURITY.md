# Security

## Reporting a vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

Report them through GitHub's private vulnerability reporting instead:

1. Go to the [Security tab](../../security) of this repository.
2. Choose **Report a vulnerability**.

This opens a private advisory visible only to the maintainers. If private reporting is unavailable to you, contact the maintainers listed in [`.github/CODEOWNERS`](.github/CODEOWNERS) directly.

Please include as much of the following as you can:

- The type of issue
- The affected file paths, and the tag, branch or commit
- Any configuration required to reproduce the issue
- Step-by-step reproduction instructions
- Proof-of-concept code, if you have it
- What an attacker could achieve by exploiting it

## Scope

This module manages GitHub repositories through the `integrations/github` provider. It stores no credentials of its own — authentication is supplied by the caller's provider configuration.

Two things are worth knowing when assessing a report:

- The `secrets` input carries `plaintext_value`, which is marked `sensitive` and is therefore redacted from Terraform plan and apply output. It is still written to Terraform state in plaintext, as with any Terraform secret, so state must be treated as sensitive and stored in an encrypted backend.
- The `secrets` submodule deliberately exports metadata only and never the underlying resource objects, so secret values are not surfaced through module outputs.

## Preferred languages

English or German.
