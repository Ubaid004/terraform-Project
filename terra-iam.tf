resource "aws_iam_role" "terra"  {
        name= "terra"
        assume_role_policy= <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}

EOF
}


resource "aws_iam_role_s3" "terra"{
        name= "terra"
        role= aws_iam_role.terra.name
}

resource "aws_iam_policy_Attached" "role-plicy-attached"{
        for_each = toset([
        "arn:aws:iam::600595126159:instance-profile/terrafrom",
        "arn:aws:iam::600595126159:role/terrafrom"
])
        role= aws_iam_role.terra.name
        policy_arn= each.value
}
