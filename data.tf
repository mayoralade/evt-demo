data "aws_ami" "eks_default" {
  filter {
    name   = "name"
    values = ["ubuntu-eks/k8s_${var.cluster_version}/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}
