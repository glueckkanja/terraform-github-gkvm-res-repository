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
