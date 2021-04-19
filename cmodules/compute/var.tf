variable "location" {
  type    = string
  default = "centralus"
}
variable "admin_user" {
  type    = string
  default = "cherri"
}
variable "admin_pass" {
  type=string
  default="Password1234!"
}
variable "rg"{
    type = string
    default = "resource_group_name"
}
variable vm-name {
    type=string
    default= "vm-name"
}
variable subnet_id {
    type=string
    default="subnet_id"
}