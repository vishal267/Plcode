terraform {
  backend "s3" {
	bucket = "plcode-tf"
	key	= "prod/remote_bucket_s3"
	region = "ap-south-1"
  }
}

