provider "aws" {
  region = "eu-west-2"
}

resource "aws_ecs_cluster" "this" {
  name = "doorfeed-${var.env}-cluster"
}

resource "aws_ecr_repository" "this" {
  name = "doorfeed-web"
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole-${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "doorfeed-${var.env}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  container_definitions    = jsonencode([{
    name      = "doorfeed"
    image     = "${aws_ecr_repository.this.repository_url}:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
}

resource "aws_ecs_service" "app" {
  name            = "doorfeed-${var.env}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = ["subnet-xxxxxxxx"]
    security_groups = ["sg-xxxxxxxx"]
    assign_public_ip = true
  }
}
