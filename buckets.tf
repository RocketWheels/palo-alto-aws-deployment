
# Define a resource block for an Amazon Simple Storage Service (S3) bucket.
resource "aws_s3_bucket" "bootstrap_bucket" {
  bucket_prefix = "palo-alto-bootstrap-"

  tags = {
    Name = "Palo Alto Bootstrap Bucket" # Setting the 'Name' tag for easy identification of the bucket's purpose.
  }
}

resource "aws_s3_bucket_versioning" "bootstrap_bucket_versioning" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

locals {
  folders_to_upload = [
    "content/",
    "license/",
    "plugins/",
    "software/",
  ]
}

resource "aws_s3_bucket_object" "bootstrap_file" {
  for_each = toset(local.folders_to_upload)

  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = each.value
  content = ""
  # etag   = filemd5(each.value)
}

resource "aws_s3_bucket_object" "bootstrap_config" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = "config/init-cfg.txt"
  source = "${path.root}/palo_bootstrap/config/init-cfg.txt"
  etag   = filemd5("${path.root}/palo_bootstrap/config/init-cfg.txt")
}