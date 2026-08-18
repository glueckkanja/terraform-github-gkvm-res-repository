## Description

<!--
> Thank you for your contribution!
> Please summarise the change, the context behind it, and which issue it fixes.
> List any dependencies this change requires.

Fixes #123
Closes #456
-->

## Type of Change

<!-- Use the check-boxes [x] on the options that are relevant. -->

- [ ] Non-module change (CI, documentation, tooling)
- [ ] Bugfix, backwards compatible
- [ ] Feature, backwards compatible
- [ ] Breaking change
- [ ] Documentation update

## State impact

<!--
> This module is consumed across many Terraform states, so resource addresses are a
> public interface. State the impact explicitly, even when it is "none".
-->

- [ ] No state impact — no resource address changes, no forced replacements
- [ ] State impact, described below

<!--
> If there is impact, describe what Terraform will plan on the first run after
> upgrading, and what a consumer has to do about it. Changing a `for_each` key
> expression rekeys every affected resource in every state and cannot be repaired
> with `moved` blocks — call that out prominently.
-->

## Checklist

- [ ] There are no other open pull requests for the same change
- [ ] `terraform fmt -check -recursive` passes
- [ ] `terraform validate` passes for the root module, every submodule and the example
- [ ] `tflint --recursive --minimum-failure-severity=error` passes
- [ ] Documentation regenerated with `terraform-docs` and committed
- [ ] CI is green
