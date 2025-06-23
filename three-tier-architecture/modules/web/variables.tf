variable "public_subnet_ids" {
  description = "List of public subnet IDs for the web tier"
  type        = list(string)
}
variable "web_alb_sg_id" {
  description = "Security group ID for the web ALB"
  type        = string
}
variable "web_instance_sg_id" {
  description = "Security group ID for the web instance"
  type        = string
}
variable "web_ami" {
  description = "AMI ID for the web instances"
  type        = string
}
variable "web_instance_type" {
  description = "Instance type for the web instances"
  type        = string
}
variable "key_name" {
  description = "Key name for the web instances"
  type        = string
  default     = "web-server"
}