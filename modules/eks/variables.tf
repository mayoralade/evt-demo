variable "ami_id" {
  type        = string
  description = "AMI ID to use to for Worker Nodes"
}

variable "cluster_encryption_key" {
  type        = string
  description = "KMS Encryption Key to Encrypt ETCD"
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes Cluster Name"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes Cluster Version"
}

variable "enable_private_access" {
  type        = bool
  description = "Enable Acess from VPC to API Server"
  default     = true
}

variable "enable_public_access" {
  type        = bool
  description = "Enable Public Access to API Server"
  default     = false
}

variable "instance_type" {
  type        = string
  description = "EKS Managed NodeGroup Instance Types"
  default     = "m6i.large"
}

variable "node_disk_size" {
  type        = number
  description = "Node Disk Size"
  default     = 50
}

variable "node_desired_count" {
  type        = number
  description = "Desired Node Group Size"
  default     = 1
}

variable "node_max_count" {
  type        = string
  description = "Maximum Node Group Size"
  default     = 2
}

variable "node_min_count" {
  type        = string
  description = "Minimum Node Group Size"
  default     = 1
}

variable "subnets" {
  type        = list(string)
  description = "Subnets to Deploy EKS Node Group into"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to EKS Cluster"
}

variable "vpc_id" {
  type = string
  description = "VPC ID for EKS Cluster"
}
