terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  #s3 bucket in terraform aws
  backend "s3" {
    bucket         = "more-two"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "simple2-ec2" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  count         = 1

  tags = {
    Name = "Simple ec2 instance"
    Local = local.aws_tag
  }
  key_name               = aws_key_pair.classkey.key_name
  vpc_security_group_ids = [aws_security_group.sec.id]


  provisioner "remote-exec" {
    when   = create
    script = "./install_docker.sh"
  }


  provisioner "remote-exec" {
    script = "./install_nginx.sh"
  }


  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./classkey.pem")
    host        = self.public_ip
  }


}

resource "aws_security_group" "sec" {
  name = "secgroup"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH (Change too your IP)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_key_pair" "classkey" {
  key_name   = "classkey.pem"
  public_key = file("./classkey.pub")
}


data "aws_security_group" "get-data-sg-data" {
  name = aws_security_group.sec.name
}

data "aws_instance" "simple2-ec2" {
  instance_id = aws_instance.simple2-ec2[0].id # Reference the created instance ID
}

