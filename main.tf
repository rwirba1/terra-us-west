provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "jenkins" {
  name        = "jenkins-security-group"

  tags = {
    Name = "jenkins-sg"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["54.162.46.37/32", "172.31.27.249/32"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]      
  }
}

resource "aws_security_group" "nexus" {
  name        = "nexus-security-group"

  tags = {
    Name = "nexus-terraform-sg"
  }  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["54.162.46.37/32" , "172.31.27.249/32"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["54.162.46.37/32"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    security_groups = [aws_security_group.jenkins.id]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sonarqube" {
  name        = "sonarqube-security-group"

  tags = {
    Name = "sonarqube-terraform-sg"
  }    

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["54.162.46.37/32" , "172.31.27.249/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["72.41.0.101/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.jenkins.id]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "jenkins_from_sonarqube" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.jenkins.id
  source_security_group_id = aws_security_group.sonarqube.id
}

resource "aws_instance" "jenkins" {
  ami = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.small"
  key_name = "techapp-key"

  vpc_security_group_ids = [aws_security_group.jenkins.id]

  tags = {
    Name = "Jenkins-terraform"
  }
}

resource "aws_instance" "nexus" {
  ami = "ami-0fa1ca9559f1892ec"
  instance_type = "t2.medium"
  key_name = "techapp-key"

  vpc_security_group_ids = [aws_security_group.nexus.id]

  tags = {
    Name = "nexus-terraform"
  }
}

resource "aws_instance" "sonarqube" {
  ami = "ami-06aa3f7caf3a30282"
  instance_type = "t2.medium"
  key_name = "techapp-key"

  vpc_security_group_ids = [aws_security_group.sonarqube.id]

  tags = {
    Name = "sonar-terraform"
  }
}

