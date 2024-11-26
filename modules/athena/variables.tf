variable "catalog_name" {
  description = "Catalog Name"
  type        = string
}
variable "catalog_description" {
  description = "Catalog Description"
  type        = string
}
variable "catalog_type" {
  description = "Catalog type"
  type        = string
}
variable "catalog_paramaters" {
  description = "Catalog Parameters"
  type        = object({})
}
