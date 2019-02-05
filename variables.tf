variable "region" {}
variable "capacity" {
  default = "6"
  }
variable "users" {
    type    = "list"
    default = ["root", "user1", "user2"]
}
