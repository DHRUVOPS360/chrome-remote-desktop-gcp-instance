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
    sudo apt update
    curl -L -o chrome-remote-desktop_current_amd64.deb \
        https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    sudo DEBIAN_FRONTEND=noninteractive \
        apt-get install --assume-yes ./chrome-remote-desktop_current_amd64.deb
    sudo DEBIAN_FRONTEND=noninteractive \
        apt install --assume-yes xfce4 desktop-base dbus-x11 xscreensaver
    sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'
    sudo systemctl disable lightdm.service
    sudo apt install --assume-yes task-xfce-desktop
    curl -L -o google-chrome-stable_current_amd64.deb \
        https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install --assume-yes ./google-chrome-stable_current_amd64.deb
  EOF

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
