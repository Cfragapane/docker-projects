#!/bin/bash

# Lädt die Variablen aus der .env-Datei im selben Ordner
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | xargs)
fi

REGION="$AWS_REGION"
BACKUP_NAME="calospro-db-backup-$(date +%Y-%m-%d-%H-%M)"

echo "🚀 Starte automatisiertes AWS RDS Datenbank-Backup..."

# 1. AWS RDS Snapshot-Befehl abfeuern
aws rds create-db-snapshot \
       --db-instance-identifier "$AWS_DB_INSTANCE" \
    --db-snapshot-identifier "$BACKUP_NAME" \
    --region "$REGION"

if [ $? -eq 0 ]; then
    echo "✅ Backup-Befehl erfolgreich an AWS gesendet!"
    echo "📋 Snapshot-Name: $BACKUP_NAME"
    echo "⏳ Der Snapshot wird nun im Hintergrund von AWS erstellt."
else
    echo "❌ Fehler: Das Backup konnte nicht gestartet werden."
fi
