#==================================================================
#=========================Security_Group===========================
#==================================================================

resource "aws_security_group" "security_group" {
  name        = var.name_SG
  description = var.description_SG
  vpc_id      = var.vpc_id
  tags = {
    Name = var.SG_tag_name
  }
}

#==================================================================
#============================Inbound===============================
#==================================================================

resource "aws_vpc_security_group_ingress_rule" "proxy_ingress1_ipv4" {
  for_each = var.ingress


  security_group_id = aws_security_group.security_group.id
  referenced_security_group_id = each.value.refrence_to_Security_Group_id 
  from_port         = each.value.from_port 
  ip_protocol       = each.value.ip_protocol
  to_port           = each.value.to_port
  cidr_ipv4         = each.value.cidr_ipv4
}

#==================================================================
#===========================Outbound===============================
#==================================================================

resource "aws_vpc_security_group_egress_rule" "proxy_engress_ipv4" {
  for_each = var.egress


  security_group_id = aws_security_group.security_group.id
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  to_port           = each.value.to_port
  cidr_ipv4         = each.value.cidr_ipv4
}