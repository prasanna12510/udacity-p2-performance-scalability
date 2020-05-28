resource "aws_instance" "Udacity_T2" {
  ami = "ami-0323c3dd2da7fb37d"
  instance_type = "t2.micro"
  count = 4
}

resource "aws_instance" "Udacity_M4" {
  ami = "ami-0323c3dd2da7fb37d"
  instance_type = "m4.large"
  count = 2
}
