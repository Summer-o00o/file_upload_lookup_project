#api gateway for both the file upload and file lookup services
resource "aws_apigatewayv2_api" "file_service_api" {
  name          = "file_service_api"
  protocol_type = "HTTP"
}

#integration for the file lookup service
resource "aws_apigatewayv2_integration" "file_lookup_integration" {

  api_id = aws_apigatewayv2_api.file_service_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.file_lookup.invoke_arn
  integration_method = "POST"
}

#route for the file lookup service
resource "aws_apigatewayv2_route" "get_files_route" {

  api_id = aws_apigatewayv2_api.file_service_api.id
  route_key = "GET /api/files"
  target = "integrations/${aws_apigatewayv2_integration.file_lookup_integration.id}"
}

// route for the upload url service
resource "aws_apigatewayv2_route" "post_upload_url_route" {
  api_id    = aws_apigatewayv2_api.file_service_api.id
  route_key = "POST /api/upload/url"
  target    = "integrations/${aws_apigatewayv2_integration.backend_alb_integration.id}"
}

// route for the metadata service
resource "aws_apigatewayv2_route" "post_metadata_route" {
  api_id    = aws_apigatewayv2_api.file_service_api.id
  route_key = "POST /api/metadata"
  target    = "integrations/${aws_apigatewayv2_integration.backend_alb_integration.id}"
}

#stage for the api gateway
resource "aws_apigatewayv2_stage" "default_stage" {

  api_id = aws_apigatewayv2_api.file_service_api.id
  name = "$default"
  auto_deploy = true
}

// integration for the backend ALB to forward the traffic to the backend server
resource "aws_apigatewayv2_integration" "backend_alb_integration" {
  api_id                 = aws_apigatewayv2_api.file_service_api.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = aws_lb_listener.http_listener.arn
  payload_format_version = "1.0"
}