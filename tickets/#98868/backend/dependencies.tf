#############################################################################
# Stack dependencies                                                        #
#############################################################################

data "terraform_remote_state" "baseline" {
  backend = "gcs"
  config = {
    bucket = "04a17e60ca0de333-tf-state-bucket"
    prefix = "tickets/#98868/baseline"
  }
}