#!/bin/bash 

docker kill elixir
sleep 4
docker rm elixir
sleep 4
docker pull elixirprotocol/validator:v3-testnet

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



