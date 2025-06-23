variable "db_subnet_ids" {
  description = "List of database subnet IDs"
  type        = list(string)
}
variable "db_sg_id" {
  description = "Security group ID for the database"
  type        = string
}
variable "db_name" {
  description = "Name of the database"
  type        = string
}
variable "db_user" {
  description = "Username for the database"
  type        = string
}
variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}