#############################################################################
# Filestore                                                                 #
#############################################################################

resource "google_filestore_instance" "basic_hdd" {
  name        = "basic-hdd-${var.zone}"
  description = "Basic Filestore instance in ${var.zone} for ticket ${var.ticket_number}."
  location    = var.zone
  tier        = "BASIC_HDD"

  file_shares {
    capacity_gb = 1024
    name        = "share1"
  }

  networks {
    network      = local.vpc_network_name
    modes        = ["MODE_IPV4"]
    connect_mode = "DIRECT_PEERING"
  }
}