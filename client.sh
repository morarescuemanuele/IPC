#!/bin/bash

# Verificam daca s-a dat un argument
if [ -z "$1" ]; then
    echo "Utilizare: $0 <nume_comanda>"
    echo "Exemplu: $0 ls"
    exit 1
fi

COMMAND_NAME=$1
CLIENT_PID=$$

# Incarcam configuratia
source config.cfg

# Verificam daca serverul este pornit
if [[ ! -p "$SERVER_FIFO" ]]; then
    echo "[Client] Eroare: Serverul nu pare a fi pornit ($SERVER_FIFO lipseste)."
    exit 1
fi

# Creare FIFO personalizat
CLIENT_FIFO="/tmp/server-reply-$CLIENT_PID"
if [[ ! -p "$CLIENT_FIFO" ]]; then
    mkfifo "$CLIENT_FIFO"
fi

# Construire si trimitere cerere cu formatul corect
REQUEST_STR="BEGIN-REQ [$CLIENT_PID: $COMMAND_NAME] END-REQ"

echo "[Client $CLIENT_PID] Trimit cerere: $REQUEST_STR"
echo "$REQUEST_STR" > "$SERVER_FIFO"

# Asteptare si afisare raspuns
echo "[Client $CLIENT_PID] Astept raspunsul de la server..."
echo "-----------------------------------------------------"

# Citim din FIFO-ul nostru

cat "$CLIENT_FIFO"

echo "-----------------------------------------------------"
echo "[Client $CLIENT_PID] Raspuns primit."

# Stergere fisier FIFO personal
rm -f "$CLIENT_FIFO"
