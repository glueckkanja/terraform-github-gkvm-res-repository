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

That ordering is convenience, not a guarantee. The durable protection for automation is the bypass actor on the ruleset: the identity that manages the repository is listed in `bypass_actors`, so it can still push once the rule is armed, on this and any future run. Set `automation_app_id` to the id of the GitHub App that owns these repositories, not to its installation id.

## The property definition

The definition is an organization-wide singleton. In a real estate it is created
once, by whatever configuration owns organization settings, and every
configuration that merely *targets* it sets `manage_property_definition = false`
and names it through `property_name`. The default is `true` only so that this
example reads as a whole.

This repository's end-to-end run uses the `false` path, against a definition
created by hand in the sandbox organization. That is not only realism: GitHub
answers `DELETE /orgs/{org}/properties/schema/{name}` with a `500`, reproducibly
and after about nine seconds, with the deletion itself still going through. The
reference the ruleset and the repository value hold is already gone by then, and
a thirty-second delay in between changes nothing. An example that created a
definition could therefore not destroy itself.

## Names

The repository, the organization ruleset and the property definition all carry the `gkvm_suffix` input. Two of those three are organization-wide names, so a fixed name would make two concurrent runs of this example fight over the same object, and this example is applied and destroyed for real on every pull request.

The suffix is an input rather than a `random_string` resource because the property name derived from it becomes a `for_each` key inside the module. Those keys must be known at plan time, which a resource attribute is not: a random value there fails the apply with `Invalid for_each argument`.

Note also that a successful property write does not guarantee the ruleset engine has already re-evaluated its selection. Treat a green apply as "property set", not as "protection active".
