resource "google_compute_instance" "chrome_desktop" {
  name         = "chrome-desktop"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y xfce4 desktop-base xscreensaver
    sudo apt-get install -y chrome-remote-desktop
    sudo apt-get install -y task-xfce-desktop
    echo "xfce4-session" > ~/.chrome-remote-desktop-session
    sudo usermod -a -G chrome-remote-desktop ${USER}
    sudo adduser ${USER} chrome-remote-desktop
    sudo systemctl disable lightdm.service
    sudo systemctl enable chrome-remote-desktop.service
    sudo systemctl start chrome-remote-desktop.service
  EOF
}

  tags = ["chrome-desktop"]
}

resource "google_compute_firewall" "chrome_desktop" {
  name        = "chrome-desktop"
  network     = "default"
  allow {
    protocol = "tcp"
    ports    = ["22","3389"]
  }
  source_ranges =["0.0.0.0/0"]
  target_tags   = [google_compute_instance.chrome_desktop.tags[0]]
}
