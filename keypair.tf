// create Private Key Material for use as SSH Key
resource "tls_private_key" "zero_thirteen" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "aws_key_pair" "zero_thirteen" {
  key_name   = var.project_name
  public_key = tls_private_key.zero_thirteen.public_key_openssh
}
