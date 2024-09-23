### AWS Infrastructure Overview

This diagram illustrates a complex multi-tier architecture deployed on Amazon Web Services (AWS) using Infrastructure as Code (IaC) tools, such as Terraform. The architecture is designed for high availability, scalability, and security, utilizing both public and private resources distributed across multiple subnets.

### Key Components

1. **Virtual Private Cloud (VPC)**
   - The core of the network infrastructure, `aws_vpc.myvpc`, which hosts all AWS resources, ensuring secure and isolated networking.

2. **Security Groups**
   - **bastion_sg**: Controls access to the bastion host, allowing secure SSH access to internal instances.
   - **public_lb_sg**: Security group for the public load balancer, handling inbound traffic.
   - **private_lb_sg**: Security group for the private load balancer, handling internal traffic.
   - **reverse_proxy_sg**: Controls access to the reverse proxy host, allowing secure SSH access to bastion instances and HTTP access to the public load balancer.
   - **nginx_sg**: Controls access to the nginx host(backend server), allowing secure SSH access to bastion instances and HTTP access to the private load balancer.

3. **Subnets**
   - **Public Subnets** (`public1`, `public2`): Subnets for resources that require internet access, like the bastion host and public-facing load balancers.
   - **Private Subnets** (`private1`, `private2`): Subnets for internal resources, such as EC2 instances and private load balancers.

4. **Routing and Internet Access**
   - **Public Route Table** (`aws_route_table.public`): Manages routing for public subnets.
   - **Private Routing** (`aws_route.private_route`): Handles routing within the private subnets.
   - **Internet Gateway** (`aws_internet_gateway.igw`): Provides internet access to resources in public subnets.
   - **NAT Gateway** (`aws_nat_gateway.nat`): Allows instances in private subnets to access the internet securely without exposing them to the public internet.

5. **Load Balancers**
   - **Public Load Balancer** (`aws_lb.public_lb`): Distributes incoming internet traffic across public-facing resources.
   - **Private Load Balancer** (`aws_lb.private_lb`): Handles traffic for internal resources.
   - **Listeners and Target Groups**: 
     - **Public Listener** (`public_lb_http`) and **Private Listener** (`private_lb_http`): Direct traffic to specific target groups.
     - **Target Groups** (`nginx_tg`, `reverse_proxy_tg`): Distribute traffic between multiple instances, such as Nginx servers or reverse proxy instances.

6. **EC2 Instances**
   - **Bastion Host** (`aws_instance.bastion_host`): A secure instance used for SSH access to resources in private subnets.
   - **Nginx Servers** (`nginx1`, `nginx2`): Web servers distributed across different subnets to handle incoming traffic.
   - **Reverse Proxy Servers** (`reverse_proxy1`, `reverse_proxy2`): Instances dedicated to reverse proxying for internal services.

7. **Elastic IP and S3 Bucket**
   - **Elastic IP** (`aws_eip.lb`): An IP address assigned to the load balancer to ensure consistent public access.
   - **S3 Bucket** (`aws_s3_bucket.S3_Bucket`): Used for storing static assets or for storing Terraform state files.

8. **DynamoDB for Terraform State Locking**
   - **DynamoDB Table** (`aws_dynamodb_table.dynamodb-terraform-state-lock`): Manages state locking to prevent concurrent operations while deploying infrastructure with Terraform.

9. **Amazon Machine Image (AMI)**
   - **AMI** (`data.aws_ami.ubuntu`): The Ubuntu-based image used to launch EC2 instances.

### Summary

This architecture efficiently manages public-facing and private resources with appropriate security and routing measures. Public subnets handle external access via a bastion host and load balancers, while private subnets secure internal resources like reverse proxies and Nginx servers. AWS services such as S3, DynamoDB, and Elastic IP ensure the infrastructure is stable and well-managed, while security groups and NAT gateways maintain robust security protocols.
