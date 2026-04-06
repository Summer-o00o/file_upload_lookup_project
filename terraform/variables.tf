variable "sns_subscription_email" {
  description = "Email address that receives SNS file upload notifications."
  type        = string
  sensitive   = true
}
