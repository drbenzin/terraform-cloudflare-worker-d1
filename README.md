# terraform-cloudflare-worker-d1

Terraform module for the smallest useful Cloudflare stack: a **Worker** (ES module) with **Workers Static Assets**, a **D1** database bound as `DB`, plain-text vars, and **custom domains** on your zone. It replaces the `wrangler.jsonc` + `wrangler deploy` routine with a reviewable plan.

Used in production for five landing sites that write click events into a shared D1 table.

## Usage

```hcl
module "landing" {
  source = "github.com/drbenzin/terraform-cloudflare-worker-d1"

  account_id         = var.account_id
  zone_id            = var.zone_id
  name               = "my-landing"
  d1_name            = "my-events"
  script_path        = "${path.module}/worker.js"
  compatibility_date = "2026-09-10"
  hostnames          = ["example.com", "www.example.com"]
  assets_directory   = "${path.module}/public"
  run_worker_first   = true        # needed when the Worker must redirect on asset paths
  plain_text_vars    = { SITE = "example" }
}
```

Secrets (API keys) are deliberately not module inputs: set them with `wrangler secret put NAME` or `cloudflare_workers_secret`, so they never land in state.

A full example is in [`examples/landing`](examples/landing): Worker that stores page events in D1 and serves a static page.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `account_id` | string | — | Cloudflare account ID |
| `zone_id` | string | — | Zone owning every hostname |
| `name` | string | — | Worker name (lower-case, dashes) |
| `script_path` | string | — | Path to the Worker entry module |
| `compatibility_date` | string | — | Runtime compatibility date |
| `d1_name` | string | — | D1 database name |
| `hostnames` | list(string) | `[]` | Custom domains routed to the Worker |
| `plain_text_vars` | map(string) | `{}` | Non-secret vars exposed to the Worker |
| `assets_directory` | string | `null` | Static assets directory; null disables assets |
| `run_worker_first` | bool | `false` | Run the Worker before serving a matching asset |

## Outputs

`worker_name`, `d1_database_id`, `hostnames`.

## Requirements

Terraform ≥ 1.6, provider `cloudflare/cloudflare ~> 5.0`, an API token with Workers Scripts, D1 and Zone DNS edit rights (`CLOUDFLARE_API_TOKEN`).

## CI

`terraform fmt -check`, `terraform validate` (module and example) and `tflint --recursive` run on every push.
