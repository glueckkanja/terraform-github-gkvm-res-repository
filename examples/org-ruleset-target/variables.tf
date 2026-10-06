variable "automation_app_id" {
  type        = number
  default     = null
  description = <<DESCRIPTION
Optional. The id of the GitHub App that manages these repositories, which is
then allowed to bypass the organization ruleset so it can still push once the
rule is armed. Use the App id, not the installation id.

Left unset no bypass actor is configured, which is how the end-to-end test runs
this example: it must work in any organization. A real configuration should set
it, because the bypass actor is the durable protection for automation, as
described in the example's README.
DESCRIPTION
}

variable "gkvm_suffix" {
  type        = string
  default     = "local"
  description = <<DESCRIPTION
Suffix appended to every name this example creates, so that two runs never fight
over the same organization-wide object. The end-to-end runner sets it per run
through TF_VAR_gkvm_suffix.

It is an input rather than a `random_string` resource on purpose: the property
name derived from it becomes a `for_each` key inside the module, and those must
be known at plan time, which a resource attribute is not.
DESCRIPTION
}

variable "manage_property_definition" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
Whether this configuration creates the organization property definition, or
expects one the organization already owns.

The definition is an organization-wide singleton, so in a real estate it is
declared once, by whatever configuration owns organization settings, and every
other configuration sets this to `false` and names it through `property_name`.
The default is `true` only so that this example reads as a whole.

The end-to-end test runs it as `false` for a second reason, described in the
README: GitHub answers a delete of a property definition with a `500`, so an
example that created one could not destroy itself.
DESCRIPTION
}

variable "property_name" {
  type        = string
  default     = null
  description = <<DESCRIPTION
Name of the organization custom property that the ruleset selects on, and that
the repository is stamped with.

Left unset the name is derived from `gkvm_suffix`, which suits a definition this
configuration creates itself. Set it to name a definition the organization
already owns; that is required when `manage_property_definition` is `false`.
DESCRIPTION
}
