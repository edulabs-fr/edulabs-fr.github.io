---
title: Lab-01-Solution
parent: sysAdmin
grand_parent: LinuxLabs
nav_order: 2
---

# 💡 Solutions du Lab Linux — Sprint 1

Cette page contient les corrections détaillées des tickets et incidents du Sprint 1.

---

## Tickets

### Ticket T1 — Onboarding d’Alice Dupont

**Objectif**  
- Créer `alice.dupont`
- lui attribuer le shell `/bin/bash`
- L'ajouter au **groupe primaire** `marketing`
- La forcer à changer son mot de passe au 1er login.

```bash
#Créer l'utilisateur alice.dupont, lui attribuer le shell bash, et l'ajouter au groupe marketing comme groupe primare
useradd -m -c "Alice Dupont" -s /bin/bash -g marketing alice.dupont

#Définir un nouveau mot de passe temporaire
echo "alice.dupont:MotDePasse123!" | chpasswd

#Forcer Alice a changer son mot de passe au prochain login (équivalent: chage -d 0 alice.dupont)
passwd -e alice.dupont          
```

**Vérification :**
```bash
# Le groupe primaire = marketing
id alice.dupont   

#Vérifier que Alice à bien /bin/bash comme shell
getent passwd alice.dupont | grep ':/bin/bash$'

# Vérifier que Alice possède bien son /home
ls -l /home/ 

# Doit indiquer "Password must be changed"
chage -l alice.dupont           
```

---

### Ticket T2 — Groupe transverse com

**Objectif**  

- Vérifier si le groupe `com` est présent.
- Créer le groupe `com`
- Ajouter `alice.dupont` au groupe `com`, ce groupe doit être son groupe *secondaire*

```bash
#Vérifier si le groupe com est existant
getent group com
#Créer le groupe com
groupadd -f com
#Ajouter alice.dupont au groupe com (en tant que groupe secondaire)
usermod -aG com alice.dupont
```

**Vérification :**
```bash
#Vérifier que alice.dupont est dans le groupe com, et que ce groupe est son groupe secondaire
id -nG alice.dupont | grep com
```

---

### Ticket T3 — Partage Marketing (setgid)

**Objectif**  

- Attribuer au groupe Marketing les permissions de lecture, écriture et exécution sur le répertoire `/srv/depts/marketing/share`, avec validation de la procédure (test)

En d'autres termes : Activer le setgid et droits d’équipe sur /srv/depts/marketing/share, avec héritage du groupe.

```bash
#Vérifier les permissions et droits actuelles, le groupe share est en lecture uniquement
ls -ld /srv/depts/marketing/share

#Tester l'écriture avec un utilisateur faisant partie du groupe marketing !
sudo -u alice.dupont touch /srv/depts/marketing/share/testfile

# Changer les propriétaire du répertoire share 
chown root:marketing /srv/depts/marketing/share

# Activer le setgid et modifier les droits d'équipe marketing
chmod 2770 /srv/depts/marketing/share
```

**Vérification :**

```bash
# Test d'héritage de groupe
sudo -u alice.dupont touch /srv/depts/marketing/share/testfile

#Doit retourner : 2770 root:marketing
stat -c '%a %U:%G' /srv/depts/marketing/share   
#Doit retourner  ...alice.dupont:marketing
stat -c '%n %U:%G' /srv/depts/marketing/share/testfile  

#Résultat attendu : drwxrws--- 2 root marketing
ls -ld /srv/depts/marketing/share
```

---

### Ticket T4 — Squelette & Bob Martin (Dev)

**Objectif**  

1. Mise à jour du squelette `/etc/skel` :
    - ajout d'un dossier `Documents`
    - ajout d'un alias `ll='ls -alF'`
2. Création d'un utilisateur martin.bob avec comme groupe primaire `dev`
3. Validation du bon fonctionnement de la procédure

```bash
# Squelette standard
install -d -m 0755 /etc/skel/Documents
echo "alias ll='ls -alF'" >> /etc/skel/.bashrc

# Créer Bob (après maj du skel)
useradd -m -d /home/bob.martin -s /bin/bash -g dev bob.martin
echo "bob.martin:Password123!" | chpasswd
```

**Vérification :**
```bash
#Groupe primaire doit être dev
id -nG bob.martin 

#Vérifier que le répertoire Documents est bien présent dans le home de bob.martin
ls -l /home/bob.martin | grep Documents

#Résultat attendu : alias ll='ls -alF'
cat /home/bob.martin/.bashrc | grep "alias ll='ls -alF'"
```


---

## Incidents - Troubleshooting

### <span style="color:red">Incident INC-01 — « Je suis dans le groupe mais je ne peux pas écrire - alice.dupont »</span> {: .fw-300 }

**Ticket de alice.dupont :** « Je suis dans le groupe `marketing` mais je ne peux pas écrire »

**Symptômes :** Un membre de marketing ne peut pas créer dans `…/marketing/share`.

**Diagnostic :**

On fait un test pour reproduire l'erreur :
`sudo -u alice.dupont touch /srv/depts/marketing/share/test`

On à bien un problème de permission :
`touch: cannot touch '/srv/depts/marketing/share/test': Permission denied`

On vérifie les droits :
`stat -c '%a %U:%G' /srv/depts/marketing/share`

**Correctif :**

```bash
chown root:marketing /srv/depts/marketing/share
chmod 2770 /srv/depts/marketing/share
```

