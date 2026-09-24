# Unit tests for the repository resource itself. Mock provider, no token,
# plan only: assertions target configured values, never computed ones.
mock_provider "github" {}

variables {
  name = "unit-repo"
}

run "defaults" {
  command = plan

  assert {
    condition     = github_repository.this.name == "unit-repo"
    error_message = "the repository name must follow var.name"
  }

  assert {
    condition     = github_repository.this.has_issues && github_repository.this.has_wiki && github_repository.this.has_projects
    error_message = "issues, wiki and projects default to enabled"
  }

  assert {
    condition     = !github_repository.this.allow_auto_merge && !github_repository.this.archive_on_destroy && !github_repository.this.vulnerability_alerts
    error_message = "auto merge, archive on destroy and vulnerability alerts default to disabled"
  }

  assert {
    condition     = length(github_branch_default.this) == 0
    error_message = "no default branch resource unless var.default_branch is set"
  }

  assert {
    condition     = length(output.rulesets) == 0 && length(output.files) == 0 && length(output.environments) == 0 && length(output.secrets) == 0 && length(output.custom_properties) == 0
    error_message = "no submodule instances without configuration"
  }
}

run "default_branch_is_managed_when_set" {
  command = plan

  variables {
    default_branch = {
      branch = "main"
      rename = true
    }
  }

  assert {
    condition     = length(github_branch_default.this) == 1 && github_branch_default.this[0].branch == "main" && github_branch_default.this[0].rename
    error_message = "default_branch must create exactly one github_branch_default with the configured branch"
  }

  assert {
    condition     = output.default_branch == "main"
    error_message = "output.default_branch must expose the managed branch"
  }
}

run "pages_and_template_blocks" {
  command = plan

  variables {
    pages = {
      cname = "docs.example.com"
      source = {
        branch = "gh-pages"
        path   = "/docs"
      }
    }
    template = {
      owner      = "glueckkanja"
      repository = "template-repo"
    }
  }

  assert {
    condition     = length(github_repository.this.pages) == 1 && github_repository.this.pages[0].cname == "docs.example.com"
    error_message = "pages block must be rendered from var.pages"
  }

  assert {
    condition     = github_repository.this.pages[0].source[0].branch == "gh-pages" && github_repository.this.pages[0].source[0].path == "/docs"
    error_message = "pages source must follow var.pages.source"
  }

  assert {
    condition     = length(github_repository.this.template) == 1 && github_repository.this.template[0].repository == "template-repo" && !github_repository.this.template[0].include_all_branches
    error_message = "template block must be rendered from var.template"
  }
}

run "rejects_unknown_visibility" {
  command = plan

  variables {
    visibility = "secret"
  }

  expect_failures = [var.visibility]
}

run "merge_commit_message_requires_merge_commits" {
  command = plan

  variables {
    allow_merge_commit   = false
    merge_commit_message = "PR_BODY"
  }

  expect_failures = [var.merge_commit_message]
}

run "squash_title_requires_squash_merge" {
  command = plan

  variables {
    allow_squash_merge        = false
    squash_merge_commit_title = "PR_TITLE"
  }

  expect_failures = [var.squash_merge_commit_title]
}
