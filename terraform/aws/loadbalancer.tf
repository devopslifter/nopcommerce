 resource "aws_instance" "loadbalancer" {
    connection {
    user        = "${var.aws_centos_image_user}"
    private_key = "${file("${var.aws_key_pair_file}")}"
    }

  ami                         = "${data.aws_ami.centos.id}"
  instance_type               = "t2.micro"
  key_name                    = "${var.aws_key_pair_name}"
  subnet_id                   = "${aws_subnet.dotnetcore-subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.dotnetcore.id}"]
  associate_public_ip_address = true
  
  tags {
    Name          = "${var.tag_contact}-${var.tag_customer}-loadbalancer"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash",
      "sudo useradd hab -y",
      "sudo hab sup run"
    ]
  }
}
