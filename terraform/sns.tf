# create a sns topic for the file upload notifications
resource "aws_sns_topic" "file_upload_notifications" {
  name = "file-upload-notifications"
}


# subscribe to the sns topic to send email notifications
resource "aws_sns_topic_subscription" "email_notifications" {
  topic_arn = aws_sns_topic.file_upload_notifications.arn
  protocol  = "email"
  endpoint  = "<your-email>"
}