# homelab
Fully automated HomeLab from empty disk to running services with a single command.

## Configuration

In `vpn-reverse-proxy`, edit `.env.example` with your Tailscale authentication key and rename to `.env`. E.g. Where `XXX` is your Tailscale authentication key

```
echo "TS_AUTHKEY=XXX" > ./vpn-reverse-proxy/.env
```

## Start services

```
docker compose up -d
```

## Diagram

![diagram](./diagram.svg)

