module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = var.enable_private_access
  cluster_endpoint_public_access  = var.enable_public_access

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = var.cluster_encryption_key
    resources        = ["secrets"]
  }]

  vpc_id     = var.vpc_id
  subnet_ids = var.subnets

  # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    update_launch_template_default_version = true
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
  }

  self_managed_node_groups = {
    ondemand = {
      ami_id                     = var.ami_id
      enable_monitoring          = false
      instance_type              = var.instance_type
      min_size                   = var.node_min_count
      max_size                   = var.node_max_count
      desired_size               = var.node_desired_count
      security_group_rules = {
        ingress_cluster_9443 = {
          type                          = "ingress"
          protocol                      = "tcp"
          from_port                     = 9443
          to_port                       = 9443
          description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
          source_cluster_security_group = true
        }
      }
    }
  }

  # aws-auth configmap
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  tags = var.tags
}
