variable "content" {}
variable "output_dir" {}

# resource "local_file" "file" {
  
#   content  = var.content
#   filename = "${path.module}/hi.txt"
# }
resource "local_file" "file" {
  content  = var.content
  filename = "${var.output_dir}/hi.txt"
}