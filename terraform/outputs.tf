#output the api gateway url for the file service api
output "api_gateway_url" {
  value = aws_apigatewayv2_api.file_service_api.api_endpoint
}