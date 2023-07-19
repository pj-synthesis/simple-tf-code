provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region

  default_tags {
    tags = {
      Owner    = "Platform Team"
      Tier     = var.env_tier
      Workload = var.workload
    }
  }
}
