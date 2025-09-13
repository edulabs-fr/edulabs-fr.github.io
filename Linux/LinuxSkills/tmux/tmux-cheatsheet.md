---
title: Tmux - Cheatsheet
parent: LinuxSkills
grand_parent: Linux
nav_order: 2
---

# Tmux, c’est comme du chocolat belge : vous en ouvrez un, et vous en voulez encore. Simple, efficace, irrésistible.

On ne va pas se mentir : Tmux peut sembler un peu… relou au début. Entre les raccourcis bizarres, les commandes à rallonge et les fenêtres qui se multiplient, on a vite l’impression de piloter un vaisseau spatial sans manuel.

Mais rassurez-vous ! Une fois les bases en main, Tmux devient un outil génial qui vous fera gagner un temps fou !

C’est pour ça que j’ai préparé cette petite liste d’astuces : de quoi vous faciliter les premiers pas et éviter de vous arracher les cheveux. Après ça, vous risquez bien de vous demander comment vous faisiez avant…



### Astuce n°1 — Ne soyez pas puriste, surtout quand vous êtes né avec une souris en main : libérez la molette et le presse‑papiers !

Au début, Tmux peut donner l’impression que la molette de votre souris a démissionné et que le copier-coller est une mission impossible ! Ce qui, je l’avoue, est frustrant pour les informaticiens que nous sommes devenus.

La bonne nouvelle ? Avec quelques lignes bien placées dans votre configuration, tout rentre dans l’ordre et votre terminal retrouve toute sa souplesse.

On édite le fichier ```~/.tmux.conf``` et on ajoute :

```bash
# Activer la souris (scroll, sélection, redimensionnement)
set -g mouse on

# Autoriser le copier-coller avec le presse-papiers du système
set-option -g set-clipboard on

# Éviter que Tmux efface l’historique du terminal
set-option -g terminal-overrides "xterm*:smcup@:rmcup@"

# Raccourci pour entrer en mode copie avec "s"
unbind [
bind s copy-mode

# Utiliser les touches façon Vim dans le mode copie
setw -g mode-keys vi
``` 

- Ensuite exécutez la commande `tmux kill-server`
- Relancez tmux

Pour faire des copier/coller : 

- Copier : shift + selection
- Coller : click droit coller ou (shift insert)


**💡 Petite astuce dans l’astuce** : Si vous travaillez dans un environnement multi‑fenêtres (panels), il peut arriver qu’en voulant copier du texte depuis un panel, Tmux capture aussi le contenu des autres. Pas très pratique…

Pour éviter ça :

- Placez‑vous dans le panel depuis lequel vous voulez copier.
- Faites ```Ctrl + b```, puis tapez ```z```. Le panel passe alors en mode zoom, et occupe tout l’écran.
- Copiez votre texte tranquillement.
- Pour revenir à l’affichage normal, refaites ```Ctrl + b```, puis ```z```.


### Astuce n°2 — Persistez vos sessions !

Dans les règles de l’art, Tmux s’utilise souvent sur un serveur :

- Pour ne pas perdre la main en cas de déconnexion,
- Pour permettre à plusieurs personnes de travailler ensemble dans la même session (très utile lors des dépannages collaboratifs).

Sauf que moi, je l’utilise aussi sur mon PC de contrôle (pour des raisons qui ne regardent que moi, hein !). Bon j'avoue j’adore profiter du multipanel et jongler avec plusieurs sessions selon mes besoins.

Le problème, c’est que lorsque j’éteins mon PC et que je reviens le lendemain, je dois tout recréer : fenêtres, panneaux, sessions… bref, la corvée.

Et puis, j’ai découvert une solution magique : sauvegarder mes sessions et les restaurer en deux commandes. Résultat : je reprends exactement là où je m’étais arrêté, comme si rien ne s’était passé.


**Installation**
``` Bash
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect
```

**Configuration**
Modifiez votre fichier `~/.tmux.conf` et ajoutez à la fin :

```bash
# plugins
set -g @plugin 'tmux-plugins/tmux-resurrect'

# touches : sauvegarde et restauration
bind C-s run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh
bind C-r run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh
```

Ensuite `tmux kill-server` et relancez tmux

**Utilisation**
- `Ctrl + b`, puis `Ctrl + s` pour *sauvegarder*
- `Ctrl + b`, puis `Ctrl + r` pour *restaurer*


### Sessions Tmux
- Ouvrir une nouvelle session  `tmux new -s nom_session`
- Détacher une session (quitter sans fermer) `Ctrl + b`, puis `d`
- Lister les sessions `tmux list-sessions` ou `tmux ls`
- Rejoindre une session existante  `tmux attach -t nom_session`
- Changer de session  `tmux switch -t nom_session`
- Supprimer une session  `tmux kill-session -t nom_session`
- Supprimer toutes les sessions sauf celle en cours  `tmux kill-session -a`


### Fenêtres & Splits
- Créer une nouvelle fenêtre `Ctrl + b`, puis `c`
- Lister les fenêtres `Ctrl + b`, puis `w`
- Naviguer entre les fenêtres `Ctrl + b`, puis `n` (suivante) / `p` (précédente)
- Se déplacer vers une fenêtre spécifique `Ctrl + b`, puis `numéro_fenêtre`
- Fermer la fenêtre `Ctrl + b`, puis `&`
- Renommer la fenêtre `Ctrl + b`, puis `&`


### Panes (diviser l’écran)
- Split horizontal `Ctrl + b`, puis `%`
- Split vertical `Ctrl + b`, puis `"`
- Fermer un split `Ctrl + b`, puis `x` (et confirmer)
- Naviguer entre les splits `Ctrl + b`, puis `←` `→` `↑` `↓`
- Pour afficher un pane en plein écran `Ctrl + b`, puis `z`

