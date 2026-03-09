resource "aws_lambda_function" "file_lookup" {

  function_name = "file_lookup_lambda"

  runtime = "python3.11"
  handler = "handler.lambda_handler"

  role = aws_iam_role.lambda_execution_role.arn

  filename         = "${path.module}/../lambdas/file-lookup/function.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/file-lookup/function.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.file_metadata.name
    }
  }
}

resource "aws_lambda_permission" "allow_apigateway_invoke" {

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_lookup.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.file_service_api.execution_arn}/*/*"
}