#############################################################################
# Terraform variables                                                       #
#############################################################################
#############################################################################
# Google Cloud variables                                                    #
#############################################################################
variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP compute region ID"
}

variable "zone" {
  type        = string
  description = "GCP compute zone ID"
}

#############################################################################
# Ticket metadata                                                           #
#############################################################################
variable "ticket_number" {
  type        = string
  description = "Zendesk ticket number"
}

#############################################################################
# IAP proxy                                                                 #
#############################################################################
variable "iap_proxy_subnet_cidr_range" {
  type        = string
  description = "The range of internal addresses that are owned by IAP proxysubnetwork."
  default     = null
}

#############################################################################
# GKE cluster                                                               #
#############################################################################
variable "gke_cluster_name" {
  type        = string
  description = "GKE cluster name."
  default     = "test-cluster"
}

variable "gke_cluster_regional" {
  type        = bool
  description = "Flag to enable a GKE regional cluster."
  default     = false
}

variable "gke_cluster_version" {
  type        = string
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  default     = "latest"
}

variable "gke_cluster_enable_private_endpoint" {
  type        = bool
  description = "Whether the master's internal IP address is used as the cluster endpoint."
  default     = false
}

variable "gke_cluster_enable_private_nodes" {
  type        = bool
  description = "Whether nodes have internal IP addresses only."
  default     = false
}

variable "gke_cluster_enable_intranode_visibility" {
  type        = bool
  description = "Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network."
  default     = false
}

variable "gke_cluster_remove_default_node_pool" {
  type        = bool
  description = "Remove default node pool while setting up the cluster."
  default     = false
}

variable "gke_cluster_master_ipv4_cidr_block" {
  type        = string
  description = "The IP range in CIDR notation to use for the hosted master network."
  validation {
    condition     = can(cidrhost(var.gke_cluster_master_ipv4_cidr_block, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "gke_cluster_master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
  default     = []
}

variable "gke_cluster_node_pools" {
  type        = list(map(any))
  description = "List of maps containing node pools."
}
