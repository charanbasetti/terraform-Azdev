# Please use terraform v12.29 to start with for all labs, I will use terraform v13 and v14 from lab 7.5 onwards
variable "env" {
  type    = string
  default = "test"
}
variable "location-name" {
  type    = string
  default = "centralus"
}
variable "admin_username" {
  type      = string
  sensitive = true
}
