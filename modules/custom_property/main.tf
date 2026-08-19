resource "github_repository_custom_property" "this" {
  repository     = var.repository
  property_name  = var.name
  property_type  = var.type
  property_value = var.value
}
