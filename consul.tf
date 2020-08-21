variable cluster {
  description = "for_each Consul configuration"
  type        = map
  default = {
    smol = {
      num_servers = 1,
      num_clients = 1
    },
    huge = {
      num_servers = 6,
      num_clients = 3
    }
  }
}

resource "random_password" "random" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?/£"
}

data "aws_ami" "consul_live" {
  most_recent = true
  name_regex  = "hashicorp-live-consul-*"
  owners      = ["self"]
}

module "consul_aws_cluster" {
  source  = "hashicorp/consul/aws//examples/example-with-custom-asg-role"
  version = "0.7.7"

  # Stuff for your cluster
  ami_id          = data.aws_ami.consul_live.image_id
  cluster_tag_key = "hashicorplive"
  #cluster_name                      = "hashicorplive-demo-consul"
  consul_service_linked_role_suffix = "hashicorplive-consul-role"
  ssh_key_name                      = aws_key_pair.hashicorplivedemokey.key_name
  vpc_id                            = module.vpc.vpc_id

  # Used to encrypt RPC traffic between nodes
  enable_rpc_encryption = true

  # Used to enable gossip encryption between nodes
  enable_gossip_encryption = true
  gossip_encryption_key    = random_password.random.result

  # for_each configuration block 
  for_each = var.cluster

  cluster_name = each.key
  num_servers  = each.value.num_servers
  num_clients  = each.value.num_clients
}
