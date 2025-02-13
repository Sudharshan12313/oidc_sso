# infra/modules/cognito/cognito.tf
resource "aws_cognito_user_pool" "oidc" {
  name = "oidc-user-pool"

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
}

/*resource "aws_cognito_user_pool_domain" "oidc_domain" {
  domain       = "testlambdasso" # Replace with your unique domain
  user_pool_id = aws_cognito_user_pool.oidc.id
}*/



resource "aws_cognito_user_pool_client" "oidc_client" {
  name         = "oidc-client"
  user_pool_id = aws_cognito_user_pool.oidc.id

  allowed_oauth_flows                 = ["code", "implicit"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["openid", "email"]

  supported_identity_providers = ["COGNITO"]  # Must be set

  callback_urls = ["http://localhost:3000/callback"]
  logout_urls   = ["https://localhost.com/logout"]

  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
     "ALLOW_USER_PASSWORD_AUTH"
  ]
}


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

resource "aws_apigatewayv2_authorizer" "oidc_auth" {
  api_id          = aws_apigatewayv2_api.lambda_api.id
  authorizer_type = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = "https://cognito-idp.us-west-2.amazonaws.com/${aws_cognito_user_pool.oidc.id}"
    audience = [aws_cognito_user_pool_client.oidc_client.id]
  }

  name = "oidc-authorizer"
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
  authorizer_id = aws_apigatewayv2_authorizer.oidc_auth.id
}


# Allow API Gateway to invoke Lambda
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}
