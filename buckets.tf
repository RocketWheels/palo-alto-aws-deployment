
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

# resource "aws_s3_bucket_object" "bootstrap_file" {
#   for_each = toset(local.folders_to_upload)

#   bucket = aws_s3_bucket.bootstrap_bucket.id
#   key    = each.value
#   content = ""
#   # etag   = filemd5(each.value)
# }

resource "aws_s3_bucket_object" "bootstrap_folder" {
  for_each = toset(local.folders_to_upload)
  bucket   = aws_s3_bucket.bootstrap_bucket.id
  key      = each.value
  content  = ""
}

# The for_each argument is modified to use toset(flatten([...])) to create a flat list of file paths.
# Inside the for_each block, a nested for loop is used to iterate over each folder in local.folders_to_upload.
# The fileset function is used to retrieve the list of files within each folder.
# The resulting file paths are in the format "${folder}${file}", representing the relative path to each file.
# The key argument is set to the file path (each.value).
# The source and etag arguments are updated to use the file path ("${path.module}/palo_bootstrap/${each.value}").

resource "aws_s3_bucket_object" "bootstrap_file" {
  for_each = toset(flatten([
    for folder in local.folders_to_upload : [
      for file in fileset("${path.module}/palo_bootstrap/${folder}", "*") : "${folder}${file}"
    ]
  ]))
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = each.value
  source = "${path.module}/palo_bootstrap/${each.value}"
  etag   = filemd5("${path.module}/palo_bootstrap/${each.value}")

  depends_on = [aws_s3_bucket_object.bootstrap_folder]
}

#Creates the init-cfg.txt file as this is the only file required to bootstrap
resource "aws_s3_bucket_object" "bootstrap_config" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = "config/init-cfg.txt"
  source = "${path.root}/palo_bootstrap/config/init-cfg.txt"
  etag   = filemd5("${path.root}/palo_bootstrap/config/init-cfg.txt")
}