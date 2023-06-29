#postgresql statefulset 
resource "helm_release" "postgresql" {
  name       = "postgresql"
  namespace  = "app"
  repository = "oci://registry-1.docker.io/bitnamicharts/postgresql"
  chart      = "postgresql"
  create_namespace = "true"
  version        =  "15.3.0"
values = [
     "${file("./charts/postgresql/values.yaml")}"
   ]
}


#app service (python)
resource "helm_release" "app" {
  name       = "app"
  namespace  = "app"
  repository = ""
  chart      = "./charts/app"
  create_namespace = "true"
  version        = "0.1.0"
values = [
     "${file("./charts/app/values.yaml")}"
   ]
}