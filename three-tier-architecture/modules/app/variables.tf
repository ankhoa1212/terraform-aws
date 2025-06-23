variable "private_subnet_ids" {
  description = "List of private subnet IDs for the app tier"
  type        = list(string)
}
variable "app_alb_sg_id" {
  description = "Security group ID for the app ALB"
  type        = string
}
variable "app_instance_sg_id" {
  description = "Security group ID for the app instances"
  type        = string
}
variable "app_ami" {
  description = "AMI ID for the app instances"
  type        = string
}
variable "app_instance_type" {
  description = "Instance type for the app instances"
  type        = string
}
variable "key_name" {
  description = "Key name for the app instances"
  type        = string
  default     = "web-server"
}