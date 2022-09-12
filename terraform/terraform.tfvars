variable "gcp_region" {
  type        = string
  description = "Region of Liveability project execution"
  default     = "Sydney"
}

variable "gcp_zone" {
  type        = string
  description = "Project zone"
  default     = "australia-southeast1-a"
}

variable "gcp_project" {
  type        = string
  description = "Project to use for this config"
  default     = "liveability-beta"
}

