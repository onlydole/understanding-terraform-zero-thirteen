module "eks" {
  source           = "terraform-aws-modules/eks/aws"
  cluster_name     = var.project_name
  cluster_version  = var.cluster_version
  version          = "12.2.0"
  subnets          = module.vpc.private_subnets
  vpc_id           = module.vpc.vpc_id
  write_kubeconfig = false

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  worker_groups = [
    {
      name                 = var.project_name
      asg_desired_capacity = 3
      asg_max_size         = 5
      instance_type        = "m5.large"
    }
  ]
}
