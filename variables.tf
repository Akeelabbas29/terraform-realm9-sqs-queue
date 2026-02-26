variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "realm9"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "fifo_queue" {
  description = "Whether to create a FIFO queue"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO queues"
  type        = bool
  default     = false
}

variable "delay_seconds" {
  description = "Delay in seconds before messages become visible"
  type        = number
  default     = 0
}

variable "max_message_size" {
  description = "Max message size in bytes (1024-262144)"
  type        = number
  default     = 262144
}

variable "message_retention_seconds" {
  description = "How long messages are kept (60-1209600 seconds)"
  type        = number
  default     = 345600
}

variable "receive_wait_time_seconds" {
  description = "Long polling wait time (0-20 seconds)"
  type        = number
  default     = 0
}

variable "visibility_timeout_seconds" {
  description = "Visibility timeout in seconds (0-43200)"
  type        = number
  default     = 30
}

variable "kms_key_id" {
  description = "KMS key ID for encryption. If empty, uses SQS-managed SSE"
  type        = string
  sensitive   = true
  default     = ""
}

variable "create_dlq" {
  description = "Create a dead letter queue"
  type        = bool
  default     = false
}

variable "max_receive_count" {
  description = "Max receives before sending to DLQ"
  type        = number
  default     = 3
}

variable "dlq_message_retention_seconds" {
  description = "Message retention for the DLQ (seconds)"
  type        = number
  default     = 1209600
}

variable "tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}

variable "enable_monitoring" {
  description = "Enable CloudWatch monitoring for the SQS queue"
  type        = bool
  default     = false
}