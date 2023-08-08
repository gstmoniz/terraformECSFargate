variable dns_name {} # environment variable: export TF_VAR_dns_name

module "dev" {
  source = "../../infraestrutura"
  aws-region = "us-west-2"
  default-name = "sphfs"
  dns_name = var.dns_name
}

output "dns-sphfs" {
  value = module.dev.sphfs-dns
}