#Nginx service 
resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  create_namespace = "true"
  version        = "4.7.0"
values = [
     "${file("./charts/nginx/values.yaml")}"
   ]
}


#Jenkins service 
resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  create_namespace = "true"
  version        = "4.3.24"
values = [
     "${file("./charts/jenkins/values.yaml")}"
   ]
}
