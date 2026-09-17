MY_VPC="vpc-0c1b08061e28d14fb"
SG_APP="sg-0753aee9cf2d9bcfb"
AMI_ID=$(aws ec2 describe-images --owners amazon --filters "Name=name,Values=al2023-ami-2023*-kernel-6.1-x86_64" --query "Images[0].ImageId" --output text --region us-east-1)

# Holt automatisch die ID vom Private-App-Subnet-1
SUB_APP1=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$MY_VPC" "Name=tag:Name,Values=Private-App-Subnet-1" --query "Subnets.SubnetId" --output text --region us-east-1)

# Startet die Instanz mit der korrekten AMI-ID
aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type t2.micro --security-group-ids $SG_APP --subnet-id $SUB_APP1 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Frontend-Server}]' --region us-east-1
