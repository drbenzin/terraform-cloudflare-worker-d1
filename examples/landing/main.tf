terraform {
  required_version = ">= 1.6"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

provider "cloudflare" {}

variable "account_id" {
  type = string
}

variable "zone_id" {
  type = string
}

module "landing" {
  source = "../.."

  account_id         = var.account_id
  zone_id            = var.zone_id
  name               = "example-landing"
  d1_name            = "example-events"
  script_path        = "${path.module}/worker.js"
  compatibility_date = "2026-09-10"
  hostnames          = ["example.com", "www.example.com"]
  assets_directory   = "${path.module}/public"
  run_worker_first   = true
  plain_text_vars = {
    SITE  = "example"
    PRICE = "$29/mo"
  }
}

output "d1_database_id" {
  value = module.landing.d1_database_id
}
