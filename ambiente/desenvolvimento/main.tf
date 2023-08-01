module "dev" {
  source = "../../infraestrutura"
  aws-region = "us-west-2"
  default-name = "sphfs"
}

output "dns-sphfs" {
  value = module.dev.sphfs-dns
}