// create Private Key Material for use as SSH Key
resource "tls_private_key" "zero_thirteen" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "aws_key_pair" "zero_thirteen" {
  key_name   = var.project_name
  public_key = tls_private_key.zero_thirteen.public_key_openssh
}

// render Private Key part of SSH Key as a local file
resource "local_file" "private_ssh_key" {
  content  = tls_private_key.zero_thirteen.private_key_pem
  filename = "${path.module}/${var.ssh_key_file}"

  // set correct permissions on Private Key file
  file_permission = "0400"
}
