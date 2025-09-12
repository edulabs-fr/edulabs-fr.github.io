---
title: La théorie
parent: VPN
grand_parent: Azure
nav_order: 2
---


### **Introduction**
Azure VPN est un service proposé par Microsoft Azure qui permet de relier en toute sécurité un réseau (site-to-site) ou un appareil individuel (point-to-site) à un réseau virtuel (VNet) hébergé dans le cloud Azure. Le tout via une connexion chiffrée transitant par Internet.

Ainsi, les utilisateurs peuvent accéder aux ressources Azure comme s’ils étaient directement connectés à leur réseau local.

C’est une solution performante, flexible et économique qui facilite l’établissement de liaisons sécurisées entre les infrastructures locales et le cloud.

Imaginons un scénario :

- Dans votre entreprise, la majorité de l’infrastructure est hébergée dans le cloud Azure. Cependant, vos équipes de développeurs, qu’elles soient au siège ou en télétravail, doivent accéder à certaines applications internes de manière sécurisée. C’est là qu’intervient Azure VPN : il permet de créer un tunnel sécurisé entre chaque utilisateur et un espace dédié du réseau distant, ou encore entre un site distant et un réseau virtuel sur Azure.

Azure VPN est donc la solution idéale pour allier souplesse et sécurité, en connectant vos équipes où qu’elles se trouvent.


![alt text](<67a5de2e7379a743adeef241_azure vpn gateway-1.png>)


### **Qu’est-ce qu’un VPN et une passerelle VPN ?**

Un VPN (Virtual Private Network ou réseau privé virtuel) est une technologie qui permet de créer une connexion sécurisée et chiffrée entre un appareil et un autre, elle peut être de type Peer-To-Peer (comme wireguard) ou Client-To-Server (comme OpenVPN).

Grâce à ce tunnel sécurisé, les données peuvent être transmises en toute confidentialité, comme si l’appareil était directement relié au réseau local privé distant, et cela même si la connexion s’effectue à travers un réseau public comme Internet.

Un VPN repose donc sur un tunnel chiffré, Il est généralement déployé pour connecter deux ou plusieurs réseaux privés de confiance entre eux, en passant par un réseau public ou privée (le plus souvent Internet). Le trafic est alors chiffré pendant tout son transit.


![alt text](67a5dcf78ab1f218da26fc78_4e81de24.png)


### **Les VPN et leur rôle**

Les VPN sont généralement utilisés pour :

- Aider à protéger la vie privée en ligne,
- Sécuriser les échanges de données,
- Permettre un accès distant sûr aux ressources d’un réseau privé ou d’entreprise.

Ils s’appuient sur des protocoles de chiffrement robuste qui garantissent que les données transmises ne puissent être interceptées par des acteurs malveillants.

En résumé, un VPN permet de :

- Chiffrer les données envoyées et reçues pour les protéger contre d’éventuelles menaces,
- Accéder de manière sécurisée à des ressources privées ou à du contenu géographiquement restreint.


### **Qu’est-ce qu’une passerelle VPN (VPN Gateway) ?**

Une passerelle VPN peut être assimilée à une porte d’entrée sécurisée située à la frontière d’un réseau. Sa mission est de mettre en place un tunnel chiffré sur Internet, permettant l’échange de données en toute confidentialité. Elle agit comme un intermédiaire de confiance entre :

- L’appareil d’un utilisateur et un réseau privé,
- Ou deux réseaux privés distincts reliés à distance.

De façon concrète, une passerelle VPN :

- Établit la connexion sécurisée entre les deux parties,
- Chiffre le trafic échangé,
- Protège les informations sensibles contre les interceptions et les attaques potentielles.

On distingue deux scénarios d’utilisation majeurs :

- Accès à distance (Point-to-Site) : offrir aux collaborateurs en télétravail ou en déplacement un accès sécurisé au réseau de l’entreprise.
- Connexion site-à-site (Site-to-Site) : relier plusieurs sites ou réseaux d’entreprise dispersés géographiquement de manière sécurisée.

Aujourd’hui, les passerelles VPN sont des composants stratégiques dans toute architecture réseau moderne. Elles garantissent deux principes fondamentaux de la cybersécurité :

- La confidentialité (seules les personnes autorisées peuvent lire les données),
- L’intégrité (les données ne sont pas altérées durant le transfert).

### **Comment fonctionne-t-elle ?**

Le fonctionnement d’une passerelle VPN repose sur plusieurs étapes clés :

1. Authentification et autorisation : les appareils ou réseaux souhaitant se connecter sont validés.
2. Création du tunnel sécurisé : celui-ci est établi à l’aide de protocoles de sécurité éprouvés comme IPsec ou SSL/TLS.
3. Chiffrement et transmission : toutes les données qui traversent le tunnel sont chiffrées afin d’assurer leur confidentialité et leur intégrité.

Une fois arrivées à destination, les données sont déchiffrées par la passerelle VPN, permettant une communication bidirectionnelle fluide et sécurisée entre les réseaux connectés.

Ce mécanisme rend possible une connectivité privée et sécurisée sur une infrastructure publique comme Internet. C’est pourquoi les passerelles VPN sont devenues incontournables dans des cas d’usage tels que :

- L’accès distant des utilisateurs,
- Les connexions sécurisées entre sites,
- La communication protégée dans des environnements cloud comme Microsoft Azure.


Pour garantir la sécurité des échanges, Azure VPN Gateway s’appuie sur des protocoles standards de l’industrie, comme IPSec et SSTP, qui assurent le chiffrement et l’intégrité des données pendant leur transit.

Voici ses principales fonctionnalités :

- Connexion site-à-site : relier en toute sécurité un réseau local à un réseau virtuel Azure.
- Connexion point-à-site : offrir aux utilisateurs distants (télétravail, mobilité) un accès sécurisé aux ressources Azure.
- Intégration avec ExpressRoute : combiner un circuit dédié privé avec une passerelle VPN pour plus de flexibilité et de sécurité.
- Scalabilité : adapter automatiquement la capacité en fonction des besoins réseau de l’organisation.
- Redondance : supporter des configurations actives-actives ou actives-passives pour garantir une connectivité fiable et continue.
- Compatibilité multi-protocoles : prise en charge d’IKEv1, IKEv2 et OpenVPN pour s’adapter à différents environnements et appareils.
- Sécurité avancée : chiffrement robuste et mécanismes d’authentification pour protéger les données sensibles.
- Déploiement multi-régions : possibilité de déployer des passerelles dans plusieurs régions Azure afin d’améliorer les performances, de renforcer la résilience et de mettre en place des architectures géo-redondantes.