#############################################################################
# GKE                                                                       #
#############################################################################

data "google_compute_zones" "available" {
  region = var.region
  status = "UP"
}

locals {
  vpc_network_id                 = data.terraform_remote_state.baseline.outputs.vpc_network_id
  vpc_network_name               = data.terraform_remote_state.baseline.outputs.vpc_network_name
  gke_cluster_zones              = var.gke_cluster_regional ? data.google_compute_zones.available.names : [var.zone]
  gke_cluster_region             = var.gke_cluster_regional ? var.region : null
  gke_master_authorized_networks = var.gke_cluster_enable_private_endpoint ? [{ display_name = "allow-iap", cidr_block = var.iap_proxy_subnet_cidr_range }] : var.gke_cluster_master_authorized_networks
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version = "~> 23.3"

  project_id         = var.project_id
  name               = var.gke_cluster_name
  regional           = var.gke_cluster_regional
  region             = local.gke_cluster_region
  zones              = local.gke_cluster_zones
  description        = "GKE ${var.gke_cluster_regional ? "regional" : "zonal"} cluster ${var.gke_cluster_name} for ticket ${var.ticket_number}."
  network            = local.vpc_network_name
  subnetwork         = "subnet-gke-europe-west6"
  ip_range_pods      = "subnet-gke-europe-west6-pods"
  ip_range_services  = "subnet-gke-europe-west6-services"
  kubernetes_version = var.gke_cluster_version

  enable_private_endpoint     = var.gke_cluster_enable_private_endpoint
  enable_private_nodes        = var.gke_cluster_enable_private_nodes
  enable_intranode_visibility = var.gke_cluster_enable_intranode_visibility
  master_ipv4_cidr_block      = var.gke_cluster_master_ipv4_cidr_block
  master_authorized_networks  = local.gke_master_authorized_networks
  # deploy_using_private_endpoint = true


  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  gke_backup_agent_config    = true
  gce_pd_csi_driver          = true

  network_policy       = false
  filestore_csi_driver = false
  istio                = false
  cloudrun             = false
  dns_cache            = false

  node_pools               = var.gke_cluster_node_pools
  remove_default_node_pool = var.gke_cluster_remove_default_node_pool

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}
  }

  node_pools_metadata = {
    all = {}
  }

  node_pools_taints = {
    all = []
  }

  node_pools_tags = {
    all = []
  }
}