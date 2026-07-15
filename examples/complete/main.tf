module "vpc" {
  source = "./modules/networking"
  vpc_config = {
    name       = "my-aws-vpc"
    cidr_block = "10.0.0.0/16"
  }
  subnet_config = {
    subnet_public = {
      cidr_block = "10.0.1.0/24"
      az         = "us-east-1a"
      public     = true
    }
    subnet_private = {
      cidr_block = "10.0.100.0/24"
      az         = "us-east-1b"
    }
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}
