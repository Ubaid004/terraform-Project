terraform {

  backend "s3" {
    bucket = "my-s3bucket-20230319143421120500000001"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table= "terra-dynamodb"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
     {
    "Effect": "Allow",
    "Action": "s3:ListBucket",
    "Resource": "arn:aws:s3:::my-s3bucket-20230319143421120500000001"
    },

    {
    "Effect": "Allow",
    "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
    "Resource": "arn:aws:s3:::my-s3bucket-20230319143421120500000001/terraform.tfstate"
    }
  ]
}
EOF
}
}
