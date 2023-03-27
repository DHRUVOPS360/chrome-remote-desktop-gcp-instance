resource "google_compute_instance" "chrome_desktop" {
  name         = "chrome-desktop"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata_startup_script = <<-EOF
    # Install Chrome Remote Desktop
    wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    sudo dpkg --install chrome-remote-desktop_current_amd64.deb
    sudo apt --fix-broken install -y

    # Install desktop environment and xrdp
    sudo apt-get install xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils -y
    sudo apt-get install xrdp -y

    # Configure Chrome Remote Desktop
    sudo groupadd chrome-remote-desktop
    sudo usermod -a -G chrome-remote-desktop ${USER}
    sudo apt-get install --assume-yes chrome-remote-desktop
    echo "xfce4-session" > ~/.chrome-remote-desktop-session
    sudo systemctl disable lightdm.service
    echo "exec /usr/bin/startxfce4" > ~/.xsession
    sudo systemctl enable xrdp.service
    sudo systemctl enable chrome-remote-desktop.service
    sudo adduser ${USER} chrome-remote-desktop
  EOF

  tags = ["chrome-desktop"]
}

resource "google_compute_firewall" "chrome_desktop" {
  name        = "chrome-desktop"
  network     = "default"
  allow {
    protocol = "tcp"
    ports    = ["22",3389"]
  }
  source_ranges =["0.0.0.0/0"]
  target_tags   = [google_compute_instance.chrome_desktop.tags[0]]
}
