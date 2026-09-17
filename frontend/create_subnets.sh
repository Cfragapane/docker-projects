MY_VPC=$(aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text)
aws ec2 create-subnet --vpc-id $MY_VPC --cidr-block 10.0.1.0/24 --availability-zone us-east-1a --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Public-Subnet-1}]' --region us-east-1
aws ec2 create-subnet --vpc-id $MY_VPC --cidr-block 10.0.2.0/24 --availability-zone us-east-1b --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Public-Subnet-2}]' --region us-east-1
aws ec2 create-subnet --vpc-id $MY_VPC --cidr-block 10.0.3.0/24 --availability-zone us-east-1a --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Private-App-Subnet-1}]' --region us-east-1
aws ec2 create-subnet --vpc-id $MY_VPC --cidr-block 10.0.4.0/24 --availability-zone us-east-1b --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Private-App-Subnet-2}]' --region us-east-1
aws ec2 create-subnet --vpc-id $MY_VPC --cidr-block 10.0.5.0/24 --availability-zone us-east-1a --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Private-Data-Subnet-1}]' --region us-east-1
aws ec2 create-subnet --vpc-id $MY_VPC --cidr-block 10.0.6.0/24 --availability-zone us-east-1b --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Private-Data-Subnet-2}]' --region us-east-1
