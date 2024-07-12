provider "aws" {
  region = "ap-northeast-1" # 도쿄 리전으로 설정
}

resource "aws_instance" "my_instance" { # ”타입” “terraform구성파일에서 참조할 이름”
  ami           = "ami-09d8ed8255877048d" # 원하는 AMI ID로 변경
  instance_type = "t2.micro"

  tags = {
    Name = "TerraformTest" # 실제 인스턴스 이름 
  }
}
