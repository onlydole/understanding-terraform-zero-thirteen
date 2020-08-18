variable "project_name" {
  type        = string
  description = "Globally used project name for this demo."
  default     = "zero-thirteen"
}

variable "project_region" {
  type        = string
  description = "AWS Region that will be used in this demo."
  default     = "us-west-2"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones that will be used in this demo."
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}
