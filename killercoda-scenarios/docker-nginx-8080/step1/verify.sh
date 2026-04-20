#!/bin/bash
set -e

# verifica immagine
docker image inspect nginx-custom >/dev/null 2>&1

# verifica container
docker ps --format '{{.Names}}' | grep -q '^web$'

# verifica porta corretta
docker ps --format '{{.Ports}}' | grep -q '0.0.0.0:8080->8080'

# verifica contenuto
curl -s http://localhost:8080 | grep -q 'Docker custom image works'

echo "Verifica completata con successo!"
