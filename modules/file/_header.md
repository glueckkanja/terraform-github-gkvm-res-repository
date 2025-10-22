# Github Repository Files Module

This module is used to manage files within a GitHub repository.

## Features

This module supports managing files in a GitHub repository, including creating, updating, and deleting files.

The module supports:

- Creating a new file
- Updating an existing file
- Deleting a file

## Usage

To use this module in your Terraform configuration, you'll need to provide values for the required variables.

### Example - Basic File Creation

This example shows the most basic usage of the module. It creates a new file in the repository.

```terraform
module "file_creation" {
  source = "glueckkanja/terraform-azurerm-avm-res-network-virtualnetwork//modules/file"

  repository = "Example Repository"
  file_path  = "path/to/file.txt"
  content    = "Hello, World!"
}
```
