resource "aws_iam_role" "terra-role" {
        name = "terra-role"
        assume_role_policy =jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy" "terra-policy" {
        name = "terra-policy"
        role = aws_iam_role.terra-role.name
        policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
})
}

resource "aws_iam_instance_profile" "EC2-profile"{
        name = "terra-profile"
        role = aws_iam_role.terra-role.name
}
