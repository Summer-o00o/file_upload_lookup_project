resource "aws_s3_bucket" "file_upload_bucket" {

  bucket = "file-upload-lookup-bucket"

  tags = {
    Project = "file-upload-lookup"
  }
}