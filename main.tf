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
  queue_name = "${var.project_name}-${var.environment}-${random_string.suffix.result}"
}

# SQS Queue
resource "aws_sqs_queue" "this" {
  name                       = var.fifo_queue ? "${local.queue_name}.fifo" : local.queue_name
  fifo_queue                 = var.fifo_queue
  content_based_deduplication = var.fifo_queue ? var.content_based_deduplication : null

  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds

  sqs_managed_sse_enabled = var.kms_key_id == "" ? true : null
  kms_master_key_id       = var.kms_key_id != "" ? var.kms_key_id : null

  tags = merge(
    {
      Name        = local.queue_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

# Dead Letter Queue (optional)
resource "aws_sqs_queue" "dlq" {
  count = var.create_dlq ? 1 : 0

  name                      = var.fifo_queue ? "${local.queue_name}-dlq.fifo" : "${local.queue_name}-dlq"
  fifo_queue                = var.fifo_queue
  message_retention_seconds = var.dlq_message_retention_seconds

  sqs_managed_sse_enabled = var.kms_key_id == "" ? true : null
  kms_master_key_id       = var.kms_key_id != "" ? var.kms_key_id : null

  tags = merge(
    {
      Name        = "${local.queue_name}-dlq"
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

# Redrive policy (connect main queue to DLQ)
resource "aws_sqs_queue_redrive_policy" "this" {
  count = var.create_dlq ? 1 : 0

  queue_url = aws_sqs_queue.this.id

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  })
}
