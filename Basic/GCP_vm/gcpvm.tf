resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "asia-south1-c"

   boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
  }

}