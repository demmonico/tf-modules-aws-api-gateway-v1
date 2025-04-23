terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

locals {
  tags = merge(
    {
      "Module-Name"   = "api-gateway-v1",
      "Module-Source" = "https://git.westwing.eu/devops/terraform-modules/api-gateway-v1"
    },
    var.tags,
  )
}
