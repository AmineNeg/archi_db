#!/usr/bin/env bash
# ============================================================================
# CABINET D'ARCHITECTURE — Script de backup automatique
# ============================================================================
set -euo pipefail

DB_HOST="${POSTGRES_HOST:-localhost}"
DB_PORT="${POSTGRES_PORT:-5432}"
DB_USER="${POSTGRES_USER:-archi}"
DB_NAME="${POSTGRES_DB:-archi_db}"
export PGPASSWORD="${POSTGRES_PASSWORD:-archi_secret_2024}"

BACKUP_DIR="$(dirname "$0")/../backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${TIMESTAMP}.sql.gz"

mkdir -p "$BACKUP_DIR"

echo "Backup de $DB_NAME..."
pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" "$DB_NAME" \
    --no-owner --no-privileges --clean --if-exists \
    | gzip > "$BACKUP_FILE"

echo "Backup cree: $BACKUP_FILE"
echo "Taille: $(du -h "$BACKUP_FILE" | cut -f1)"

# Nettoyage des backups de plus de 30 jours
find "$BACKUP_DIR" -name "*.sql.gz" -mtime +30 -delete 2>/dev/null || true
echo "Nettoyage des anciens backups effectue."
