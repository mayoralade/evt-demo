module "vpc" {
  source = "./modules/vpc"

  availability_zones        = var.availability_zones
  create_internet_gateway   = true
  create_nat_gateway        = true
  environment               = var.environment
  nat_gateway_count         = 1
  private_subnet_tags       = {
    "kubernetes.io/role/internal-elb" = "1"
  }
  project                   = var.project
  public_subnet_tags              = {
    "kubernetes.io/role/elb" = "1"
  }
  vpc_cidr                  = var.vpc_cidr
  vpc_enable_dns_support    = true
  vpc_enable_dns_hostnames  = true
  vpc_log_group_name        = "vpc-flowlogs"
  vpc_log_retention_in_days = 1
}

module "kms" {
  source = "./modules/kms"

  environment = var.environment
}

module "eks" {
  source = "./modules/eks"

  ami_id                 = data.aws_ami.eks_default.id
  cluster_encryption_key = module.kms.key_arn
  cluster_name           = "${var.environment}-cluster"
  cluster_version        = var.cluster_version
  enable_public_access   = true
  instance_type          = "m5.large"
  subnets                = keys(module.vpc.private_subnets)
  tags                   = local.tags
  vpc_id                 = module.vpc.vpc_id
}

module "lb-controller" {
  source       = "git::https://github.com/Young-ook/terraform-aws-eks.git//modules/lb-controller"
  cluster_name = module.eks.cluster_id
  oidc         = {
    "url" = module.eks.oidc_provider
    "arn" = module.eks.oidc_provider_arn
  }
  tags         = local.tags
}

resource "kubernetes_namespace" "default" {
  metadata {
    name = "evt"
  }
}

resource "random_password" "db_password" {
  length           = 16
  special          = false
}

module "database" {
  source = "./modules/manifests"

  depends_on = [
    module.eks
  ]

  configmap_data = {
    POSTGRES_DB       = var.db_name
  }

  secret_data = {
    POSTGRES_USER     = var.db_user
    POSTGRES_PASSWORD = random_password.db_password.result
  }

  add_configmap          = true
  add_secret             = true
  host_path              = "/mnt/data"
  image_name             = "postgres:10.4"
  name                   = var.db_host
  namespace              = kubernetes_namespace.default.metadata.0.name
  service_port           = var.db_port
  service_type           = "ClusterIP"
  use_deploy_with_volume = true
  volume_mount_path      = "/var/lib/postgresql/data"
  volume_size            = var.db_volume_size
}

module "backend" {
  source = "./modules/manifests"

  depends_on = [
    module.database
  ]

  configmap_data = {
    DB_HOST    = var.db_host
    DB_NAME    = var.db_name
    DB_PORT    = var.db_port
    IP_ADDRESS = "0.0.0.0"
  }

  secret_data = {
    DB_USER     = var.db_user
    DB_PASSWORD = random_password.db_password.result
    SECRET      = "secret"
  }

  add_configmap  = true
  add_secret     = true
  image_name     = "mayoralade/demo-backend"
  name           = "backend"
  namespace      = kubernetes_namespace.default.metadata.0.name
  service_port   = 3000
  service_type   = "ClusterIP"
}

module "frontend" {
  source = "./modules/manifests"

  depends_on = [
    module.backend,
    module.lb-controller
  ]

  image_name      = "mayoralade/demo-frontend"
  name            = "frontend"
  namespace       = kubernetes_namespace.default.metadata.0.name
  service_port    = 80
  service_type    = "NodePort"
  add_ingress     = true
  alb_scheme_type = "internet-facing"
}
