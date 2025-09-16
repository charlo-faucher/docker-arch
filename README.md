# Docker config for Archlinux instance

## Setup

### Copy and configure .env
```bash
cp .env.example .env
```

## Container

### Build the image only
```bash
docker-compose build --no-cache 
```

### Run the container
```bash
docker compose run -it --rm archvm zsh
```
*Remove --rm for keeping the container after exit*
