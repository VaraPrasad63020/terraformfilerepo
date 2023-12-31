#provider
provider "aws" {
    region ="us-east-1"
    access_key = "AKIAUBRYJLTTUSNCKQCM" 
    secret_key = "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"
}
#Resource of multiple applications
resource "aws_instance" "multiple_applications" {
    ami="ami-041feb57c611358bd"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]
    tags = {
        Name="MultipleAppIns"
    }
    key_name = var.keypair
    
    connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file("Multiple-keypair")    
 }
 provisioner "remote-exec" {
  inline = [ 
"sudo yum update –y",
"sudo wget -O /etc/yum.repos.d/jenkins.repo  https://pkg.jenkins.io/redhat-stable/jenkins.repo",
"sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key",
"sudo yum upgrade",
"sudo dnf install java-17-amazon-corretto -y",
"sudo yum install jenkins -y",
"sudo systemctl enable jenkins",
"jenkins --version",
"sudo dnf update",
"sudo dnf install docker -y",
"sudo systemctl enable docker",
"docker --version",
"sudo dnf install -y redis6",
"sudo systemctl enable redis6",
"sudo systemctl is-enabled redis6",
"redis6-server --version"   
   ]
    }  
    
  }
resource "aws_db_instance" "RDS_DB" {
  identifier           = "mysql-db-01"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"  
  username             = "varaprasad"
  password             = "admin_123"
  allocated_storage    = 20
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_name = "mydb"

}
#Create the keypair the  of applications
resource "aws_key_pair" "tf-key-pair" {
key_name = "Multiple-keypair"
public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}
resource "local_file" "tf-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "Multiple-keypair"
} 
#Security group of multiple applications
resource "aws_security_group" "allow_ssh" {
  name        = "MultipleApp"
  description = "Allow SSH inbound traffic"
  #vpc_id      = aws_vpc.vpc_demo.id

  ingress {
    # SSH Port 22 allowed from any IP
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # SSH Port 80 allowed from any IP
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # SSH Port 3000 allowed from any IP
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # SSH Port 80 allowed from any IP
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # It's allowed the port 3306
    from_port   = 3306
    to_port     = 3306
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
