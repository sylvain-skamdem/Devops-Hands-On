resource "aws_security_group" "security_group" {
  name        = "SSH-HTTP Communication"
  description = "Allow inbound traffic to the Kubernetes cluster"

  dynamic "ingress" {
    for_each = var.security_group
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port2
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name                = "my_sec_grp"
    LaunchedByTerraform = "True"
  }
}

resource "aws_key_pair" "kubekeypair" {
  depends_on = [aws_security_group.security_group]
  key_name   = "kubekeypair"
  public_key = file("${path.module}/mypubkey")
}

resource "aws_iam_role" "k8s" {
  name               = "Ec2-k8s-bootstrap-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "k8s" {
  depends_on = [aws_iam_role.k8s]
  name       = "role-policy"
  roles      = [aws_iam_role.k8s.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "k8s1" {
  depends_on = [aws_iam_role.k8s]
  name       = "role-policy"
  roles      = [aws_iam_role.k8s.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_policy_attachment" "k8s2" {
  depends_on = [aws_iam_role.k8s]
  name       = "role-policy"
  roles      = [aws_iam_role.k8s.name]
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_policy_attachment" "k8s3" {
  depends_on = [aws_iam_role.k8s]
  name       = "role-policy"
  roles      = [aws_iam_role.k8s.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_policy_attachment" "k8s4" {
  depends_on = [aws_iam_role.k8s]
  name       = "role-policy"
  roles      = [aws_iam_role.k8s.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_policy_attachment" "k8s5" {
  depends_on = [aws_iam_role.k8s]
  name       = "role-policy"
  roles      = [aws_iam_role.k8s.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_policy_attachment" "k8s6" {
  depends_on = [aws_iam_role.k8s]
  name       = "role-policy"
  roles      = [aws_iam_role.k8s.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}

resource "aws_iam_instance_profile" "profile" {
  name = "my_profile"
  role = aws_iam_role.k8s.name
}

resource "aws_instance" "skubuntu_server" {
  depends_on        = [aws_key_pair.kubekeypair]
  ami               = "ami-06b09bfacae1453cb"
  instance_type     = "t2.micro"
  key_name          = aws_key_pair.kubekeypair.key_name
  availability_zone = "us-east-1d"
  security_groups   = [aws_security_group.security_group.name]
  user_data         = file("${path.module}/userdata.sh")
  tags = {
    "Name" = "skubuntu_server"
  }
  iam_instance_profile = aws_iam_instance_profile.profile.name
}

resource "aws_route53_zone" "my_hosted_zone" {
  name = "druide.in"
  vpc {
    vpc_id = "vpc-0139cbead63908182"
  }
}

resource "aws_s3_bucket" "my_s3" {
  bucket = "useast1m.k8s.druide.in"
}

resource "aws_s3_bucket_versioning" "my_s3" {
  bucket = aws_s3_bucket.my_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "my_s3" {
  bucket = aws_s3_bucket.my_s3.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "my_s3" {
  depends_on = [aws_s3_bucket_ownership_controls.my_s3]
  bucket     = aws_s3_bucket.my_s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "my_s3" {
  depends_on = [aws_s3_bucket_public_access_block.my_s3]
  bucket     = aws_s3_bucket.my_s3.id
  acl        = "public-read"
}

resource "null_resource" "ubuntu_server" {
  depends_on = [aws_instance.skubuntu_server]
  triggers = {
    change = timestamp()
  }

  connection {
    agent       = false
    type        = "ssh"
    user        = "ansadmin"
    password    = "test123"
    host        = element(aws_instance.skubuntu_server.*.public_ip, 0)
    private_key = file("${path.module}/skeypair.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 60",
      "source /home/ansadmin/.bash_profile",
      "kops create cluster --name=useast1m.k8s.druide.in --state=s3://useast1m.k8s.druide.in --cloud=aws --zones=us-east-1a --node-count=2 --node-size=t2.medium --ssh-public-key=/home/ansadmin/.ssh/id_rsa.pub --dns-zone=druide.in --dns private",
      "kops update cluster --name useast1m.k8s.druide.in --state=s3://useast1m.k8s.druide.in --yes --admin",
      "kops validate cluster --state=s3://useast1m.k8s.druide.in --wait 10m"
    ]
    on_failure = continue
  }

}