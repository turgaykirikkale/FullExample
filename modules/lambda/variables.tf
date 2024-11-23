variable "function_name" {
  description = "Function name"
  type        = string
}

variable "handler" {
  description = "Handler ?"
  type        = string
  default     = "lambda_function.lambda_handler"

}

variable "runtime_version" {
  description = "Run time version of language"
  type        = string
}

variable "lambda_role_arn" {
  description = "Lambda role ARN"
  type        = string
}



