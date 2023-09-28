provider "aws" {
  region = "us-east-1"
  secret_key = "DbkUXUZo3mGbC0m3PiECWTAcN8mECfe3ZozIT0WG"
  access_key = "AKIAWIRLAIO2TLKXPUG7"

}
variable "instance_type" {
  
}
variable "ami" {
  
}
resource "aws_instance" "aws_instance" {
  
  instance_type = var.instance_type
  ami=var.ami
}
