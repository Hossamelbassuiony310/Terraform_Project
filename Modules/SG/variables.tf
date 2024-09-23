#==================================================================
#=====================Security_Group_var===========================
#==================================================================

variable "name_SG" {
  type        = string
  default     = ""
  description = "put name of SG"
}

variable "description_SG" {
  type        = string
  default     = "Allow TLS inbound traffic and all outbound traffic"
  description = "Description of SG"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "VPC ID"
}

variable "SG_tag_name" {
  type        = string
  default     = ""
  description = "put name of SG"
}

#==================================================================
#==============Security_Group_ingress_var==========================
#==================================================================

variable "ingress" {
  type = map(object({
    from_port   = number
    to_port    = number
    ip_protocol = string
    refrence_to_Security_Group_id = string
    cidr_ipv4 = string
  }))
  default = {}
}

#==================================================================
#==================Security_Group_egress_var=======================
#==================================================================

variable "egress" {
  type = map(object({
    cidr_ipv4   = string
    from_port   = number
    ip_protocol = string
    to_port     = number
  }))
  default = {
    default_rule = {
      from_port   = 0
      ip_protocol = "-1"
      to_port     = 0
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
}
