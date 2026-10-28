# README

[![Release](https://img.shields.io/docker/v/jcpd/dknr-zigbee?sort=semver)](https://img.shields.io/docker/v/jcpd/dknr-zigbee?sort=semver)
[![Pull](https://img.shields.io/docker/pulls/jcpd/dknr-zigbee)](https://img.shields.io/docker/pulls/jcpd/dknr-zigbee)
[![Issue](https://img.shields.io/github/issues/jcdenis/dknr-zigbee)](https://img.shields.io/github/issues/jcdenis/dknr-zigbee)
[![License](https://img.shields.io/github/license/jcdenis/dknr-zigbee)](https://github.com/JcDenis/dknr-zigbee/blob/master/LICENSE)


## A propos

**dknr-zigbee** est un projet consacré au pilotage, à la récupération et à l'exploitation des données des appareils Zigbee en local. Ce projet s'appuie sur [Zigbee2MQTT](https://www.zigbee2mqtt.io/), qui gère la clé Zigbee et le réseau, et reprend ses appareils dans la même arborescence MQTT que les autres projets DKNR.


## Fonctionnalités

- **Tous les appareils supportés par Zigbee2MQTT** : capteurs, prises, interrupteurs, ampoules, volets, vannes thermostatiques, télécommandes...
- **Entités construites automatiquement** à partir de la description (exposes) de chaque appareil : valeurs numériques, états, listes de choix, textes.
- **Identifiant stable** : un appareil est identifié par son adresse IEEE, le renommer dans Zigbee2MQTT ne change ni ses topics ni ses entités Home Assistant.
- **Pilotage** de toutes les valeurs modifiables (allumer, éteindre, inverser, luminosité, consigne, mode...).
- **Réseau** : état du pont Zigbee2MQTT, liste des appareils (qualité du signal, batterie, dernier signal, disponibilité), autorisation de l'appairage, renommage et suppression d'un appareil.
- **Support Home-Assistant Discovery** en lecture et pilotage des appareils (capteurs, interrupteurs, nombres, sélecteurs, textes), y compris le pont lui-même.


## Matériel requis

Le matériel exact dépend de l'installation, mais l'utilisation du projet nécessite généralement :

* une clé ou un coordinateur Zigbee [compatible Zigbee2MQTT](https://www.zigbee2mqtt.io/guide/adapters/).
* un serveur MQTT, utilisé à la fois par Zigbee2MQTT et par ce projet.
* une machine exécutant le logiciel docker.


## Installation

Des images Docker prêtes à l'emploi sont disponibles.
Le fichier docker-compose.yaml à la racine du dépôt lance **Zigbee2MQTT** et **DKNR Zigbee**. Fournissez les variables d'environnement suivantes :

* **DKNR_USERNAME** : login de l'interface node-red.
* **DKNR_PASSWORD** : mot de passe de l'interface node-red.
* **DKNR_SECRET**   : un mot secret pour encrypter les credits.

Adaptez si besoin le port série de la clé Zigbee (`/dev/ttyUSB0`) et configurez le serveur MQTT dans le fichier `configuration.yaml` de Zigbee2MQTT (volume `data`).

L'interface de Zigbee2MQTT est disponible sur `http://<ip du serveur docker>/`, le tableau de bord DKNR sur `http://<ip du serveur docker>:1880/` et l'éditeur Node-RED sur `http://<ip du serveur docker>:1880/admin`.


## Configuration

### MQTT

Dans la page **Configurer** :

* **Adresse IP**, **port**, **utilisateur** et **mot de passe** du serveur MQTT, le même que celui de Zigbee2MQTT.
* **Topic** : racine des topics DKNR (`dknr` par défaut).
* **Zigbee2MQTT topic** : `base_topic` de Zigbee2MQTT (`zigbee2mqtt` par défaut).
* **Home Assistant Discovery topic** : laissez vide pour ne pas publier la discovery Home Assistant.

### Zigbee2MQTT

Quelques réglages de Zigbee2MQTT améliorent le fonctionnement du projet :

* **Disponibilité des appareils** (`availability: enabled: true`) : ajoute l'entité *Disponibilité* et rend les entités Home Assistant indisponibles quand l'appareil ne répond plus.
* **Dernier signal** (`advanced: last_seen: ISO_8601`) : ajoute l'entité *Dernier signal*.
* **Home Assistant** : si l'intégration Home Assistant de Zigbee2MQTT est aussi activée, chaque appareil apparaîtra deux fois dans Home Assistant. Désactivez l'une des deux discovery.

### Appairer un appareil

Dans la page **Réseau**, cliquez sur **Autoriser** (254 secondes au maximum) puis mettez l'appareil en mode appairage. Il apparaît dans la liste dès que Zigbee2MQTT l'a interrogé.


## MQTT

Avec le topic `dknr` par défaut, l'identifiant d'un appareil est son adresse IEEE sans `0x` (ex : `00158d0001a2b3c4`) et le nom d'une entité est la propriété Zigbee2MQTT (ex : `temperature`, `state`, `state_l1`) :

* `dknr/get/zigbee/<id>/<entité>` : valeurs publiées (retenues, sauf `action`) à chaque changement. Les états binaires valent `ON` ou `OFF`.
* `dknr/set/zigbee/<id>/<entité>` : commande, `ON`, `OFF` ou `TOGGLE` pour un état binaire, un nombre ou une valeur de la liste pour les autres.
* `dknr/discovery/zigbee/<id>/<entité>` : description des entités.
* `homeassistant/<type>/zigbee/<id>_<entité>/config` : Home Assistant Discovery.

Le pont Zigbee2MQTT est publié comme un appareil d'identifiant `bridge` : `state` (en ligne), `permit_join` (appairage, pilotable) et `version`.

Les entités *Disponibilité* (`availability`) et *Dernier signal* (`last_seen`) sont ajoutées dès que Zigbee2MQTT les publie.

Au démarrage, l'état des appareils alimentés sur secteur est relu une fois s'il n'est pas déjà connu. Les appareils sur pile ne répondent qu'à leur réveil.


## A faire

* Entités Home Assistant *light*, *cover* et *climate* complètes (les fonctions sont aujourd'hui publiées séparément : état, luminosité, position, consigne...).
* Couleur des ampoules (valeurs composées `color_xy`, `color_hs`).
* Groupes Zigbee2MQTT.


## Contribuer

Ce projet est **open-source**, vous pouvez participer en créant des [tickets](https://github.com/JcDenis/dknr-zigbee/issues) ou en proposant de [requêtes](https://github.com/JcDenis/dknr-zigbee/pulls) sur le dépôt github du projet.


## Voir aussi

- [DKNR Teleinfo](https://github.com/JcDenis/dknr-teleinfo)
- [DKNR APSystems](https://github.com/JcDenis/dknr-apsystems)
- [DKNR Daikin](https://github.com/JcDenis/dknr-daikin)
- [DKNR Zendure](https://github.com/JcDenis/dknr-zendure)
- [DKNR RFXCom](https://github.com/JcDenis/dknr-rfxcom)
- [DKNR Nuki](https://github.com/JcDenis/dknr-nuki)
- [Zigbee2MQTT : topics et messages MQTT](https://www.zigbee2mqtt.io/guide/usage/mqtt_topics_and_messages.html)
- [Zigbee2MQTT : exposes](https://www.zigbee2mqtt.io/guide/usage/exposes.html)
