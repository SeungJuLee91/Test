provider "aws" {
  region = "us-east-1"
}

# 보안 그룹 생성 (로드 밸런서 연결용)
resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Security group for load balancer"
  vpc_id      = "vpc-12345678"  # 실제 환경에 맞게 수정

  ingress {
    from_port   = 80
    to_port     = 80
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

# Classic Load Balancer (aws_elb) 생성
resource "aws_elb" "legacy_elb" {
  name               = "legacy-elb"
  availability_zones = ["us-east-1a"]
  security_groups    = [aws_security_group.lb_sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Application Load Balancer (aws_lb) 생성
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = ["subnet-abc12345", "subnet-def67890"]  # 실제 환경에 맞게 수정
}

# 시크릿이 하드코딩된 리소스 (Secrets 정책 탐지를 위한 코드)
resource "aws_ssm_parameter" "leaked_secret" {
  name  = "/example/secret"
  type  = "SecureString"
  value = "/md6zwupJ3Bv49tHxsRezLFqKBBkHQ9fPLJGwymZ" # ❗ 의도적으로 하드코딩된 시크릿
}
