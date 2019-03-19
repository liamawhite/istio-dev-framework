module "gke_cluster" {
  source = "./modules/gke"

  name            = "${var.cluster_prefix}-gke-${var.region}"
  k8s_version     = "${var.gke_k8s_version}"
  project         = "${var.project_id}"
  region            = "${var.region}"
}
