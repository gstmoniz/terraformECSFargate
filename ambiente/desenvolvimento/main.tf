module "dev" {
  source = "../../infraestrutura"
  aws-region = "us-west-2"
  default-name = "dev"
}

output "dns-app-node" {
  value = module.dev.app-node-dns
}