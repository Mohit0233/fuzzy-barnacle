```shell
terraform apply -auto-approve -var-file="terraform.tfvars"
terraform destroy -auto-approve -var-file="terraform.tfvars"
terraform output security_group_used   -var-file="terraform.tfvars"


aws ec2 describe-security-groups --group-ids sg-0dbxxxxx9 --query "SecurityGroups[*].VpcId" --region ap-south-1
```
