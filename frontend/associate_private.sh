MY_PRIV_RTB="rtb-003a347b9a06f5026"
MY_VPC="vpc-07f17cd18abe97321"

SUB_APP1=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$MY_VPC" "Name=tag:Name,Values=Private-App-Subnet-1" --query "Subnets[0].SubnetId" --output text --region us-east-1)
aws ec2 associate-route-table --subnet-id $SUB_APP1 --route-table-id $MY_PRIV_RTB --region us-east-1

SUB_APP2=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$MY_VPC" "Name=tag:Name,Values=Private-App-Subnet-2" --query "Subnets[0].SubnetId" --output text --region us-east-1)
aws ec2 associate-route-table --subnet-id $SUB_APP2 --route-table-id $MY_PRIV_RTB --region us-east-1

SUB_DATA1=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$MY_VPC" "Name=tag:Name,Values=Private-Data-Subnet-1" --query "Subnets[0].SubnetId" --output text --region us-east-1)
aws ec2 associate-route-table --subnet-id $SUB_DATA1 --route-table-id $MY_PRIV_RTB --region us-east-1

SUB_DATA2=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$MY_VPC" "Name=tag:Name,Values=Private-Data-Subnet-2" --query "Subnets[0].SubnetId" --output text --region us-east-1)
aws ec2 associate-route-table --subnet-id $SUB_DATA2 --route-table-id $MY_PRIV_RTB --region us-east-1
