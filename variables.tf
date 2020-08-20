variable "project_name" {
  type        = string
  description = "Globally used project name for this demo."
  default     = "zero-thirteen"
}

variable "region" {
  type        = string
  description = "AWS Region that will be used in this demo."
  default     = "us-west-2"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones that will be used in this demo."
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
  default     = "1.17"
}

variable "ssh_key_file" {
  type        = string
  description = "SSH Key file name"
  default     = "hashicorplivedemo-ssh-key.pem"
}

# 