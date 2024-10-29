#!/bin/bash

install_docker() {
    
    sudo apt-get update -y
    
    
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    
    sudo apt-get update -y

    
   sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    
    sudo systemctl enable docker
    sudo systemctl start docker

    
    docker --version && echo "Docker installation complete!"
}

install_docker

sleep 10 

reload_shell() {
  if [[ $SHELL == *"zsh"* ]]; then 
    echo "Reloading zsh configuration..."
    source ~/.zshrc
    elif [[ $SHELL == *"bash"* ]]; then 
      echo "Reloading bash configuration..."
      source ~/.bashrc
    else 
      echo "UNsported Shell"
  fi 
}
reload_shell

sleep 10

echo "STRATEGY_EXECUTOR_DISPLAY_NAME is youre validator name "
echo "STRATEGY_EXECUTOR_BENEFICIARY is a EVM publick address, use a safe wallet reward will drop to this address"
echo "SIGNER_PRIVATE_KEY a private key with out any assets DO NOT ADD 0x to the p-key "

FILENAME="validator.env"
echo "ENV=testnet-3" > "$FILENAME"

variables=("STRATEGY_EXECUTOR_DISPLAY_NAME" "STRATEGY_EXECUTOR_BENEFICIARY" "SIGNER_PRIVATE_KEY")

function is_valid_input() {
  [[ "$1" =~ ^[A-Za-z0-9_\- ]*$ ]]
}


for var in "${variables[@]}"; do 
  while true; do 
    read -p "$var: " value 
    if is_valid_input "$value"; then 
      echo "$var=$value" >> "$FILENAME"
      break 
      else
        echo "Invalid input. Only A-Z, a-z, 0-9, _, -, and space are allowed."
    fi 
  done 
done 

echo "validator.env file created successfully!"
sleep 10 

docker pull elixirprotocol/validator:v3-testnet

path=$(find / -iname "validator.env" -type f 2>/dev/null)

if [[ -n "$path" ]]; then
  echo "File found at: $path"
else
  echo "validator.env file not found."
fi

sleep 10 

docker run -it \
  --env-file ${path} \
  --name elixir \
  elixirprotocol/validator:v3-testnet



