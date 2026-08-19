# terraform-github-gkvm-res-repository

This is a Terraform resource module to manage a GitHub repository.

It covers the repository itself along with its rulesets, files, Actions/Codespaces/Dependabot secrets and variables, deployment environments, and organization custom property values.

## Custom properties and organization rulesets

Setting custom property values lets an **organization-level** ruleset target this repository by metadata rather than by an explicitly maintained list of repository names.

That matters where the repository's own administrators must not be able to switch off their branch protection: a repository-level ruleset can be disabled by anyone holding `admin` and is only restored on the next Terraform run, whereas an organization ruleset cannot be edited from the repository at all.

This module stamps the property. It does not create the organization-level property *definition*, and it does not create the organization ruleset — both are organization-wide concerns that belong in the configuration owning organization settings. See the `org-ruleset-target` example for the full pattern.
