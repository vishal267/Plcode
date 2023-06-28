#Nginx service 
resource "helm_release" "nginx" {
  name       = "nginx"
  namespace  = "services"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  create_namespace = "true"
  version        = "13.2.24"
values = [
     "${file("~/dataloop-k8s/terraform/modules/k8s-manifests/charts/nginx/values.yaml")}"
   ]
}
