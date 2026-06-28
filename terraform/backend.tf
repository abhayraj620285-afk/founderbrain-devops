terraform {
  backend "s3" {
    bucket       = "founderbrain-tfstate"
    key          = "eks/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
