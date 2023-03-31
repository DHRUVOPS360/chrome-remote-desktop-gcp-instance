resource "google_compute_instance" "chrome_desktop" {
  name         = "chrome-remote-desktop"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Optional. External IP address configuration.
    }
  }

  metadata_startup_script = "${file("startup-script.sh")}"
  tags = ["chrome-remote-desktop"]
}

resource "google_compute_firewall" "chrome_desktop" {
  name    = "chrome-desktop"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_resource_policy" "hourly" {
  name        = "gce-policy"
  region      = "us-central1"
  description = "Start and stop instances"

    instance_schedule_policy {
    vm_start_schedule {
      schedule = "0 0 * * 1-7" #1-mon,...,7-sun
    }
    vm_stop_schedule {
      schedule = "0 0 * * 1-7" 
    }

     time_zone = "US/Central"
    
  }
}
