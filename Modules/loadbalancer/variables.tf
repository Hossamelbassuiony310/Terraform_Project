#==================================================================
#============================Loadbalancer==========================
#==================================================================

variable "name_lb" {
  type        = string
  default     = ""
  description = "name_loadbalancer"
}

variable "internal_or_internetfacing" {
  type        = bool
  default     = "false"
  description = "internal should be true and internet-facing should be false"
}

variable "load_balancer_type" {
  type        = string
  default     = "application"
  description = "load_balancer_type should be Application or Network or Gateway"
}

variable "security_groups" {
  type        = string
  default     = ""
  description = "security_groups"
}

variable "subnet_1" {
  type        = string
  default     = ""
  description = "subnet_1"
}

variable "subnet_2" {
  type        = string
  default     = ""
  description = "subnet_2"
}

variable "name_tag_lb" {
  type        = string
  default     = ""
  description = "name_tag_loadbalancer"
}

#==================================================================
#============================Target_Groups=========================
#==================================================================

variable "name_tg" {
  type        = string
  default     = ""
  description = "name_target_group"
}

variable "vpc_id_in_tg" {
  type        = string
  default     = ""
  description = "vpc_id_in_target_group"
}

variable "name_tag_tg" {
  type        = string
  default     = ""
  description = "name_tag_target_group"
}

#==================================================================
#=====================Target_Group_Attachment======================
#==================================================================

variable "target_instance_1_id" {
  type        = string
  default     = ""
  description = "target_instance_1_id"
}

variable "target_instance_2_id" {
  type        = string
  default     = ""
  description = "target_instance_2_id"
}