terraform {
  backend "s3" {
    bucket = "tfstate-anamika-demo"
    key    = "backend/anamika-demo.tfstate"
    region = "us-east-1"
    dynamodb_table = "remote-backend"
  }
}