variable "cloudflare_account_id" {
  description = "The Cloudflare Account ID we're applying against"
  type        = string
}

variable "cloudflare_zero_trust_team_name" {
  description = "The team name associated with CloudFlare Zero Trust"
  type        = string
  default     = "dontxinkeship"
}

variable "cloudflare_zero_trust_allow_email_domains" {
  description = "The allowed email domains to enroll for Zero Trust"
  type        = list(string)
}

variable "okd_network_cidr" {
  description = "The network CIDR used for the OKD Cluster/network. Needed for CloudFlare Zero Trust"
  type        = string
  default     = "192.168.2.0/24"
}

variable "okd_entra_app_name" {
  description = "Application/Display Name in Entra for OKD Cluster"
  type        = string
  default     = "OKD Lab 01"
}

variable "okd_cluster_name" {
  description = "The name of the cluster that was given during install"
  type        = string
}

variable "okd_cluster_base_domain" {
  description = "The base domain/DNS zone the cluster is given"
  type        = string
  default     = "okd.home.arpa"
}
