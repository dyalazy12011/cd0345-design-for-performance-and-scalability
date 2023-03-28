# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  region = "us-east-1"
}


# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "udacity_t2_micro" {
  ami           = "ami-00c39f71452c08778"
  count         = "4"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0640cddae1957ed68"
  tags = {
    Name = "Udacity T2"
  }
}


# TODO: provision 2 m4.large EC2 instances named Udacity M4
# resource "aws_instance" "udacity_m4_large" {
#  ami           = "ami-00c39f71452c08778"
#  count         = "2"
#  instance_type = "m4.large"
#  subnet_id     = "subnet-0640cddae1957ed68"
#  tags = {
#    Name = "Udacity M4"
#  }
# }
