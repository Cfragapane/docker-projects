# 1. Offizielles Python-Image als Basis wählen
FROM python:3.11-slim

# 2. Arbeitsverzeichnis im Container festlegen
WORKDIR /app

# 3. System-Abhängigkeiten installieren, die für PostgreSQL gebraucht werden
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# 4. requirements.txt kopieren und Pakete installieren
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Den restlichen Code des Backends in den Container kopieren
COPY . .

# 6. Den Port freigeben, auf dem Uvicorn läuft
EXPOSE 8000

# 7. Startbefehl für die Anwendung festlegen
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
