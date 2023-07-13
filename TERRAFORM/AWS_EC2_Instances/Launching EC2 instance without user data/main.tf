resource "aws_instance" "sk_instance" {
  ami = "ami-02f3f602d23f1659d"
  instance_type = "t2.micro"
  count = 2
  key_name = "EC2 Tutorial - Sylvain"
  tags = {
    Name = "EC2-Demo-Sk"
    ManagedBy = "Terraform"
  }
}