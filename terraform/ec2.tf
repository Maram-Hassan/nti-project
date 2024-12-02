resource "aws_security_group" "Jenkins-sg" {
  name        = "Jenkins-sg"
  description = "Allow Jenkins inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22  
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { 
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}



resource "aws_instance" "jenkins" {
  ami           = var.myami
  instance_type = "t2.medium" 
  key_name      = var.mykey
  subnet_id     = aws_subnet.pub1_subnet.id
  security_groups = [aws_security_group.Jenkins-sg.id]
  # user_data     = file("installingJenkins.sh") ----> will be installed via ansible
  tags = {
    Name = "Jenkins-Server"
  }
}

resource "aws_backup_plan" "daily_snapshot" {
  name = "daily-backup-plan"

  rule {
    rule_name         = "daily-backup-rule"
    target_vault_name = aws_backup_vault.jenkins_vault.name
    schedule          = "cron(0 12 * * ? *)"

    lifecycle {
      delete_after = 30 # Retain for 30 days
    }
  }
}

resource "aws_backup_vault" "jenkins_vault" {
  name = "jenkins-backup-vault"
}

resource "aws_backup_selection" "jenkins_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "jenkins-backup-selection"
  plan_id      = aws_backup_plan.daily_snapshot.id

  # Add the Jenkins instance as a resource to back up
  resources = [
    aws_instance.jenkins.arn
  ]
}

resource "aws_iam_role" "backup_role" {
  name = "BackupServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "backup.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backup_attach" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}
