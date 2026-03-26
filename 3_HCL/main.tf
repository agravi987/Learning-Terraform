
resource "aws_s3_bucket" "my_bucket" {
  bucket = "rithu-bucket-1234567890"
}

resource "aws_s3_object" "my_file" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "sample.txt"
  source = "sample.txt"
}

resource "local_file" "my_file" {
  filename = "sample.txt"
  content  = "This is a sample file created using Terraform"
}
