provider "aws" {
  region = "eu-central-1" # Remplacez par la région de votre choix
}

resource "aws_instance" "my_instance" {
  ami           = "ami-09042b2f6d07d164a" # Remplacez par l'AMI de votre choix
  instance_type = "m5.xlarge" # Type d'instance avec 4 vCPU et 16 Go de RAM

  root_block_device {
    volume_size = 10 # Root volume
  }

  tags = {
    Name = "aws-holesky-nethermind-nimbus-001"
  }
}

resource "aws_ebs_volume" "data_volume" {
  availability_zone = aws_instance.my_instance.availability_zone
  size              = 200 # 200Go for block-volume

  tags = {
    Name = "chain-block-volume"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdb" # Peut varier selon le système d'exploitation
  volume_id   = aws_ebs_volume.data_volume.id
  instance_id = aws_instance.my_instance.id
}
