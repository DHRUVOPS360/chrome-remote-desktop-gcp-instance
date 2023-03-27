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

  metadata_startup_script = <<EOF
#!/bin/bash
sudo DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    wget
echo "deb [arch=amd64] http://dl.google.com/linux/chrome-remote-desktop/deb/ stable main" | \
    sudo tee /etc/apt/sources.list.d/chrome-remote-desktop.list
curl -L https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    chrome-remote-desktop
sudo usermod -a -G chrome-remote-desktop <YOUR_USERNAME>
EOF

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
