#!/bin/bash

gpgtar --symmetric --output "$(date '+%Y-%m-%d')-vaultwarden.tar.gpg" vaultwarden .env
