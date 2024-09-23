provider "aws" {
  shared_config_files      = ["/home/hossam/.aws/config"]
  shared_credentials_files = ["/home/hossam/.aws/credentials"]
  profile                  = "default"
  region                   = "us-east-1"
}