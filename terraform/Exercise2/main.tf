data "archive_file" "lambda-archive" {
  type = "zip"
  source_file = "lambda_function/lambda.py"
  output_path = "lambda_function/lambda.zip"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": "statement1"
      }
    ]
  }
  EOF
}

resource "aws_lambda_function" "greet_lambda" {
  filename = data.archive_file.lambda-archive.output_path
  function_name = "greet_lambda"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "lambda.lambda_handler"
  source_code_hash = data.archive_file.lambda-archive.output_base64sha256
  runtime = "python3.7"
  depends_on = [aws_iam_role_policy_attachment.lambda_logs]
  environment {
    variables = {
      greeting = "Hello World"
    }
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_vpc" "udacity" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "udacity"
  }
}

resource "aws_subnet" "udacity" {
  vpc_id = aws_vpc.udacity.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
}

resource "aws_sqs_queue" "udacity_queue" {
  name                      = "udacity-project-queue"
  max_message_size          = 2048
  message_retention_seconds = 60
}

resource "aws_lambda_event_source_mapping" "udacity-project" {
  event_source_arn = aws_sqs_queue.udacity_queue.arn
  function_name    = aws_lambda_function.greet_lambda.arn
}
