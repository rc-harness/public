module "child" {
  source = "./child"
}

  resource "aws_ecs_cluster" "test-ecs-cluster" {
    name = "${var.ecs_cluster}"
}
