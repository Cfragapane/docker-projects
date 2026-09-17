MY_VPC=$(aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text)

# 1. Load Balancer Security Group
aws ec2 create-security-group --group-name LB-SG --description "Security Group for Load Balancer" --vpc-id $MY_VPC --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=LB-SG}]' --region us-east-1

# 2. Application/Container Security Group
aws ec2 create-security-group --group-name App-SG --description "Security Group for Container Applications" --vpc-id $MY_VPC --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=App-SG}]' --region us-east-1

# 3. Database Security Group
aws ec2 create-security-group --group-name DB-SG --description "Security Group for Database" --vpc-id $MY_VPC --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=DB-SG}]' --region us-east-1
