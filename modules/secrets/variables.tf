variable "repository" {
  type        = string
  description = "(Required) The name of the repository to create the secret in."
  nullable    = false

  validation {
    condition     = (var.repository != "")
    error_message = "The repository name cannot be an empty string."
  }
}

variable "name" {
  type        = string
  description = "(Required) The name of the secret."
  nullable    = false
}

variable "encrypted_value" {
  type        = string
  description = "(Optional) Encrypted value of the secret using the GitHub public key in Base64 format. Only valid if 'is_variable' is `false`."
  nullable    = true
}

variable "plaintext_value" {
  type        = string
  description = "(Optional) Plain text value of the secret."
  nullable    = true
  sensitive   = true
}

variable "type" {
  type        = string
  description = "(Optional) The type of secret. Allowed values are 'actions', 'codespaces', and 'dependabot'."
  default     = "actions"
  nullable    = false
  validation {
    condition     = var.type == "actions" || var.type == "codespaces" || var.type == "dependabot"
    error_message = "The 'type' variable must be either 'actions', 'codespaces', or 'dependabot'."
  }
}

variable "is_variable" {
  type        = bool
  description = "(Optional) Whether the secret is a variable. Only applicable for 'actions' type secrets."
  default     = false
  nullable    = false

  validation {
    condition     = !(var.is_variable && var.type != "actions")
    error_message = "The 'is_variable' can only be true when the 'type' is 'actions'."
  }
}
