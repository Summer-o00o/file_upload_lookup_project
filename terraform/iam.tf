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

// create a iam role for the ec2 instance
resource "aws_iam_role" "ec2_backend_role" {
  name = "file_upload_backend_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

// create a policy for the ec2 instance to access the s3 bucket and dynamodb table
resource "aws_iam_role_policy" "ec2_backend_policy" {
  name = "ec2_backend_policy"
  role = aws_iam_role.ec2_backend_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.file_upload_bucket.arn,
          "${aws_s3_bucket.file_upload_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem"
        ]
        Resource = aws_dynamodb_table.file_metadata.arn
      }
    ]
  })
}

// create a instance profile for the ec2 instance
// the instance profile is used to attach the iam role to the ec2 instance
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "file_upload_backend_instance_profile"
  role = aws_iam_role.ec2_backend_role.name
}

# create a policy for the lambda function to read the stream from the dynamodb table
resource "aws_iam_role_policy" "lambda_dynamodb_stream_read" {
  name = "lambda_dynamodb_stream_read_policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:DescribeStream",
          "dynamodb:ListStreams"
        ]
        Resource = aws_dynamodb_table.file_metadata.stream_arn
      }
    ]
  })
}

// create a policy for the lambda function to publish to the sns topic
// this is used to send email notifications when a new file is uploaded
resource "aws_iam_role_policy" "lambda_sns_publish" {
  name = "lambda_sns_publish_policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.file_upload_notifications.arn
      }
    ]
  })
}