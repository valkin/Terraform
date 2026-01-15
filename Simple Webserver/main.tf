provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "mi_servidor" {
  ami                    = "ami-0cfde0ea8edd312d4"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mi_seguridad.id]

  user_data = <<-EOF
            #!/bin/bash
            echo "La Terraform esta funcionando" > index.html
            nohup busybox httpd -f -p 8080 &
            EOF

  tags = {
    Name = "Servidor-1"
  }
}

resource "aws_security_group" "mi_seguridad" {
  name = "primer_server_sg"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
