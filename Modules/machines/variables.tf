variable "instance_type" {
  type        = string
  default     = ""
  description = "instance_type"
}

variable "associate_public_ip_address" {
  type        = bool
  default     = "true"
  description = "associate_public_ip_address just true or false"
}

variable "key_name" {
  type        = string
  default     = ""
  description = "key_name"
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "subnet_id"
}

variable "security_groups" {
  type        = string
  default     = ""
  description = "security_groups"
}

variable "user_data" {
  type        = string
  default     = ""
  description = "user_data command line"
}

variable "instance_tag_name" {
  type        = string
  default     = ""
  description = "instance_tag_name"
}