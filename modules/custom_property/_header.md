# GitHub Repository Custom Property Module

This module sets a single [custom property](https://docs.github.com/en/organizations/managing-organization-settings/managing-custom-properties-for-repositories-in-your-organization) value on a GitHub repository.

Custom properties let an organization-level ruleset select its target repositories by metadata rather than by an explicitly maintained list of repository names. Because organization rulesets cannot be edited by repository administrators, this is a way to apply branch protection that the repository's own admins cannot switch off.

## Prerequisites

**The property must already be defined at the organization level.** This module sets a *value*; it does not create the definition. Defining a property is an organization-wide operation, so it belongs in the configuration that owns organization settings, not in a per-repository module.

Setting a value also requires permission. When the definition uses `values_editable_by = "org_actors"` — the default, and the setting that makes the property tamper-resistant — the token running this module needs the organization-level `custom_properties_org_values_editor` permission. A token holding only repository `admin` will fail.

## Usage

### Example - A simple flag

```terraform
module "custom_property" {
  source = "glueckkanja/gkvm-res-repository/github//modules/custom_property"

  name       = "azere-managed"
  repository = "example-repository"
  type       = "true_false"
  value      = ["true"]
}
```

### Example - Multiple values

Only `multi_select` accepts more than one value. Every other type takes exactly one.

```terraform
module "custom_property" {
  source = "glueckkanja/gkvm-res-repository/github//modules/custom_property"

  name       = "regions"
  repository = "example-repository"
  type       = "multi_select"
  value      = ["westeurope", "northeurope"]
}
```

## Notes

- `name` and `type` are replacement-forcing. Changing either destroys and recreates the property value, during which the repository stops matching any organization ruleset that selects on it. Choose both before the first apply.
- Removing this module does not merely forget the value, it clears it: the provider writes a null value on destroy, and the repository falls back to the organization default, if the definition has one.
- The module is authoritative only for the property it manages. Any other property on the repository is left untouched.
