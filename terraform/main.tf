resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04 AMI
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              docker run -d -p 5000:5000 ${var.docker_image}
              EOF

  tags = {
    Name = "HelloWorld-App"
  }
}