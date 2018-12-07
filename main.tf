variable "access_key" {}
variable "secret_key" {}
variable "region" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

#terraform {
#  backend "s3" {
#    bucket = "rc-remote-state-bucket"
#    key    = "terraform.tfstate"
#    region = "us-east-1"
#  }
#}

#data "terraform_remote_state" "network" {
#  backend = "s3"
#  config {
#    bucket = "rc-remote-state-bucket"
#    key    = "terraform.tfstate"
#    region = "us-east-1"
#    shared_credentials_file = "~/.aws/config"
#    profile                 = "profile2"
#  }
#}

variable "ecs_cluster" {
  default = "terraform-ecs-demo-1"
}
variable "capacity" {}

resource "aws_ecs_cluster" "test-ecs-cluster" {
    name = "${var.ecs_cluster}"
}
resource "aws_autoscaling_group" "ecs-autoscaling-group" {
    name                        = "ecs-asg-${var.ecs_cluster}"
    max_size                    = "5"
    min_size                    = "1"
    desired_capacity            = "${var.capacity}"
    vpc_zone_identifier         = ["subnet-09061ababe50e4c88","subnet-0de941c40009598ca"]
    launch_configuration        = "${aws_launch_configuration.ecs-launch-configuration.name}"
    health_check_type           = "ELB"
  }
  resource "aws_launch_configuration" "ecs-launch-configuration" {
    name                        = "ecs-lb-${var.ecs_cluster}"
    image_id                    = "ami-0b9a214f40c38d5eb"
    instance_type               = "t2.medium"
    iam_instance_profile        = "ecsInstanceRole"
    root_block_device {
      volume_type = "standard"
      volume_size = 20
      delete_on_termination = true
    }
    lifecycle {
      create_before_destroy = true
    }
    security_groups             = ["sg-0108a34f294c16425"]
    associate_public_ip_address = "true"
    key_name                    = "harness"
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
                                  EOF
}
output "clusterName" {
    value = "${var.ecs_cluster}"
}
output "region" {
    value = "${var.region}"
}
