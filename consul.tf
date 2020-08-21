# Set Consul Cluster with secure configurations
# Description: 16 byte cryptographic key to encrypt gossip traffic between nodes. 
# Must set 'enable_gossip_encryption' to true for this to take effect. 
# WARNING: Setting the encryption key here means it will be stored in plain text. 
# We're doing this here to keep the example simple, but in production you should 
# inject it more securely, e.g. retrieving it from KMS.
resource "random_password" "random" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?/£"
}

data "aws_ami" "consul_live" {
  most_recent = true
  name_regex  = "hashicorp-live-consul-2020-*"
  owners      = ["self"]
}

module "consul_aws_cluster" {
  source  = "hashicorp/consul/aws//examples/example-with-custom-asg-role"
  version = "0.7.7"

  // Stuff for your cluster
  ami_id                            = data.aws_ami.consul_live.image_id
  cluster_tag_key                   = "hashicorplive"
  cluster_name                      = "hashicorplive-demo-consul"
  consul_service_linked_role_suffix = "hashicorplive-consul-role"
  num_servers                       = 3
  num_clients                       = 1
  ssh_key_name                      = aws_key_pair.hashicorplivedemokey.key_name
  vpc_id                            = module.vpc.vpc_id

  // Used to encrypt RPC traffic between nodes
  enable_rpc_encryption = true
  ca_path               = "/opt/consul/tls/ca"
  key_file_path         = "/opt/consul/tls/consul.key.pem"
  cert_file_path        = "/opt/consul/tls/consul.crt.pem"

  // Used to enable gossip encryption between nodes
  enable_gossip_encryption = true
  gossip_encryption_key    = random_password.random.result
}

module "consul_elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  name = var.project_name

  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.consul_default.id]
  internal        = false

  listener = [
    {
      instance_port     = "8500"
      instance_protocol = "HTTP"
      lb_port           = "8500"
      lb_protocol       = "HTTP"
    }
  ]

  health_check = {
    target              = "HTTP:8500/v1/status/leader"
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
}

resource "aws_security_group" "consul_default" {
  name        = "consul_default"
  description = "Allow inbound TCP traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TCP traffic VPC"
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "consul_default"
  }
}
