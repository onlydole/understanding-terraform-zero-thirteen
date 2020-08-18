terraform {
  required_providers {
    aws = "~> 3.2"
  }

  required_version = "~> 0.13"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "onlydole"

    workspaces {
      name = "understanding-terraform-zero-thirteen"
    }
  }
}
