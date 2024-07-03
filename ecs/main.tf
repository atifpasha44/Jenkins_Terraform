resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "Cluster_Jenkins" {
  name = "Cluster_Jenkins"
}

resource "aws_ecs_task_definition" "Cluster_Jenkins" {
  family                   = "Cluster_Jenkins"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  memory                   = "512"
  cpu                      = "256"

  container_definitions = jsonencode([{
    name  = "Cluster_Jenkins"
    image = "nginx"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

resource "aws_ecs_service" "Cluster_Jenkins" {
  name            = "Cluster_Jenkins"
  cluster         = aws_ecs_cluster.Cluster_Jenkins.id
  task_definition = aws_ecs_task_definition.Cluster_Jenkins.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = [aws_subnet.subnet.id]
    assign_public_ip = true
  }
}
