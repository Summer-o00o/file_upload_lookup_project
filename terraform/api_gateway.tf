#api gateway for both the file upload and file lookup services
resource "aws_apigatewayv2_api" "file_service_api" {
  name          = "file_service_api"
  protocol_type = "HTTP"

// cors configuration for the api gateway
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "OPTIONS"]
    allow_headers = ["*"]
  }
}

#integration for the file lookup service
resource "aws_apigatewayv2_integration" "file_lookup_integration" {

  api_id             = aws_apigatewayv2_api.file_service_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.file_lookup.invoke_arn
  integration_method = "POST"
}

#route for the file lookup service
# has to keep this because if not,  the request will be forwarded to the ALB, EC2 instead of the lambda
resource "aws_apigatewayv2_route" "get_files_route" {

  api_id = aws_apigatewayv2_api.file_service_api.id
  route_key = "GET /api/files"
  target = "integrations/${aws_apigatewayv2_integration.file_lookup_integration.id}"
}

# route for the backend proxy to forward the traffic to the backend server
resource "aws_apigatewayv2_route" "backend_proxy_route" {
  api_id    = aws_apigatewayv2_api.file_service_api.id
  route_key = "ANY /api/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.backend_alb_integration.id}"
}

#stage for the api gateway
resource "aws_apigatewayv2_stage" "default_stage" {

  api_id      = aws_apigatewayv2_api.file_service_api.id
  name        = "$default"
  auto_deploy = true
}

// integration for the backend ALB to forward the traffic to the backend server
resource "aws_apigatewayv2_integration" "backend_alb_integration" {
  api_id                 = aws_apigatewayv2_api.file_service_api.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = aws_lb_listener.http_listener.arn
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.backend_vpc_link.id
  payload_format_version = "1.0"
}
