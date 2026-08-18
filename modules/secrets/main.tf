resource "github_actions_secret" "this" {
  count = var.type == "actions" && var.is_variable == false ? 1 : 0

  repository  = var.repository
  secret_name = var.name

  key_id          = var.key_id
  value           = var.value
  value_encrypted = var.value_encrypted
}

# NOTE: `github_codespaces_secret` has not been migrated to the `value` /
# `value_encrypted` / `key_id` attributes that the other secret resources now
# use, and its legacy attributes are not deprecated. The module keeps one
# modern interface and translates here.
resource "github_codespaces_secret" "this" {
  count = var.type == "codespaces" ? 1 : 0

  repository  = var.repository
  secret_name = var.name

  plaintext_value = var.value
  encrypted_value = var.value_encrypted
}

resource "github_dependabot_secret" "this" {
  count = var.type == "dependabot" ? 1 : 0

  repository  = var.repository
  secret_name = var.name

  key_id          = var.key_id
  value           = var.value
  value_encrypted = var.value_encrypted
}

resource "github_actions_variable" "this" {
  count = var.type == "actions" && var.is_variable ? 1 : 0

  repository    = var.repository
  variable_name = var.name
  value         = var.value
}
