# Inputs for this repository's end-to-end run, loaded automatically by
# `tofu apply` in this directory. A consumer copying the example should delete
# this file: the defaults in variables.tf are the ones that read correctly.
#
# The run does not create the property definition, for two reasons. It is an
# organization-wide singleton, so pointing at an existing one is the realistic
# case anyway. And GitHub answers `DELETE /orgs/{org}/properties/schema/{name}`
# with a `500` -- reproducibly, after about nine seconds, with the deletion
# itself still going through -- so an example that created a definition could
# not destroy itself, whatever the ordering.
#
# The definition below is a permanent fixture of the sandbox organization,
# created once by hand. Its name deliberately avoids the `gkvm_e2e_` prefix,
# which the nightly sweep deletes.
manage_property_definition = false
property_name              = "gkvm_fixture_orgruleset"
