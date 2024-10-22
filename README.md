# devca
Developer CA: personal certificate authority utility for developers and hobbits

## Installation

```bash
wget -qO- https://raw.githubusercontent.com/madcato/devca/refs/heads/main/boot.sh | bash
```

## Usage

```bash
~/.local/share/devca/create-server-cert.sh
```

Files are created in current directory.

## Info

This script creates a CA certificate and its key. Both files are stored in `~/.devca` by default.
