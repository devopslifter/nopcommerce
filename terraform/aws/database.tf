resource "aws_instance" "database" {
  ami                         = "${data.aws_ami.windows_workstation.id}"
  instance_type               = "t2.large"
  key_name                    = "${var.aws_key_pair_name}"
  subnet_id                   = "${aws_subnet.dotnetcore-subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.dotnetcore.id}"]
  associate_public_ip_address = true

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }

  tags {
    Name          = "${var.tag_contact}-${var.tag_customer}-database"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "remote-exec" {
    connection = {
      type     = "winrm"
      password = "RL9@T40BTmXh"
      agent    = "false"
      insecure = true
      https    = false
    }

    inline = [
      "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))",
      "New-NetFirewallRule -DisplayName \"Habitat TCP\" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 9631,9638",
      "New-NetFirewallRule -DisplayName \"Habitat UDP\" -Direction Inbound -Action Allow -Protocol UDP -LocalPort 9638",
      "choco install habitat -y",
      "hab sup run",
    ]
  }
}
