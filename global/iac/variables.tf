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
