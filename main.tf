#==================================================================
#=========================VPC_and_Subnets==========================
#==================================================================
module "VPC_and_Subnets" {
  source = "/home/hossam/Terraform_Tutorial/lap3/Modules/Network"
  vpc_cidr = "10.0.0.0/16"
  vpc_tag_name = "mainvpc"
  public1_subnet_cidr = "10.0.10.0/24"
  public1_subnet_map_public_ip_on_launch = "true"
  AZ1 = "us-east-1a"
  public1_subnet_tag_name = "public1"
  public2_subnet_cidr = "10.0.20.0/24"
  public2_subnet_map_public_ip_on_launch = "true"
  AZ2 = "us-east-1b"
  public2_subnet_tag_name = "public2"
  private1_subnet_cidr = "10.0.30.0/24"
  private1_subnet_map_public_ip_on_launch = "false"
  private1_subnet_tag_name = "private1"
  private2_subnet_cidr = "10.0.40.0/24"
  private2_subnet_map_public_ip_on_launch = "false"
  private2_subnet_tag_name = "private2"
}

#==================================================================
#=========================Bastion_Security_Group===================
#==================================================================

module "bastion_sg" {
  source = "/home/hossam/Terraform_Tutorial/lap3/Modules/SG"
  name_SG = "bastion_sg"
  vpc_id = module.VPC_and_Subnets.vpc_id
  SG_tag_name = "bastion_sg"
  
  ingress = {
    http = {
      from_port = 22
      to_port = 22
      ip_protocol = "tcp"
      cidr_ipv4 = var.all_cidr 
      refrence_to_Security_Group_id = null
    }
  }
}

#==================================================================
#===================Reverse_Proxy_LB_Security_Group================
#==================================================================

module "reverse_proxy_lb_sg" {
  source = "/home/hossam/Terraform_Tutorial/lap3/Modules/SG"
  name_SG = "reverse_proxy_lb_sg"
  vpc_id = module.VPC_and_Subnets.vpc_id
  SG_tag_name = "reverse_proxy_lb_sg"
  
  ingress = {
    http = {
      from_port = 80
      to_port = 80
      ip_protocol = "tcp"
      cidr_ipv4 = var.all_cidr 
      refrence_to_Security_Group_id = null
    }
  }
}

#==================================================================
#=====================Reverse_Proxy_Security_Group=================
#==================================================================

module "reverse_proxy_sg" {
  source = "/home/hossam/Terraform_Tutorial/lap3/Modules/SG"
  name_SG = "reverse_proxy_sg"
  vpc_id = module.VPC_and_Subnets.vpc_id
  SG_tag_name = "reverse_proxy_sg"
  
  ingress = {
    http = {
      from_port = 80
      to_port = 80
      ip_protocol = "tcp"
      cidr_ipv4 = null
      refrence_to_Security_Group_id = module.reverse_proxy_lb_sg.SG_id
    }

    ssh = {
      from_port = 22
      to_port = 22
      ip_protocol = "tcp"
      cidr_ipv4 = null 
      refrence_to_Security_Group_id = module.bastion_sg.SG_id
    }
  }
}

#==================================================================
#=======================Nginx_LB_Security_Group====================
#==================================================================

module "nginx_lb_sg" {
  source = "/home/hossam/Terraform_Tutorial/lap3/Modules/SG"
  name_SG = "nginx_lb_sg"
  vpc_id = module.VPC_and_Subnets.vpc_id
  SG_tag_name = "nginx_lb_sg"
  
  ingress = {
    http = {
      from_port = 80
      to_port = 80
      ip_protocol = "tcp"
      cidr_ipv4 = null
      refrence_to_Security_Group_id = module.reverse_proxy_sg.SG_id
    }
  }
}

#==================================================================
#=======================Nginx_Security_Group=======================
#==================================================================

module "nginx_sg" {
  source = "/home/hossam/Terraform_Tutorial/lap3/Modules/SG"
  name_SG = "nginx_sg"
  vpc_id = module.VPC_and_Subnets.vpc_id
  SG_tag_name = "nginx_sg"
  
  ingress = {
    http = {
      from_port = 80
      to_port = 80
      ip_protocol = "tcp"
      cidr_ipv4 = null
      refrence_to_Security_Group_id = module.nginx_lb_sg.SG_id
    }

    ssh = {
      from_port = 22
      to_port = 22
      ip_protocol = "tcp"
      cidr_ipv4 = null
      refrence_to_Security_Group_id = module.bastion_sg.SG_id
    }
  }
}

#==================================================================
#=====================Reverse_Proxy_1_Ubuntu_Instance==============
#==================================================================

module "reverse_proxy_1_ubuntu_instance" {
  source = "/home/hossam/Terraform_Tutorial/lap3/Modules/machines"
  instance_type = "t2.micro"
  key_name = "task"
  subnet_id = module.VPC_and_Subnets.public1_subnets_id
  security_groups = module.reverse_proxy_sg.SG_id
  user_data = <<-EOF
    #!/bin/bash
    # Update package lists
    apt-get update

    # Install Nginx
    apt-get install -y nginx

