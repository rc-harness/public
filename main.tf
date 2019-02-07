resource "aws_s3_bucket" "public" {
  acl = "private"
  versioning {
    enabled = true
  }

  tags {
    Name = "public"
  }

}
