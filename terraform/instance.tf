provider "aws" {
  region = "eu-central-1"
}

# Instance and volume for Nimbus
resource "aws_instance" "nimbus_instance" {
  ami           = "ami-09042b2f6d07d164a"
  instance_type = "m5.xlarge"

  root_block_device {
    volume_size = 10 # Root volume
  }

  tags = {
    Name = "aws-holesky-nimbus-001"
  }
}

resource "aws_ebs_volume" "nimbus_data_volume" {
  availability_zone = aws_instance.nimbus_instance.availability_zone
  size              = 200 # 200Go for block-volume

  tags = {
    Name = "nimbus-chain-block-volume"
  }
}

resource "aws_volume_attachment" "nimbus_ebs_att" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.nimbus_data_volume.id
  instance_id = aws_instance.nimbus_instance.id
}

# Instance and volume for Nethermind
resource "aws_instance" "nethermind_instance" {
  ami           = "ami-09042b2f6d07d164a"
  instance_type = "m5.xlarge"

  root_block_device {
    volume_size = 10 # Root volume
  }

  tags = {
    Name = "aws-holesky-nethermind-001"
  }
}

resource "aws_ebs_volume" "nethermind_data_volume" {
  availability_zone = aws_instance.nethermind_instance.availability_zone
  size              = 200 # 200Go for block-volume

  tags = {
    Name = "nethermind-chain-block-volume"
  }
}

resource "aws_volume_attachment" "nethermind_ebs_att" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.nethermind_data_volume.id
  instance_id = aws_instance.nethermind_instance.id
}
