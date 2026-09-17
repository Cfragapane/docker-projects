#!/bin/bash

# Dynamisch die Region und das aktuelle Datum für den Snapshot-Namen setzen
REGION="us-east-1"
BACKUP_NAME="calospro-db-backup-$(date +%Y-%m-%d-%H-%M)"

echo "🚀 Starte automatisiertes AWS RDS Datenbank-Backup..."

# 1. AWS RDS Snapshot-Befehl abfeuern
aws rds create-db-snapshot \
    --db-instance-identifier database-1 \
    --db-snapshot-identifier "$BACKUP_NAME" \
    --region "$REGION"

if [ $? -eq 0 ]; then
    echo "✅ Backup-Befehl erfolgreich an AWS gesendet!"
    echo "📋 Snapshot-Name: $BACKUP_NAME"
    echo "⏳ Der Snapshot wird nun im Hintergrund von AWS erstellt."
else
    echo "❌ Fehler: Das Backup konnte nicht gestartet werden."
fi
