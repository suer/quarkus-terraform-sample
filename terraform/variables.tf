variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "function_name" {
  description = "Lambda function name"
  type        = string
  default     = "quarkus-hello-world"
}
