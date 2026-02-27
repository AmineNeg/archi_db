#!/usr/bin/env bash
# ============================================================================
# CABINET D'ARCHITECTURE — Script d'initialisation de la base de donnees
# ============================================================================
set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
DB_HOST="${POSTGRES_HOST:-localhost}"
DB_PORT="${POSTGRES_PORT:-5432}"
DB_USER="${POSTGRES_USER:-archi}"
DB_NAME="${POSTGRES_DB:-archi_db}"
export PGPASSWORD="${POSTGRES_PASSWORD:-archi_secret_2024}"

SQL_DIR="$(dirname "$0")/../sql"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Cabinet d'Architecture — Init DB${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Attendre que PostgreSQL soit pret
echo -e "${YELLOW}[1/8] Attente de PostgreSQL...${NC}"
for i in $(seq 1 30); do
    if pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -q 2>/dev/null; then
        echo -e "${GREEN}  PostgreSQL est pret.${NC}"
        break
    fi
    if [ "$i" -eq 30 ]; then
        echo -e "${RED}  Timeout: PostgreSQL non disponible.${NC}"
        exit 1
    fi
    sleep 1
done

PSQL="psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -v ON_ERROR_STOP=1"

# Execution des scripts SQL dans l'ordre
echo -e "${YELLOW}[2/8] Creation du schema...${NC}"
$PSQL -f "$SQL_DIR/01_schema.sql" -q
echo -e "${GREEN}  Schema cree.${NC}"

echo -e "${YELLOW}[3/8] Creation des index...${NC}"
$PSQL -f "$SQL_DIR/02_indexes.sql" -q
echo -e "${GREEN}  Index crees.${NC}"

echo -e "${YELLOW}[4/8] Creation des vues...${NC}"
$PSQL -f "$SQL_DIR/03_views.sql" -q
echo -e "${GREEN}  Vues creees.${NC}"

echo -e "${YELLOW}[5/8] Creation des fonctions PL/pgSQL...${NC}"
$PSQL -f "$SQL_DIR/04_functions.sql" -q
echo -e "${GREEN}  Fonctions creees.${NC}"

echo -e "${YELLOW}[6/8] Creation des triggers...${NC}"
$PSQL -f "$SQL_DIR/05_triggers.sql" -q
echo -e "${GREEN}  Triggers crees.${NC}"

echo -e "${YELLOW}[7/8] Insertion des donnees seed...${NC}"
$PSQL -f "$SQL_DIR/06_seed_data.sql" -q
echo -e "${GREEN}  Donnees inserees.${NC}"

echo -e "${YELLOW}[8/8] Verification...${NC}"
NB_TABLES=$($PSQL -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE';" | tr -d ' ')
NB_PROJETS=$($PSQL -t -c "SELECT COUNT(*) FROM projets;" | tr -d ' ')
NB_CLIENTS=$($PSQL -t -c "SELECT COUNT(*) FROM clients;" | tr -d ' ')
echo -e "${GREEN}  $NB_TABLES tables | $NB_PROJETS projets | $NB_CLIENTS clients${NC}"

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Initialisation terminee avec succes !${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "  pgAdmin : ${BLUE}http://localhost:8080${NC}"
echo -e "  DB      : ${BLUE}postgresql://$DB_USER@$DB_HOST:$DB_PORT/$DB_NAME${NC}"
