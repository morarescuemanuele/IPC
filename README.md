# IPC Client-Server Manual Fetcher

A lightweight Client-Server application written in Bash that demonstrates Inter-Process Communication (IPC) using Named Pipes (FIFOs) on Linux. 

This project allows a client to request a Linux manual page (e.g., `ls`, `grep`) from a background server. The server processes the request asynchronously and sends the manual page content back to the specific client that requested it.

## Features

*   **Inter-Process Communication (IPC):** Utilizes Linux Named Pipes (`mkfifo`) to establish a two-way communication channel between the client and the server.
*   **Concurrent Client Handling:** The server runs in a continuous loop and dispatches background jobs (`&`) to process requests, allowing multiple clients to request data simultaneously without blocking the server.
*   **String Parsing:** Uses `sed` and `awk` to parse formatted request strings and extract relevant data (Client PIDs and command names).
*   **Dynamic Cleanup:** Automatically manages the creation and deletion of custom FIFOs to prevent clutter in the `/tmp` directory.

## Project Structure

*   `config.cfg` - A configuration file that defines the path for the main server FIFO.
*   `server.sh` - The background server script. It creates the main FIFO, listens for incoming client requests, extracts the requested command, and sends the output of the `man` command to the client's specific FIFO.
*   `client.sh` - The client script. It generates a unique FIFO based on its Process ID (PID), sends a formatted request to the server, waits for the response, prints it to the terminal, and cleans up after itself.

## Prerequisites

To run these scripts, you need a Linux/Unix-based operating system with:
*   Bash shell
*   Standard core utilities (`sed`, `awk`, `cat`, `rm`, `mkfifo`)
*   The `man` command installed

## How to Run

**1. Clone the repository and navigate to the directory:**
```bash
git clone https://github.com/morarescuemanuele/itbi.git
cd itbi
```

**2. Make the scripts executable:**
```bash
chmod +x server.sh client.sh
```

**3. Start the Server:**
Open a terminal and start the server. It will run continuously and wait for requests.
```bash
./server.sh
```
*Expected output:*
> `[Server] FIFO creat la: /tmp/main_server_fifo`
> `[Server] Asteapta cereri...`

**4. Run the Client (in a separate terminal):**
Open a new terminal window or tab (keeping the server running in the first one) and run the client script, passing the name of a Linux command as an argument.
```bash
./client.sh ls
```
*Expected output:*
> `[Client 12345] Trimit cerere: BEGIN-REQ [12345: ls] END-REQ`
> `[Client 12345] Astept raspunsul de la server...`
> `-----------------------------------------------------`
> `(Outputs the full manual page for 'ls')`
> `-----------------------------------------------------`
> `[Client 12345] Raspuns primit.`

## Stopping the Server
To stop the server, simply go to the terminal where it is running and press `Ctrl + C`. The script includes a `trap` command that will automatically clean up the main FIFO file (`/tmp/main_server_fifo`) upon exit.
