variable "value" {
  type        = string
  default     = null
  description = "(Optional) Plaintext value of the secret or variable. The provider encrypts secret values before sending them to GitHub. Required when 'is_variable' is `true`."
  sensitive   = true

  validation {
    condition     = (var.value == null) != (var.value_encrypted == null)
    error_message = "Exactly one of 'value' or 'value_encrypted' must be set."
  }

  validation {
    condition     = !var.is_variable || var.value != null
    error_message = "'value' is required when 'is_variable' is true; variables cannot be encrypted."
  }
}

variable "value_encrypted" {
  type        = string
  default     = null
  description = "(Optional) Value already encrypted with the repository public key, in Base64 format. Only valid when 'is_variable' is `false`."
}

variable "key_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the public key used to encrypt 'value_encrypted'. Required whenever 'value_encrypted' is set."

  validation {
    condition     = var.value_encrypted == null || var.type == "codespaces" || var.key_id != null
    error_message = "'key_id' is required whenever 'value_encrypted' is set, except for 'codespaces' secrets, whose resource does not accept it."
  }
}

variable "name" {
  type        = string
  description = "(Required) The name of the secret."
  nullable    = false
}

variable "repository" {
  type        = string
  description = "(Required) The name of the repository to create the secret in."
  nullable    = false

  validation {
    condition     = (var.repository != "")
    error_message = "The repository name cannot be an empty string."
  }
}

variable "is_variable" {
  type        = bool
  default     = false
  description = "(Optional) Whether the secret is a variable. Only applicable for 'actions' type secrets."
  nullable    = false

  validation {
    condition     = !(var.is_variable && var.type != "actions")
    error_message = "The 'is_variable' can only be true when the 'type' is 'actions'."
  }
}

variable "type" {
  type        = string
  default     = "actions"
  description = "(Optional) The type of secret. Allowed values are 'actions', 'codespaces', and 'dependabot'."
  nullable    = false

  validation {
    condition     = var.type == "actions" || var.type == "codespaces" || var.type == "dependabot"
    error_message = "The 'type' variable must be either 'actions', 'codespaces', or 'dependabot'."
  }
}
