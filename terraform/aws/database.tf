data "template_file" "install_db" {
  template = "${file("${path.module}/templates/install_db.ps1")}"
#       vars = {
#       peer_ip = "${aws_instance.loadbalancer.private_ip}"
#   }
}


resource "aws_instance" "database" {

  connection {
    type     = "winrm"
    user     = "administrator"
    password = "Cod3Can!"
  }

  ami                         = "${data.aws_ami.windows_workstation.id}"
  instance_type               = "t2.large"
  key_name                    = "${var.aws_key_pair_name}"
  subnet_id                   = "${aws_subnet.dotnetcore-subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.dotnetcore.id}"]
  associate_public_ip_address = true

  user_data = <<EOF
    <powershell>
    net user administrator Cod3Can! /y
    winrm quickconfig -q
    winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
    winrm set winrm/config '@{MaxTimeoutms="1800000"}'
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
    winrm set winrm/config/service/auth '@{Basic="true"}'
    netsh advfirewall firewall add rule name=”WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
    netsh advfirewall firewall add rule name=”WinRM 5986" protocol=TCP dir=in localport=5986 action=allow
    netsh advfirewall firewall add rule name=”RDP 3389" protocol=TCP dir=in localport=3389 action=allow
    netsh advfirewall firewall add rule name=”SQLServer 8888" protocol=TCP dir=in localport=8888 action=allow
    net stop winrm
    sc.exe config winrm start=auto
    net start winrm
    </powershell>
  EOF

    tags {
    Name          = "${var.tag_contact}-${var.tag_customer}-database"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }

  provisioner "remote-exec" {
    inline = [
      "md \\users\\administrator\\.chef",
    ]
  }
  provisioner "file" {
    destination = "C:/users/administrator/.chef/scripts/install_db.ps1"
    content     = "${data.template_file.install_db.rendered}"
  }
  provisioner "remote-exec" {
    inline = [
      "powershell -ExecutionPolicy Unrestricted -File C:\\users\\administrator\\.chef\\scripts\\install_db.ps1 -Schedule"
    ]
  }
}