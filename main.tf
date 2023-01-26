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
  token = "dop_v1_cda458688f8db3f572104fa567697ea01ed9fae5d6602c4aa9d1791c493ea938"
}

# Create a new Web Droplet in the nyc1 region
resource "digitalocean_droplet" "ubuntu-jenkins" {
  image  = "ubuntu-22-04-x64"
  name   = "ubuntu-jenkins"
  region = "nyc1"
  size   = "s-2vcpu-2gb"
}
