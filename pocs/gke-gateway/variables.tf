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
# Network                                                                   #
#############################################################################
variable "vpc_routing_mode" {
  type        = string
  description = "VPC routing mode"
  default     = "GLOBAL"

  validation {
    condition     = contains(["GLOBAL", "REGIONAL"], var.vpc_routing_mode)
    error_message = "Invalid input, options: \"GLOBAL\", \"REGIONAL\"."
  }
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
  default     = "test-vpc"

  validation {
    condition     = can(regex("[a-z]([-a-z0-9]*[a-z0-9])?", var.vpc_name))
    error_message = "Invalid input, name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])?."
  }
}

variable "vpc_auto_create_subnetworks" {
  type        = bool
  description = <<-EOT
  When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. 
  When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources.
  EOT
  default     = false
}

variable "vpc_delete_default_igw_routes" {
  type        = bool
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted."
  default     = false
}

variable "vpc_subnets" {
  type        = list(map(string))
  description = "The list of subnets being created."
}

variable "vpc_subnets_secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets."
  default     = {}
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
