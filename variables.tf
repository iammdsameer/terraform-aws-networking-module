variable "vpc_config" {
  description = "Provide 'name' and 'cidr_block' in an object for the VPC."
  type = object({
    name       = string
    cidr_block = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "Got invalid value as an input for 'vpc_config.cidr_block'."
  }
}

variable "subnet_config" {
  description = "Provide a map of subnet's CIDR block and its availability zone"
  type = map(object({
    az         = string
    cidr_block = string
    public     = optional(bool, false)
  }))

  validation {
    condition     = alltrue([for name, config in var.subnet_config : can(cidrnetmask(config.cidr_block))])
    error_message = "Got an invalid value for one of CIDR blocks in variable 'subnet_config'."
  }
}
