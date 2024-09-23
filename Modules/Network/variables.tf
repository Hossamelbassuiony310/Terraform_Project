#==============vpc_var===========================

variable "vpc_cidr" {
  type        = string
  default     = ""
  description = "put the cidr of your vpc like 10.0.0.0/16"
}

variable "vpc_tag_name" {
  type        = string
  default     = ""
  description = "put name of vpc"
}

variable "all_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "put the cidr of your vpc like 10.0.0.0/16"
}

#==============public1_subnet_var===========================

variable "public1_subnet_cidr" {
  type        = string
  default     = ""
  description = "put the cidr of your subnet like 10.0.1.0/24"
}

variable "public1_subnet_map_public_ip_on_launch" {
  type        = string
  default     = ""
  description = "put the map_public_ip_on_launch for your subnets that take true or false only"
}

variable "AZ1" {
  type        = string
  default     = ""
  description = "availability_zone"
}

variable "public1_subnet_tag_name" {
  type        = string
  default     = ""
  description = "put name of subnets"
}

#==============public2_subnet_var===========================

variable "public2_subnet_cidr" {
  type        = string
  default     = ""
  description = "put the cidr of your subnet like 10.0.1.0/24"
}

variable "public2_subnet_map_public_ip_on_launch" {
  type        = string
  default     = ""
  description = "put the map_public_ip_on_launch for your subnets that take true or false only"
}

variable "AZ2" {
  type        = string
  default     = ""
  description = "availability_zone"
}

variable "public2_subnet_tag_name" {
  type        = string
  default     = ""
  description = "put name of subnets"
}

#==============private1_subnet_var===========================

variable "private1_subnet_cidr" {
  type        = string
  default     = ""
  description = "put the cidr of your subnet like 10.0.1.0/24"
}

variable "private1_subnet_map_public_ip_on_launch" {
  type        = string
  default     = ""
  description = "put the map_public_ip_on_launch for your subnets that take true or false only"
}

variable "private1_subnet_tag_name" {
  type        = string
  default     = ""
  description = "put name of subnets"
}

#==============private2_subnet_var===========================

variable "private2_subnet_cidr" {
  type        = string
  default     = ""
  description = "put the cidr of your subnet like 10.0.1.0/24"
}

variable "private2_subnet_map_public_ip_on_launch" {
  type        = string
  default     = ""
  description = "put the map_public_ip_on_launch for your subnets that take true or false only"
}

variable "private2_subnet_tag_name" {
  type        = string
  default     = ""
  description = "put name of subnets"
}