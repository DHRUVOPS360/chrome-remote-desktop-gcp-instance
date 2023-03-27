/*resource "google_compute_instance" "chrome_desktop" {
  name         = "ubuntu-desktop"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Optional. External IP address configuration.
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    # Install desktop environment
    sudo apt-get update
    sudo apt-get install -y ubuntu-desktop

    # Install Chrome Remote Desktop
    wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    sudo apt install -y ./chrome-remote-desktop_current_amd64.deb
    sudo apt install -y --fix-broken

    # Configure Chrome Remote Desktop
    echo "exec /usr/sbin/lightdm-session \"gnome-session --session=ubuntu\"" > ~/.chrome-remote-desktop-session
    sudo groupadd chrome-remote-desktop
    sudo usermod -a -G chrome-remote-desktop $USER
  EOF

  tags = ["chrome-desktop"]
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
*/
