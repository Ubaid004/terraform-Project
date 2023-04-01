data "aws_instances" "terra" {
        filter {
                name   = "tag:Name"
                values = ["Terraweb"]
        }
}

output "data_aws_instance_id" {
  value       = concat(data.aws_instances.terra.*.id, [""])[0]
  description = "data_aws_instance_id"
}
