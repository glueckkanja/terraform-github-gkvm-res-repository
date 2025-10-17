resource "github_actions_secret" "this" {
  count = var.type == "actions" && var.is_variable == false ? 1 : 0

  repository      = var.repository
  secret_name     = var.name
  encrypted_value = var.encrypted_value
  plaintext_value = var.plaintext_value
}

resource "github_codespaces_secret" "this" {
  count = var.type == "codespaces" ? 1 : 0

  repository      = var.repository
  secret_name     = var.name
  encrypted_value = var.encrypted_value
  plaintext_value = var.plaintext_value
}

resource "github_dependabot_secret" "this" {
  count = var.type == "dependabot" ? 1 : 0

  repository      = var.repository
  secret_name     = var.name
  encrypted_value = var.encrypted_value
  plaintext_value = var.plaintext_value
}

resource "github_actions_variable" "this" {
  count = var.type == "actions" && var.is_variable ? 1 : 0

  repository    = var.repository
  variable_name = var.name
  value         = var.plaintext_value
}
