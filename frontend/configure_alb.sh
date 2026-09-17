# 1. Die VPC-ID und die neue Load-Balancer Security Group automatisch abfragen
MY_VPC=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=calospro-vpc" --query "Vpcs[0].VpcId" --output text)
LB_SG=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$MY_VPC" "Name=group-name,Values=LB-SG" --query "SecurityGroups[0].GroupId" --output text)

# 2. Die IDs der beiden öffentlichen Subnetze für den ALB abfragen
SUB_PUB1=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$MY_VPC" "Name=tag:Name,Values=Public-Subnet-1" --query "Subnets[0].SubnetId" --output text)
SUB_PUB2=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$MY_VPC" "Name=tag:Name,Values=Public-Subnet-2" --query "Subnets[0].SubnetId" --output text)

# 3. Eine neue Target Group (Zielgruppe) für die Anwendung erstellen
echo "Erstelle Target Group..."
MY_TG_ARN=$(aws elbv2 create-target-group --name calospro-tg --protocol HTTP --port 8000 --vpc-id $MY_VPC --target-type instance --query "TargetGroups[0].TargetGroupArn" --output text --region us-east-1)
echo "Target Group ARN: $MY_TG_ARN"

# 4. Den Application Load Balancer erstellen
echo "Erstelle Application Load Balancer..."
aws elbv2 create-load-balancer --name calospro-alb --subnets $SUB_PUB1 $SUB_PUB2 --security-groups $LB_SG --type application --region us-east-1
