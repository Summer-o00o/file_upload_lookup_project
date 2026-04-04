# file lookup lambda function
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

# allow the api gateway to invoke the file lookup lambda function
resource "aws_lambda_permission" "allow_apigateway_invoke" {

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_lookup.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.file_service_api.execution_arn}/*/*"
}


# stream notification lambda function
resource "aws_lambda_function" "stream_notification" {
  function_name = "stream_notification_lambda"

  runtime = "python3.11"
  handler = "handler.lambda_handler"

  role = aws_iam_role.lambda_execution_role.arn

  filename         = "${path.module}/../lambdas/stream-notification/function.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/stream-notification/function.zip")

// pass the sns topic arn to the lambda function
  environment {
    variables = {
      TOPIC_ARN = aws_sns_topic.file_upload_notifications.arn
    } 
  }
}

# map the stream notification lambda function to the dynamodb table
resource "aws_lambda_event_source_mapping" "stream_notification_mapping" {
  event_source_arn  = aws_dynamodb_table.file_metadata.stream_arn
  function_name     = aws_lambda_function.stream_notification.arn
  starting_position = "LATEST"
}