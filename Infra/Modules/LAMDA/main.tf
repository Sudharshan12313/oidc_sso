# resource "aws_security_group" "lamda_sg" {
#   name        = "eks-cluster-sg"
#   description = "EKS cluster security group"
#   vpc_id      = var.vpc_id

#   egress {
#     from_port   = 0          # Allow all ports for egress traffic
#     to_port     = 0          # Allow all ports for egress traffic
#     protocol    = "-1"       # All protocols
#     cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to anywhere
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic from anywhere
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS traffic from anywhere
#   }
  
#   ingress {
#     from_port   = 3000
#     to_port     = 3000
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS traffic from anywhere
#   }

#   ingress {
#     from_port   = 3001
#     to_port     = 3001
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS traffic from anywhere
#   }

#   tags = {
#     Name = "eks-lamda-sg"
#   }
# }

# Lambda Function
resource "aws_lambda_function" "my_lambda" {
  function_name = "hello-world-function"
  role          = var.lambda_role_arn
  image_uri     = var.image_name
  package_type  = "Image"
  # depends_on    = [var.attach_basic_execution]
  environment {
    variables = {
      NODE_ENV = "production"
    }
  }
}

# resource "aws_lambda_function_url" "function_url" {
#   function_name      = aws_lambda_function.my_lambda.function_name
#   authorization_type = "NONE"  # or "AWS_IAM" for authenticated access
# }

# Create API Gateway
resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "lambda-container-api"
  protocol_type = "HTTP"
  
  cors_configuration {
    allow_origins = ["*"]  # Restrict to your domain in production
    allow_methods = ["GET", "POST", "PUT", "DELETE"]
    allow_headers = ["Content-Type", "Authorization"]
    max_age       = 300
  }
}

# Create API stage
resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id = aws_apigatewayv2_api.lambda_api.id
  name   = "prod"
  auto_deploy = true
}

# Create API integration with Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.lambda_api.id

  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.my_lambda.invoke_arn
}

# Create API route
resource "aws_apigatewayv2_route" "lambda_route" {
  api_id = aws_apigatewayv2_api.lambda_api.id
  route_key = "ANY /{proxy+}"  # Catches all paths
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
# Allow API Gateway to invoke Lambda
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}
