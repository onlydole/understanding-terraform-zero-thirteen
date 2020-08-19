terraform {
  required_providers {
    aws = {
      version = "~> 3.2"
      source  = "hashicorp/aws"
    }
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
