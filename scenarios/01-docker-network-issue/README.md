# Scénario 1 : Dépannage d'une Erreur 502 Bad Gateway avec Docker et Nginx

Bienvenue dans ce premier scénario de dépannage de notre projet "homelab-ancrage-local".
L'objectif est de simuler une panne courante en environnement de production et de la résoudre étape par étape.

## Le Problème

Nous avons déployé une application web basée sur WordPress, avec une base de données MySQL et un reverse proxy Nginx. L'ensemble est conteneurisé avec Docker Compose.

Après le déploiement, le site est inaccessible et renvoie une erreur **502 Bad Gateway**.

## L'Environnement

Le fichier `docker-compose.yml` à la racine de ce dossier décrit notre architecture :
- Un service `db` pour la base de données MySQL.
- Un service `wordpress` pour l'application WordPress.
- Un service `proxy` pour le reverse proxy Nginx, qui expose le port 8080 sur l'hôte.

Le fichier de configuration Nginx se trouve dans `nginx/nginx.conf`.

## Étape 1 : Démarrer l'environnement et constater le problème

Pour démarrer l'environnement et reproduire la panne, exécutez le premier script :

```bash
./scripts/1-demarrer-environnement.sh
```

Une fois les conteneurs démarrés, utilisez le deuxième script pour constater le problème. Ce script va tenter de se connecter au site web et afficher les logs du proxy Nginx.

```bash
./scripts/2-constater-le-probleme.sh
```

Vous devriez voir une sortie similaire à celle-ci, confirmant l'erreur 502 :

```
HTTP/1.1 502 Bad Gateway
...
```

Dans les logs de Nginx, vous verrez une erreur indiquant que le nom d'hôte `wordpress-app-wrong-name` ne peut pas être résolu. C'est la cause de notre problème.

## Étape 2 : Analyser la cause racine

L'erreur `host not found in upstream "wordpress-app-wrong-name"` dans les logs Nginx nous indique que le proxy n'arrive pas à joindre le conteneur WordPress.

En inspectant le fichier `nginx/nginx.conf`, on voit que la directive `proxy_pass` pointe vers `http://wordpress-app-wrong-name;`.

Or, dans notre `docker-compose.yml`, le service WordPress est nommé `wordpress`. Docker Compose utilise les noms de service comme noms d'hôte pour la résolution DNS interne au sein d'un même réseau.

L'erreur est donc une simple faute de frappe dans la configuration de Nginx.

## Étape 3 : Appliquer le correctif

Le fichier `nginx/nginx.conf.fixed` contient la configuration corrigée, avec le bon nom de service dans la directive `proxy_pass`.

Pour appliquer le correctif, exécutez le troisième script. Ce script va remplacer le fichier de configuration défaillant par le fichier corrigé et redémarrer le conteneur Nginx.

```bash
./scripts/3-appliquer-le-correctif.sh
```

## Étape 4 : Vérifier la solution

Maintenant que le correctif est appliqué, nous pouvons vérifier que le site est de nouveau accessible. Exécutez le quatrième et dernier script :

```bash
./scripts/4-verifier-la-solution.sh
```

Vous devriez maintenant voir une réponse `HTTP/1.1 200 OK`, indiquant que le site fonctionne correctement.

Félicitations, vous avez résolu votre première panne !
