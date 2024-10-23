#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

install_openssl() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if ! command_exists openssl; then
      echo "OpenSSL not found. Installing via Homebrew..."
      if ! command_exists brew; then
        echo "Homebrew not found, installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      brew install openssl
    else
      echo "OpenSSL is already installed on macOS."
    fi
  elif [[ -n "$(command -v lsb_release)" ]] && [[ "$(lsb_release -is)" == "Ubuntu" ]]; then
    # Ubuntu
    if ! command_exists openssl; then
      echo "OpenSSL not found. Installing via APT..."
      sudo apt update && sudo apt install -y libssl-dev
    else
      echo "OpenSSL is already installed on Ubuntu."
    fi
  else
    echo "Unsupported OS."
    exit 1
  fi
}

install_openssl

# Create CA certificate if not exist
mkdir -p ~/.devca

if [[ ! -f ~/.devca/ca.crt ]]; then
  echo "Creating CA certificate..."
  openssl genrsa -out ~/.devca/ca.key 2048
  openssl req -new -x509 -key ~/.devca/ca.key -out ~/.devca/ca.crt -days 3650 -subj "/C=US/ST=State/L=City/O=Organization/CN=Local Dev CA"
else
  echo "CA certificate already exists."
  echo "If you want to regenerate it, please remove the existing one ~/.devca/ca.crt and ~/.devca/ca.key files, and reinstall"
fi

# Install ca certificate in the system

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  echo "Installing CA certificate in the macOS system keychain..."
  sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/.devca/ca.crt 
elif [[ -n "$(command -v lsb_release)" ]] && [[ "$(lsb_release -is)" == "Ubuntu" ]]; then
  # Ubuntu
  echo "Installing CA certificate in the Ubuntu system..."
  sudo cp ~/.devca/ca.crt /usr/local/share/ca-certificates/devca.crt
  sudo update-ca-certificates
else
  echo "Unsupported OS."
  exit 1
fi
