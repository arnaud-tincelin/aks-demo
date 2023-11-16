resource "terraform_data" "weatherforecast_deployment" {
  provisioner "local-exec" {
    command = "KUBECONFIG=${local_file.kubeconfig.filename} kubectl apply -f ${path.module}/../weatherforecast/manifest.yaml"
  }
}
