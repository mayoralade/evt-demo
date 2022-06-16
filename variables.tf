variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes Cluster Version"
  default     = "1.22"
}

variable "db_volume_size" {
  type        = string
  description = "Database Volume Size"
}

variable "environment" {
  type        = string
  description = "Infrastructure Environment"
}

variable "db_host" {
  type        = string
  description = "Database Host Address"
}

variable "db_name" {
  type        = string
  description = "Database Name"
}

variable "db_port" {
  type        = number
  description = "Database Port"
}

variable "db_user" {
  type        = string
  description = "Database UserName"
}

variable "project" {
  type        = string
  description = "Project Name"
  default     = "EVTDemo"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}
