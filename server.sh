#!/bin/bash
source config.cfg

# Daca fisierul FIFO exista de la o rulare precedenta, il stergem
if [ -e "$SERVER_FIFO" ]; then
    rm "$SERVER_FIFO"
fi

trap "rm "$SERVER_FIFO"" EXIT

# Cream FIFO-ul nou
mkfifo "$SERVER_FIFO"
echo "[Server] FIFO creat la: $SERVER_FIFO"
echo "[Server] Asteapta cereri..."

# Bucla infinita care reporneste citirea
while true; do
	cat "$SERVER_FIFO" | while read line; do
		if [[ -n "$line" ]]; then
            	echo "[Server] Cerere primita: $line"
         	
            	content=$(echo "$line" | sed -n 's/.*\[\(.*\)\].*/\1/p')
            	client_pid=$(echo "$content" | awk -F': ' '{print $1}')
            	cmd_name=$(echo "$content" | awk -F': ' '{print $2}')
            
            	client_fifo="/tmp/server-reply-$client_pid"

            	if [[ -p "$client_fifo" ]]; then
                	echo "[Server] Procesare man page pentru '$cmd_name' catre PID $client_pid..."
                
                	man -P cat "$cmd_name" > "$client_fifo" 2>&1 &
            	else
                	echo "[Server] Eroare: FIFO-ul clientului nu a fost gasit."
            	fi
        fi
	done
	
    echo "[Server] Asteapta cereri..."
done


