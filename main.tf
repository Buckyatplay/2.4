locals {
  name_prefix = "choonyee"
  tags = {
    Purpose = "CE 8 - Assignment 2.4"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"
  name = "${local.name_prefix}-vpc"
  
  cidr = "10.0.0.0/16"
  azs = slice(data.aws_availability_zones.available.names, 0, 3) # ["ap-southeast-1a", "ap-southeast-1b","ap-southeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = local.tags
  }

output "nat_gateway_ids" {
 value = module.vpc.natgw_ids
}

# output1 for private subnets?
output "private_subnet_ids" {
    value = data.aws_subnets.private.ids
}

# output2 for private subnets?
output "private_subnet_id" {
  value       = data.aws_subnets.private[*].id
  #description = "subnet-05744f3975509942c"
}

# output3 for private subnets?
# output "private_subnets" {
#    value = data.aws_subnets.private
#}

# output4 for private subnets?
output "private_subnets" {
    value = module.vpc.private_subnets
}



variable "name" {
    description = "choonyee"
    type = string
    # default = "somename"
}

variable "vpc_id" {
    description = "vpc-0491a2bc0f0bbaeb4"
    type = string
    # default = "vpc-067f3ab097282bc4d"
}

data "vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["choonyee-vpc"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

/*
data "aws_subnets" "private" {
   filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["private-*"]
  }
}
*/

resource "aws_instance" "private" {
  #for_each      = toset(data.aws_subnets.private.ids)
  ami           = "ami-0f935a2ecd3a7bd5c"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnets.private.ids[0]

}



/* HOW TO GET THE PRIVATE SUBNETS OUTPUT?

nat_gateway_ids = [
  "nat-0ff20ecfabe0a816f",
]
private_subnet = {
  "filter" = toset([
    {
      "name" = "tag:Name"
      "values" = toset([
        "private-*",
      ])
    },
    {
      "name" = "vpc-id"
      "values" = toset([
        "yes",
      ])
    },
  ])
  "id" = "ap-southeast-1"
  "ids" = tolist([])
  "tags" = tomap(null) /* of string 
  "timeouts" = null object
}
private_subnet_id = [
  "ap-southeast-1",
]
private_subnet_ids = tolist([])
*/