    # Create a configuration file for Nginx
    cat <<CONFIG > /etc/nginx/sites-available/reverse_proxy
    server {
        listen 80;

        location / {
            proxy_pass http://${module.nginx_lb.lb_dns_name};
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
    CONFIG

    # Create a symbolic link to enable the configuration
    ln -s /etc/nginx/sites-available/reverse_proxy /etc/nginx/sites-enabled/

    # Remove the default configuration
    rm /etc/nginx/sites-enabled/default

    # Restart Nginx to apply changes
    systemctl restart nginx

  EOF
  instance_tag_name = "reverse_proxy_1"
}

#==================================================================
#=====================Reverse_Proxy_2_Ubuntu_Instance==============
#==================================================================

module "reverse_proxy_2_ubuntu_instance" {
  source = "/home/hossam/Terraform_Tutorial/lap3/Modules/machines"
  instance_type = "t2.micro"
  key_name = "task"
  subnet_id = module.VPC_and_Subnets.public2_subnets_id
  security_groups = module.reverse_proxy_sg.SG_id
  user_data = <<-EOF
    #!/bin/bash
    # Update package lists
    apt-get update

    # Install Nginx
    apt-get install -y nginx

    # Create a configuration file for Nginx
    cat <<CONFIG > /etc/nginx/sites-available/reverse_proxy
    server {
        listen 80;

        location / {
            proxy_pass http://${module.nginx_lb.lb_dns_name};
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
    CONFIG

    # Create a symbolic link to enable the configuration
    ln -s /etc/nginx/sites-available/reverse_proxy /etc/nginx/sites-enabled/

    # Remove the default configuration
    rm /etc/nginx/sites-enabled/default

    # Restart Nginx to apply changes
    systemctl restart nginx

  EOF
  instance_tag_name = "reverse_proxy_2"
}

#==================================================================
#=====================Nginx_1_Ubuntu_Instance================
#==================================================================

module "nginx_1_ubuntu_instance" {
  associate_public_ip_address = false
  source = "/home/hossam/Terraform_Tutorial/lap3/Modules/machines"
  instance_type = "t2.micro"
  key_name = "task"
  subnet_id = module.VPC_and_Subnets.private1_subnets_id
  security_groups = module.nginx_sg.SG_id
  user_data = <<-EOF
    #!/bin/bash
    # Update package lists
    apt-get update

    # Install Nginx
    apt-get install -y nginx

    # Create a basic HTML page to serve
    cat <<HTML > /var/www/html/index.html
    <!DOCTYPE html>
    <html>
    <head>
        <title>Welcome to Nginx</title>
    </head>
    <body>
        <h1>Hello from $(hostname)</h1>
    </body>
    </html>
    HTML

    # Set the default Nginx configuration
    cat <<NGINX > /etc/nginx/sites-available/default
    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;
        index index.html;

        server_name _;

        location / {
            try_files \$uri \$uri/ =404;
        }
    }
    NGINX

    # Restart Nginx to apply changes
    systemctl restart nginx
  EOF
  instance_tag_name = "nginx_1"
}

#==================================================================
#=======================Nginx_2_Ubuntu_Instance====================
#==================================================================

module "nginx_2_ubuntu_instance" {
  associate_public_ip_address = false
  source = "/home/hossam/Terraform_Tutorial/lap3/Modules/machines"
  instance_type = "t2.micro"
  key_name = "task"
  subnet_id = module.VPC_and_Subnets.private2_subnets_id
  security_groups = module.nginx_sg.SG_id
  user_data = <<-EOF
    #!/bin/bash
    # Update package lists
    apt-get update

    # Install Nginx
    apt-get install -y nginx

    # Create a basic HTML page to serve
    cat <<HTML > /var/www/html/index.html
    <!DOCTYPE html>
    <html>
    <head>
        <title>Welcome to Nginx</title>
    </head>
    <body>
        <h1>Hello from $(hostname)</h1>
    </body>
    </html>
    HTML

    # Set the default Nginx configuration
    cat <<NGINX > /etc/nginx/sites-available/default
    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;
        index index.html;

        server_name _;

        location / {
            try_files \$uri \$uri/ =404;
        }
    }
    NGINX

    # Restart Nginx to apply changes
    systemctl restart nginx
  EOF
  instance_tag_name = "nginx_2"
}

#==================================================================
#=====================Reverse_Proxy_Loadbalancer===================
#==================================================================

module "reverse_proxy_lb" {
  source = "/home/hossam/Terraform_Tutorial/lap3/Modules/loadbalancer"
  name_lb = "reverse-proxy-lb"
  internal_or_internetfacing = false
  security_groups = module.reverse_proxy_lb_sg.SG_id
  subnet_1 = module.VPC_and_Subnets.public1_subnets_id
  subnet_2 = module.VPC_and_Subnets.public2_subnets_id
  name_tag_lb = "reverse_proxy_lb"


  name_tg = "reverse-proxy-tg"
  vpc_id_in_tg = module.VPC_and_Subnets.vpc_id
  name_tag_tg = "reverse_proxy_tg"

  target_instance_1_id = module.reverse_proxy_1_ubuntu_instance.Ubuntu_instance_id
  target_instance_2_id = module.reverse_proxy_2_ubuntu_instance.Ubuntu_instance_id
}

#==================================================================
#=========================Nginx_Loadbalancer=======================
#==================================================================

module "nginx_lb" {
  source = "/home/hossam/Terraform_Tutorial/lap3/Modules/loadbalancer"
  name_lb = "nginx-lb"
  internal_or_internetfacing = true
  security_groups = module.nginx_lb_sg.SG_id
  subnet_1 = module.VPC_and_Subnets.private1_subnets_id
  subnet_2 = module.VPC_and_Subnets.private2_subnets_id
  name_tag_lb = "nginx_lb"


  name_tg = "nginx-tg"
  vpc_id_in_tg = module.VPC_and_Subnets.vpc_id
  name_tag_tg = "nginx_tg"

  target_instance_1_id = module.nginx_1_ubuntu_instance.Ubuntu_instance_id
  target_instance_2_id = module.nginx_2_ubuntu_instance.Ubuntu_instance_id
}