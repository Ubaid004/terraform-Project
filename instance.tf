resource "aws_instance" "instance" {

        ami = "ami-05afd67c4a44cc983"
        instance_type = "t2.micro"
        vpc_security_group_ids =[aws_security_group.terra-SG.id]
        iam_instance_profile=aws_iam_instance_profile.EC2-profile.name
        user_data= <<EOF

        #!/bin/bash
        sudo sh
        sudo apt-get update -y
        sudo apt-get install nginx -y

        aws s3 cp s3://${aws_s3_bucket.my-s3-bucket.id}/index.html  /var/www/html/index.html

        sudo systemctl start nginx
        sudo systemctl enable nginx
EOF
        tags = {
              Name = "Terraweb"
}
}
