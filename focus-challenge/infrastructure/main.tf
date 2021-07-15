/*Creating the cluster for Kubernetes*/
resource "digitalocean_kubernetes_cluster" "focusch" {
  name   = "${var.project_name}-cluster"
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.21.2-do.2"

  node_pool {
    name       = "${var.project_name}-pool"
    size       = "s-1vcpu-2gb"
    node_count = 2
  }
}

/*Config kubctl*/
resource "local_file" "kubernetes_config" {
  content = "${digitalocean_kubernetes_cluster.focusch.kube_config.0.raw_config}"
  filename = "kubeconfig.yaml"
}
provider "kubernetes" {
  host             = data.digitalocean_kubernetes_cluster.focusch.endpoint
  token            = data.digitalocean_kubernetes_cluster.focusch.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.focusch.kube_config[0].cluster_ca_certificate
  )
}