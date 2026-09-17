variable "account_id" {
  description = "Cloudflare account ID."
  type        = string
}

variable "zone_id" {
  description = "Zone that owns every hostname in `hostnames`."
  type        = string
}

variable "name" {
  description = "Worker script name; also used as the D1 binding owner."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,62}$", var.name))
    error_message = "Worker names are lower-case letters, digits and dashes, max 63 characters."
  }
}

variable "script_path" {
  description = "Path to the Worker entry module (ES module)."
  type        = string
}

variable "compatibility_date" {
  description = "Workers runtime compatibility date, YYYY-MM-DD."
  type        = string

  validation {
    condition     = can(regex("^\\d{4}-\\d{2}-\\d{2}$", var.compatibility_date))
    error_message = "compatibility_date must look like 2026-09-10."
  }
}

variable "d1_name" {
  description = "D1 database name. One database per module instance."
  type        = string
}

variable "hostnames" {
  description = "Custom domains routed to the Worker, e.g. [\"example.com\", \"www.example.com\"]."
  type        = list(string)
  default     = []
}

variable "plain_text_vars" {
  description = "Non-secret environment variables exposed to the Worker as plain_text bindings."
  type        = map(string)
  default     = {}
}

variable "assets_directory" {
  description = "Directory of static assets served by the Worker (Workers Static Assets). Null disables assets."
  type        = string
  default     = null
}

variable "run_worker_first" {
  description = "Run the Worker before serving a matching static asset (needed for redirects on asset paths)."
  type        = bool
  default     = false
}
