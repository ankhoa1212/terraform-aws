variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
}
variable "bastion_sg" {
  description = "Security group ID for the bastion host"
  type        = string
}
variable "key_name" {
  description = "Key name for the bastion host"
  type        = string
}
variable "public_subnets" {
  description = "List of public subnet IDs for the bastion host"
  type        = list(string)
}
variable "bastion_ami" {
  description = "AMI ID for the bastion host"
  type        = string
}