output "this" {
  value = {
    module = module.this
  }
}

output "debug" {
  value = [var.name, var.hostname]
}
