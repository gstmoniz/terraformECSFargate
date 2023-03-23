terraform {
  backend "s3" {
    bucket = "terraformecsfargate-state"
    key    = "terraformProd/terraform.tfstate"
    region = "us-west-2"
    encrypt = true
  }
}