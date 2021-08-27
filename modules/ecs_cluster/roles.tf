resource "aws_iam_role" "ecs_cluster_role" {
  name               = "ecs-cluster-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal":{
          "Service": ["ecs.amazonaws.com", "ec2.amazonaws.com","application-autoscaling.amazonaws.com", "ecs-tasks.amazonaws.com"]
        },
        "Action": "sts:AssumeRole"
      }
    ]
}
EOF
}


resource "aws_iam_role_policy" "ecs_cluster_policy" {
  name   = "App-cluster-iam-policy"
  role   = aws_iam_role.ecs_cluster_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecs:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "ecr:*",
          "dynamodb:*",
          "cloudwatch:*",
          "s3:*",
          "sns:*",
          "sqs:*",
          "rds:*",
          "logs:*"
        ],
        "Resource":"*"
      }
    ]
  }
EOF
}

#task execution role and policy
resource "aws_iam_role" "fargate_iam_role" {
  name               = "${var.ecs_service_name}-IAM-Role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
      },
      "Action" : "sts:AssumeRole"
    }
  ]
}
EOF
}

#Task execution policy
resource "aws_iam_role_policy" "fargate_iam_role_policy" {
  name   = "${var.ecs_service_name}-IAM-Role-Policy"
  role   = aws_iam_role.fargate_iam_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*",
        "ecr:*",
        "logs:*",
        "cloudwatch:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
