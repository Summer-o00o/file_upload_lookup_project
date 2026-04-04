resource "aws_s3_bucket" "file_upload_bucket" {

  bucket = "file-upload-lookup-bucket"

  tags = {
    Project = "file-upload-lookup"
  }
}

resource "aws_s3_bucket_cors_configuration" "file_upload_bucket_cors" {
  bucket = aws_s3_bucket.file_upload_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET", "HEAD"]
    allowed_origins = ["http://localhost:5173"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}