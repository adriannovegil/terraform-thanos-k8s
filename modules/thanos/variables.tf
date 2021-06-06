#------------------------------------------------------------------------------
# Variables that need to be set
#------------------------------------------------------------------------------
variable "context_name" {
  description = "Context name"
  type        = string
  default = "monitoring"
}

variable "namespace" {
  description = "Namespace"
  type        = string
}
