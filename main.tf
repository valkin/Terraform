# -------------------------
# Define el provider de AWS
# -------------------------
provider "aws" {
  region = "us-east-2"
  shared_config_files      = ["/home/mduran/.aws/config"]
  shared_credentials_files = ["/home/mduran/.aws/credentials"]
}

# ----------------------------------------------------
# Data Source para obtener el ID de la VPC por defecto
# ----------------------------------------------------
data "aws_vpc" "default" {
  default = true
}

# -----------------------------------------------
# Data source que obtiene el id del AZ us-east-2a
# -----------------------------------------------
data "aws_subnet" "az_a" {
  availability_zone = "us-east-2a"
}

# -----------------------------------------------
# Data source que obtiene el id del AZ us-east-2c
# -----------------------------------------------
data "aws_subnet" "az_c" {
  availability_zone = "us-east-2c"
}

# ---------------------------------------
# Define una instancia EC2 con AMI Ubuntu
# ---------------------------------------
resource "aws_instance" "serverTF_1" {
    ami           = "ami-0cfde0ea8edd312d4" #Ubuntu server 24 LTD 2 AMI (HVM), SSD Volume Type
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.TerraformRules.id]


user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install -y nginx
                sudo systemctl start nginx
                sudo systemctl enable nginx
                echo "<h1>Deployed via Terraform</h1><br><h2>Server-1</h2>" | sudo tee /var/www/html/index.html
                
                # Update NGINX to listen on port 8080
                sudo sed -i 's/listen 80 default_server;/listen 8080 default_server;/g' /etc/nginx/sites-available/default
                
                # Restart NGINX to apply the changes
                sudo systemctl restart nginx
                
                EOF

  tags = {
        Name = "Server-TF-1"
    }
}

# ----------------------------------------------
# Define la segunda instancia EC2 con AMI Ubuntu
# ----------------------------------------------
resource "aws_instance" "serverTF_2" {
    ami           = "ami-0cfde0ea8edd312d4" #Ubuntu server 24 LTD 2 AMI (HVM), SSD Volume Type
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.TerraformRules.id]

  
user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install -y nginx
                sudo systemctl start nginx
                sudo systemctl enable nginx
                echo "<h1>Deployed via Terraform</h1><br><h2>Server-2</h2>" | sudo tee /var/www/html/index.html

                # Update NGINX to listen on port 8080
                sudo sed -i 's/listen 80 default_server;/listen 8080 default_server;/g' /etc/nginx/sites-available/default
                
                # Restart NGINX to apply the changes
                sudo systemctl restart nginx

                EOF

  tags = {
        Name = "Server-TF-2"
    }
}

# ------------------------------------------------------
# Define un grupo de seguridad con acceso al puerto 8080
# ------------------------------------------------------
resource "aws_security_group" "TerraformRules" {
  name        = "TerraformRules"
  description = "Allow inbound traffic on port 8080"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Acceso al puerto 8080 desde el exterior"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}