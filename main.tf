resource "google_compute_instance" "chrome_desktop" {
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
    # Install Chrome Remote Desktop
    wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    sudo apt-get install --assume-yes ./chrome-remote-desktop_current_amd64.deb


    # Configure Gnome System desktop environment
    sudo DEBIAN_FRONTEND=noninteractive \
    apt install --assume-yes  task-gnome-desktop
    sudo bash -c ‘echo “exec /etc/X11/Xsession /usr/bin/gnome-session” > /etc/chrome-remote-desktop-session’
    sudo systemctl disable gdm3.service
    sudo reboot
    curl -L -o google-chrome-stable_current_amd64.deb \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install --assume-yes ./google-chrome-stable_current_amd64.deb
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
