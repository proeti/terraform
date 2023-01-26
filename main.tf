terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Retrieve existing ssh key
data "digitalocean_ssh_key" "DevOps" {
  name = var.ssh_key
}

# Create a new Web Droplet in the nyc1 region
resource "digitalocean_droplet" "ubuntu-jenkins" {
  image    = "ubuntu-22-04-x64"
  name     = "ubuntu-jenkins"
  region   = "nyc1"
  size     = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.DevOps.id]
}

# Kubernetes Cluster Provisioning
resource "digitalocean_kubernetes_cluster" "k8s-devops" {
  name    = "k8s-devops"
  region  = var.region
  version = "1.25.4-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

variable "region" {
  default = ""
}

variable "do_token" {
  default = ""
}

variable "ssh_key" {
  default = ""
}

output "jenkins_ip" {
  value = digitalocean_droplet.ubuntu-jenkins.ipv4_address
}

resource "local_file" "name" {
  content  = digitalocean_kubernetes_cluster.k8s-devops.kube_config.0.raw_config
  filename = "kube_config.yaml"
}