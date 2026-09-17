output "worker_name" {
  description = "Deployed Worker script name."
  value       = cloudflare_workers_script.this.script_name
}

output "d1_database_id" {
  description = "D1 database UUID bound to the Worker as `DB`."
  value       = cloudflare_d1_database.this.id
}

output "hostnames" {
  description = "Custom domains attached to the Worker."
  value       = [for d in cloudflare_workers_custom_domain.this : d.hostname]
}
