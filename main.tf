terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "dop_v1_aaf828b840573a2f22890be45eb1f9bf4d483989750d8db218e340ef664f2502"
}

# Retrieve existing ssh key
data "digitalocean_ssh_key" "DevOps" {
  name = "DevOps"
}

# Create a new Web Droplet in the nyc1 region
resource "digitalocean_droplet" "ubuntu-jenkins" {
  image  = "ubuntu-22-04-x64"
  name   = "ubuntu-jenkins"
  region = "nyc1"
  size   = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.DevOps.id]
}

# Kubernetes Cluster Provisioning
resource "digitalocean_kubernetes_cluster" "k8s-devops" {
  name   = "k8s-devops"
  region = "nyc1"
  version = "1.25.4-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}