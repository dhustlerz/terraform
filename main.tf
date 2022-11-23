provider "aws" {
  region = "us-west-2"

}

module "ibt-vpc" {
  source = "./modules/subnet"
  organisation = "ibt"
  subnet_cidr_block = "10.0.10.0/24"
  vpc_cidr_block = "10.0.0.0/16"
}

module "ibt-server-dev" {
  source = "./modules/server"
  environment = "dev"
  organisation = "ibt"
  subnet-id = module.ibt-vpc.subnet.id
  sg-id = module.ibt-vpc.security-group.id
  instance_type = "t2.micro"
}

module "ibt-server-prod" {
  source = "./modules/server"
  environment = "prod"
  organisation = "ibt"
  subnet-id = module.ibt-vpc.subnet.id
  sg-id = module.ibt-vpc.security-group.id
  instance_type = "t2.micro"
}

module "ibt-server-uat" {
  source = "./modules/server"
  environment = "uat"
  organisation = "ibt"
  subnet-id = module.ibt-vpc.subnet.id
  sg-id = module.ibt-vpc.security-group.id
  instance_type = "t2.micro"
}
