terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  topic_name = "${var.project_name}-${var.environment}-${random_string.suffix.result}"
}

# SNS Topic
resource "aws_sns_topic" "this" {
  name = local.topic_name

  tags = merge(
    {
      Name        = local.topic_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}
