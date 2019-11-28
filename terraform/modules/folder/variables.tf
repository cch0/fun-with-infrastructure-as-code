variable "folder" {
  type = object({
    name    = string
    prefix  = string
    parent  = string
  })
}
