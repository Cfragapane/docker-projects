#!/bin/bash

# Lädt die Variablen aus der .env-Datei im selben Ordner
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | xargs)
fi

SG_LB="$AWS_SG_LB"
SG_APP="$AWS_SG_APP"
SG_DB="$AWS_SG_DB"



# CALOSPRO-22: Load Balancer Regel (Port 80 von überall)
aws ec2 authorize-security-group-ingress --group-id $SG_LB --protocol tcp --port 80 --cidr 0.0.0.0/0 --region us-east-1

# CALOSPRO-23: Application/Container Regel (Port 80 NUR von LB-SG)
aws ec2 authorize-security-group-ingress --group-id $SG_APP --protocol tcp --port 80 --source-group $SG_LB --region us-east-1

# CALOSPRO-24: Database Regel (Port 3306 NUR von App-SG)
aws ec2 authorize-security-group-ingress --group-id $SG_DB --protocol tcp --port 3306 --source-group $SG_APP --region us-east-1
