# Tests

## `unit/`

`tofu test` suites with a mock `github` provider: no token, no network, plan only. They pin the module's contract:

- input validations reject what they should (`expect_failures`)
- configuration is passed through to the resources
- the `for_each` keys that act as state addresses (`<type>-<name>` for secrets, path for files, `<branch|tag>-<pattern>` for deployment policies) do not change by accident

Run them with `./gkvm test-unit`; they are part of `./gkvm pr-check` and of the `unit tests` CI job.

Assertions only target configured values. Computed attributes (ids, URLs, timestamps) are unknown under `plan` with a mock provider.

## `integration/`

Not present yet. Would run `tofu test` against a sandbox organisation with real credentials (`GKVM_GITHUB_TOKEN`, `GKVM_GITHUB_OWNER` on the `test` environment).
