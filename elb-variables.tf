# Whether to create an ALB ingress (True or False)
variable "create_alb_vm" {
  description = "Whether to create an ALB"
  type        = bool
  default     = false
}

# Whether to create an ALB ingress (True or False)
variable "create_nlb_vm" {
  description = "Whether to create an ALB"
  type        = bool
  default     = false
}

# Whether to create an ALB ingress (True or False)
variable "create_nlb_conatiner" {
  description = "Whether to create an ALB"
  type        = bool
  default     = false
}
