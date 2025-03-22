resource "null_resource" "main" {
  triggers = {
    name = timestamp()
  }
  provisioner "local-exec" {
    command = "echo This is ${var.env} "
  }
}