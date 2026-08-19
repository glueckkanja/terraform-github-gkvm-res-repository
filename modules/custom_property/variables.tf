variable "name" {
  type        = string
  description = "(Required) The name of the custom property. The property must already be defined at the organization level."
  nullable    = false

  validation {
    condition     = length(var.name) > 0
    error_message = "The custom property name must not be empty."
  }
}

variable "repository" {
  type        = string
  description = "(Required) The name of the repository to set the custom property on."
  nullable    = false

  validation {
    condition     = var.repository != ""
    error_message = "The repository name cannot be an empty string."
  }
}

variable "type" {
  type        = string
  default     = "string"
  description = <<DESCRIPTION
(Optional) The type of the custom property. One of `string`, `single_select`, `multi_select`, `true_false` or `url`. Defaults to `string`.

This must match the `value_type` of the organization-level property definition. It is a replacement-forcing attribute, so changing it destroys and recreates the property value on the repository.
DESCRIPTION
  nullable    = false

  validation {
    condition     = contains(["string", "single_select", "multi_select", "true_false", "url"], var.type)
    error_message = "The 'type' must be one of 'string', 'single_select', 'multi_select', 'true_false' or 'url'."
  }
}

variable "value" {
  type        = list(string)
  description = <<DESCRIPTION
(Required) The value of the custom property, always given as a list.

`multi_select` accepts one or more entries. Every other type accepts exactly one. For `true_false`, the single entry must be the string `"true"` or `"false"`.
DESCRIPTION
  nullable    = false

  validation {
    condition     = var.type == "multi_select" ? length(var.value) >= 1 : length(var.value) == 1
    error_message = "A 'multi_select' property needs at least one value; every other property type needs exactly one."
  }

  validation {
    condition     = var.type != "true_false" || alltrue([for v in var.value : contains(["true", "false"], v)])
    error_message = "A 'true_false' property value must be the string \"true\" or \"false\"."
  }

  validation {
    condition     = alltrue([for v in var.value : v != ""])
    error_message = "A custom property value must not be an empty string."
  }
}