**Vérification :**

```bash
sudo -u alice.dupont touch /srv/depts/marketing/share/test
stat -c '%G' /srv/depts/marketing/share/test   # → marketing
rm -f /srv/depts/marketing/share/test
```

---

### <span style="color:red"> Incident INC-02 — « Oups, j'ai supprimé par erreur le fichier d'un collègue - alice.dupont » </span>


Dans le répertoire `/srv/depts/marketing/share`, Alice a supprimer le fichier de bob sans faire attention. Heuresement Bob possédait le fichier dans son drive, cependant, ce genre
d'incident ne doit plus se produire, trouvez une solution pour permettre aux utilsiateurs dugroupe marketing qui travaillent sur le dossier share de supprimer leurs propres fichiers
mais pas ceux des autres. Tout en gardant les possibilité de lectures/ecritures/exécutions. 

**Symptômes :**

Afficher l'état du répertoire pour avoir une idée sur le problème.

```bash
`ls -ld /srv/depts/marketing/share`
```
Le dossier est bien group-writable (rwxrwx---) mais le sticky-bit est absent.

Tout membre du groupe marketing peut supprimer n’importe quel fichier, même s’il n’en est pas propriétaire.

**Diagnostic :**

Reproduire le problème :

```bash
# Création d’un fichier de test dans le dossier "share"
# → exécuté en tant qu’utilisateur thomas.dru
# → le fichier appartiendra à thomas.dru et au groupe marketing
sudo -u thomas.dru touch /srv/depts/marketing/share/coucouAlice

# Tentative de suppression du fichier par un autre utilisateur (alice.dupont)
# → si le sticky bit n’est PAS activé, la suppression sera possible
# → si le sticky bit est activé, la suppression échouera (seul le propriétaire peut supprimer)
sudo -u alice.dupont rm /srv/depts/marketing/share/coucouAlice
```


**Correctif :**

- Réactiver le sticky-bit tout en conservant l’écriture groupe :

```bash
chmod +t /srv/depts/marketing/share  
```

Aucun changement supplémentaire n’est nécessaire ; les droits rwx du groupe restent intacts.

**Vérification :**

```bash
# Création d’un fichier de test dans le dossier "share" par thomas.dru
sudo -u thomas.dru touch /srv/depts/marketing/share/coucouAlice

#Suppression du fichier par alice.dupont
sudo -u alice.dupont rm /srv/depts/marketing/share/coucouAlice

# Vérification des permissions du dossier "share"
# → permet de voir si le sticky bit est présent (drwxrwsT ou drwxrws+t)
# → sans sticky bit : les membres du groupe peuvent supprimer les fichiers des autres
# → avec sticky bit : seuls les propriétaires peuvent supprimer leurs fichiers
ls -ld /srv/depts/marketing/share`
```

---

### <span style="color:red"> Incident INC-03 — « Je n'arrive plus à changer mon mot de passe : Authentication token manipulation error - camel.chalal » </span>

**Symptômes :**
- Suite à une manipulation hasardeuse de ma part `camel.chalal` je n'arrive plus à changer mon mot de passe, j'ai une erreur `passwd: Authentication token manipulation error`.

mot de passe actuel : Motdepasse123!

```bash
sudo -u camel.chalal passwd
```

**Diagnostic :**
- Vérifier permissions de `/etc/shadow` :
```bash
ls -l /etc/shadow
```
- Attendu : `-rw-r----- 1 root shadow ... /etc/shadow`

**Correctif :**
```bash
chattr -i /etc/shadow || true
chown root:shadow /etc/shadow; chmod 640 /etc/shadow
chown root:root  /etc/passwd;  chmod 644 /etc/passwd
```

**Vérification :**
```bash
ls -l /etc/shadow
sudo -u camel.chalal passwd
```
---

### <span style="color:red"> Incident INC-04 — « Je n'arrive pas à me connecter en ssh avec la nouvelle clé  - camel.chalal » </span>

**Symptômes :**
Votre collaborateur camel.chalal n'arrive pas à se connecter avec sa clé privé, le serveur semble ignorer l'authentification par clé et bascule en authentification par mot de passe.


**Diagnostic :**
1. Vérifier les permissions sur le répertoire /home/camel.chalal/.ssh et le fichier  /home/camel.chalal/.ssh/authorized_keys

```bash
#Attendu : drwx------ (0700) camel.chalal camel.chalal
ls -ld /home/camel.chalal/.ssh

#Attendu : -rw------- (0600) camel.chalal camel.chalal
ls -ld /home/camel.chalal/.ssh/authorized_keys
```
Si les permissions sont plus ouvertes (ex : 0644 ou 0755), le démon SSH ignore le fichier pour des raisons de sécurité → d’où l’erreur de Sylvain.

**Correctif :**
```bash
# Répertoire .ssh
chown camel.chalal:camel.chalal /home/camel.chalal/.ssh
chmod 0700 /home/camel.chalal/.ssh

# Fichier authorized_keys
chown camel.chalal:camel.chalal /home/camel.chalal/.ssh/authorized_keys
chmod 0600 /home/camel.chalal/.ssh/authorized_keys
```

**Vérification :**
```bash
#Attendu : drwx------ (0700) camel.chalal camel.chalal
ls -ld /home/camel.chalal/.ssh

#Attendu : -rw------- (0600) camel.chalal camel.chalal
ls -ld /home/camel.chalal/.ssh/authorized_keys
```