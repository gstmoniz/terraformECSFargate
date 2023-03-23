module "prod" {
  source = "../../infraestrutura"
  aws-region = "us-west-2"
  default-name = "prod"
}