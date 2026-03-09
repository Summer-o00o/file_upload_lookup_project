# create a dynamodb table for the file metadata
resource "aws_dynamodb_table" "file_metadata" {

  name         = "file_metadata"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "fileId"

  attribute {
    name = "fileId"
    type = "S"
  }

  tags = {
    Project = "file-upload-lookup"
  }
}