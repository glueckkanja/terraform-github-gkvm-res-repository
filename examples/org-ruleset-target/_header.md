# Organization ruleset target example

This example shows the whole pattern for protecting a repository with an **organization-level** ruleset that selects its targets by custom property, rather than by an explicitly maintained list of repository names.

The point of the arrangement is that repository administrators cannot edit an organization ruleset. Where a repository-level ruleset can be disabled by anyone holding `admin` on the repository — and only restored on the next Terraform run — an organization ruleset stays in force.

## What each piece does

1. **The property definition** is created once for the whole organization. It belongs in whatever configuration owns organization settings; it is shown here only to make the example readable. `values_editable_by = "org_actors"` is the security-relevant setting: it stops repository administrators editing their own property value to escape the ruleset.
2. **The repository** is created by this module and stamped with the property.
3. **The organization ruleset** selects every repository carrying that property value.

## Prerequisites

The token needs the organization-level `custom_properties_org_values_editor` permission to set property values. Repository `admin` alone is not sufficient when the definition uses `values_editable_by = "org_actors"`.

## Ordering

The module stamps custom properties *after* the `files` submodule has pushed, so seed commits land while the repository is still unlabelled and the ruleset arms only once content is in place.

That ordering is convenience, not a guarantee. The durable protection for automation is the bypass actor on the ruleset: the onboarding app is listed in `bypass_actors`, so it can still push once the rule is armed, on this and any future run.

Note also that a successful property write does not guarantee the ruleset engine has already re-evaluated its selection. Treat a green apply as "property set", not as "protection active".
