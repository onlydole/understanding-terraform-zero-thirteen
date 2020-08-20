// create Private Key Material for use as SSH Key
// https://github.com/onlydole/iac-in-action/blob/main/keypair.tf
resource "tls_private_key" "hashicorplivedemokey" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

// register Public Key part of SSH Key with EC2 Console
resource "aws_key_pair" "hashicorplivedemokey" {
  key_name   = "Terraform-managed EC2 Key Pair for HashiCorp Live"
  public_key = tls_private_key.hashicorplivedemokey.public_key_openssh

  tags = {
    Name = "Terraform-managed EC2 Key Pair for HashiCorp Live"
  }
}

// render Private Key part of SSH Key as a local file
resource "local_file" "private_ssh_key" {
  content  = tls_private_key.hashicorplivedemokey.private_key_pem
  filename = "${path.module}/${var.ssh_key_file}"

  // set correct permissions on Private Key file
  file_permission = "0400"
}