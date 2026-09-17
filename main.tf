resource "cloudflare_d1_database" "this" {
  account_id = var.account_id
  name       = var.d1_name
}

resource "cloudflare_workers_script" "this" {
  account_id         = var.account_id
  script_name        = var.name
  content            = file(var.script_path)
  main_module        = basename(var.script_path)
  compatibility_date = var.compatibility_date

  bindings = concat(
    [{
      name = "DB"
      type = "d1"
      id   = cloudflare_d1_database.this.id
    }],
    [for k, v in var.plain_text_vars : {
      name = k
      type = "plain_text"
      text = v
    }],
    var.assets_directory == null ? [] : [{
      name = "ASSETS"
      type = "assets"
    }]
  )

  assets = var.assets_directory == null ? null : {
    directory = var.assets_directory
    config = {
      run_worker_first = var.run_worker_first
    }
  }
}

resource "cloudflare_workers_custom_domain" "this" {
  for_each = toset(var.hostnames)

  account_id  = var.account_id
  zone_id     = var.zone_id
  hostname    = each.value
  service     = cloudflare_workers_script.this.script_name
  environment = "production"
}
