variable "lambda_function_name" {
  default = "basic"
  type    = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "env_tier" {
  type    = string
  default = "dev"
}

variable "workload" {
  type    = string
  default = "platform"
}
