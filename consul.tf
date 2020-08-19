module "consul" {
  source       = "hashicorp/consul/aws"
  version      = "0.7.7"
  vpc_id       = module.vpc.vpc_id
  cluster_name = var.project_name
  ssh_key_name = aws_key_pair.zero_thirteen.key_name
}
