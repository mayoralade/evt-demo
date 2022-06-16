variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones where subnets will be created"
}

variable "create_internet_gateway" {
  type        = bool
  description = "(Optional) A boolean flag to create Internet Gateway. Defaults false."
  default     = false
}

variable "create_nat_gateway" {
  type        = bool
  description = "(Optional) A boolean flag to create NAT Gateway. Defaults false."
  default     = false
}

variable "environment" {
  type        = string
  description = "AWS Environment Tag"
}

variable "external_cidr" {
  type        = list(string)
  description = "External CIDRs allowed to Access VPC"
  default     = []
}

variable "nat_gateway_count" {
  type        = string
  description = "(Optional) Number of nat gateway resources to create.  Default: 1"
  default     = "1"
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Private Subnet Tags"
  default     = null
}

variable "project" {
  type        = string
  description = "AWS Project Tag"
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Public Subnet Tags"
  default     = null
}

variable "vpc_cidr" {
  type        = string
  description = "AWS VPC CIDR block"
}

variable "vpc_enable_dns_support" {
  type        = bool
  description = "(Optional) A boolean flag to enable/disable DNS support in the VPC. Defaults true."
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  type        = bool
  description = "(Optional) A boolean flag to enable/disable DNS hostnames in the VPC. Defaults true."
  default     = true
}

variable "vpc_log_group_name" {
  type        = string
  description = "The name of CloudWatch Logs group to which VPC Flow Logs are delivered."
  default     = null
}

variable "vpc_log_retention_in_days" {
  type        = number
  description = "Number of days to retain logs for. CIS recommends 365 days.  Possible values are: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. Set to 0 to keep logs indefinitely."
  default     = 365
}
