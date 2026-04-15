resource "minikube_cluster" "kube_cluster" {
  driver       = "podman"
  cluster_name = "kube-cluster"
  nodes       = 3
}