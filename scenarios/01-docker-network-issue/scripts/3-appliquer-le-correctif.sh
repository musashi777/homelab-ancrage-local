#!/bin/bash
# Ce script doit être exécuté depuis la racine du dossier /01-docker-network-issue

echo "Remplacement du fichier de configuration Nginx défaillant par le correctif..."
cp nginx/nginx.conf.fixed nginx/nginx.conf

echo "Redémarrage du conteneur Nginx pour appliquer la nouvelle configuration..."
docker-compose restart nginx

echo "Le correctif a été appliqué."
