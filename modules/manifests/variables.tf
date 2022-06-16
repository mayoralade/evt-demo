variable "add_configmap" {
  type        = bool
  description = "Conditional to Add ConfigMap"
  default     = false
}

variable "use_deploy_with_volume" {
  type        = bool
  description = "Conditional to use Deployment with Volume Mounts"
  default     = false
}

variable "add_ingress" {
  type        = bool
  description = "Conditional to Add Ingress"
  default     = false
}

variable "add_secret" {
  type        = bool
  description = "Conditional to Add Secret"
  default     = false
}

variable "alb_scheme_type" {
  type        = string
  description = "ALB Scheme Type, internal or internet-facing"
  default     = "internal"
}

variable "configmap_data" {
  type        = map(string)
  description = "ConfigMap Data"
  default     = {}
}

variable "host_path" {
  type        = string
  description = "Host Path to Mount for Data Store"
  default     = ""
}

variable "image_name" {
  type        = string
  description = "Docker Image"
}

variable "name" {
  type        = string
  description = "Kubernetes Entity Name"
}

variable "namespace" {
  type        = string
  description = "Kubernetes Namespace"
}

variable "replicas" {
  type        = number
  description = "Number of Pod Replicas to deploy"
  default    = 1
}

variable "secret_data" {
  type        = map(string)
  description = "Secret Data"
  default     = {}
}

variable "service_port" {
  type        = number
  description = "Kubernetes Service Port"
}

variable "service_type" {
  type        = string
  description = "Kubernetes Service Type"
}

variable "volume_mount_path" {
  type        = string
  description = "Volume Mount Path"
  default     = ""
}

variable "volume_size" {
  type        = string
  description = "Volume Size"
  default     = ""
}
