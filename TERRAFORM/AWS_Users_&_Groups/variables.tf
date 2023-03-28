variable "region" {
  description = "aws region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "users" {
  description = "aws iam users list"
  type        = list(string)
  default     = ["Staline", "Achu", "Francoise", "Maxime", "Ozoya", "Sylvain", "Castro", "Chris", "Ronald", "Aurelien", "Rabania"]
}