# create a iam role for the lambda function to access the dynamodb table
#resource "<resource_type>" "<resource_name>" { ... }
resource "aws_iam_role" "lambda_execution_role" {
  name = "file_lookup_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# use policy_attachment because this is a policy already created by AWS
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# use policy because this is a custom policy created new
resource "aws_iam_role_policy" "lambda_dynamodb_read" {
  name = "lambda_dynamodb_read_policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:Scan"
        ]
        Resource = aws_dynamodb_table.file_metadata.arn
      }
    ]
  })
}