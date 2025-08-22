---
title: Lab-01
parent: sysAdmin
grand_parent: LinuxLabs
nav_order: 2
---

# 💡 Solutions du Lab Linux — Sprint 1

Cette page contient les corrections détaillées des tickets et incidents du Sprint 1.

---

## Tickets

### Ticket T1 — Création de l’utilisateur `alice.dupont`

**Objectif**  
Créer `alice.dupont`, shell `/bin/bash`, **groupe primaire** `marketing`, mot de passe à changer au 1er login.

```bash
#Créer l'utilisateur alice.dupont, lui attribuer le shell bash, et l'ajouter au groupe marketing comme groupe primare
useradd -m -c "Alice Dupont" -s /bin/bash -g marketing alice.dupont

#Définit un nouveau mot de passe
echo "alice.dupont:MotDePasse123!" | chpasswd

#Forcer Alice a changer son mot de passe au prochain login
passwd -e alice.dupont          # (équivalent: chage -d 0 alice.dupont)
```

**Vérification :**
```bash
id alice.dupont                 # groupe primaire = marketing
getent passwd alice.dupont | grep ':/bin/bash$'
test -d /home/alice.dupont
chage -l alice.dupont           # doit indiquer "Password must be changed"```
```

---

### ✅ Ticket T2 — Ajout d’un utilisateur secondaire

**Objectif**  

S’assurer que le groupe ```com``` existe et qu’Alice en est membre *secondaire*.

```bash
groupadd -f com
usermod -aG com alice.dupont
```

**Vérification :**
```bash
getent group com
id -nG alice.dupont | grep com
```

---

### ✅ Ticket T3 — Droits sur `/srv/depts/marketing/share`

**Objectif**  

Attribuer au groupe Marketing les permissions de lecture, écriture et exécution sur le répertoire `/srv/depts/marketing/share`
, avec validation de la procédure (test)

En d'autres termes : Activer le setgid et droits d’équipe sur /srv/depts/marketing/share, avec héritage du groupe.

```bash
chown root:marketing /srv/depts/marketing/share
chmod 2770 /srv/depts/marketing/share      # 2 = setgid
```

**Vérification :**

```bash
# Test d'héritage de groupe
sudo -u alice.dupont touch /srv/depts/marketing/share/testfile

stat -c '%a %U:%G' /srv/depts/marketing/share   # → 2770 root:marketing
stat -c '%n %U:%G' /srv/depts/marketing/share/testfile  # → ... : marketing

ls -ld /srv/depts/marketing/share
```

(doit montrer `drwxrws--- root marketing`)

---

### ✅ Ticket T4 — Groupe projet `siteweb`

**Objectif**  

1. Mise à jour du squelette `/etc/skel` :
- ajout d'un dossier `Documents`
- ajout d'un alias `ll='ls -alF'`
2. Création d'un utilisateur martin.bob avec comme groupe primaire `dev`
3. Validation du bon fonctionnement de la procédure

```bash
# Squelette standard
install -d -m 0755 /etc/skel/Documents
echo "alias ll='ls -alF'" >> /etc/skel/.bash_aliases

# Créer Bob (après maj du skel)
useradd -m -d /home/bob.martin -s /bin/bash -g dev bob.martin
echo "bob.martin:Password123!" | chpasswd
```

**Vérification :**
```bash
id -nG bob.martin #Groupe primaire = dev
ls -l /home/bob.martin | grep Documents
cat /home/bob.martin/.bashrc | grep "alias ll='ls -alF'"
```


---

## 🚨 Incidents

### 🔴 Incident INC-01 — Mauvaises permissions sur `/srv/depts/hr/share`

**Ticket de alice.dupont :**
- « Je suis dans le groupe `marketing` mais je ne peux pas écrire »

Un membre de marketing ne peut pas créer dans `…/marketing/share`.

**Diagnostic :**

On fait un test pour reproduire l'erreur :
`sudo -u alice.dupont touch /srv/depts/marketing/share/test`

On à bien un problème de permission :
`touch: cannot touch '/srv/depts/marketing/share/test': Permission denied`

On vérifie les droits :
`stat -c '%a %U:%G' /srv/depts/marketing/share`

**PostMortem explication :**
A finir

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

### 🔴 Incident INC-02 — Utilisateur absent du groupe

  Dans le répertoire `/srv/depts/marketing/share`, Alice a supprimer le fichier de bob sans faire attention. Heuresement Bob possédait le fichier dans son drive, cependant, ce genre
  d'incident ne doit plus se produire, trouvez une solution pour permettre aux utilsiateurs dugroupe marketing qui travaillent sur le dossier share de supprimer leurs propres fichiers
  mais pas ceux des autres. Tout en gardant les possibilité de lectures/ecritures/exécutions. 

**Symptômes :**

# état du répertoire

`ls -ld /srv/depts/marketing/share`
Le dossier est bien group-writable (rwxrwx---) mais le sticky-bit est absent.

Tout membre du groupe marketing peut supprimer n’importe quel fichier, même s’il n’en est pas propriétaire.

**Diagnostic :**
reproduire le problème :
`sudo -u thomas.dru touch /srv/depts/marketing/share/coucouAlice`
`sudo -u alice.dupont rm /srv/depts/marketing/share/coucouAlice`

**Correctif :**

- Réactiver le sticky-bit tout en conservant l’écriture groupe :

`chmod +t /srv/depts/marketing/share`      

Aucun changement supplémentaire n’est nécessaire ; les droits rwx du groupe restent intacts.

**Vérification :**
`sudo -u thomas.dru touch /srv/depts/marketing/share/coucouAlice`
`sudo -u alice.dupont rm /srv/depts/marketing/share/coucouAlice`

`ls -ld /srv/depts/marketing/share` Le stickybit est bien affiché.

---

### 🔴 Incident INC-03 — `passwd: Authentication token manipulation error`

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