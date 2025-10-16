#!/bin/bash
echo "Tentative de connexion au site web..."
curl -I http://localhost:8080
echo ""
echo "Affichage des logs du proxy Nginx..."
docker-compose logs proxy
