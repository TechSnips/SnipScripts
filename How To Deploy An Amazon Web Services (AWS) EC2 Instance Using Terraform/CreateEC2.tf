provider "aws" {
  region     = "eu-west-2"
  shared_credentials_file = "c:/Users/admin/.aws/credentials"
  profile = "TechSNIPS"

}
resource "aws_instance" "example" {
  ami           = "ami-0c09927662c939f41"
  instance_type = "t2.micro"
  tags {
    name = "TESTVM"
  }  
}