test() {
  echo "HERE IS A TEST"
}

kill_process_on_port() {
  local PORT=$1

  # Check if port is provided
  if [ -z "$PORT" ]; then
    echo "Error: No port provided."
    echo "Usage: kill_process_on_port <port>"
    return 1
  fi

  # Get the PID of the process running on the given port
  local PID=$(lsof -t -i TCP:$PORT -sTCP:LISTEN)

  # Check if a process is running on the port
  if [ -n "$PID" ]; then
    echo "Killing process $PID running on port $PORT..."
    kill -9 $PID
    echo "Process killed successfully."
  else
    echo "No process found running on port $PORT."
  fi
}
