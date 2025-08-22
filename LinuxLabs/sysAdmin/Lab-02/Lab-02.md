---
title: Lab-02
parent: sysAdmin
grand_parent: LinuxLabs
nav_order: 1
---

# Lab Linux — Utilisateurs, Groupes & Troubleshooting (Sprint 2)


## 🎯 Objectifs pédagogiques


---

## ⚙️ Lancement (ISO ou Docker)

> *Cette section est indicative ; adaptez les URLs/tags à votre image publique.*

### Option A — Image prête à l’emploi (VM)

- Téléchargez l’image préconfigurée mise à disposition (Proxmox, VirtualBox, VMware Workstation, Hyper-V).
- Importez l’image dans votre hyperviseur et démarrez la machine virtuelle.
- Connectez-vous avec l’utilisateur root pour commencer.

```bash
nom d'utilisateur : root
mot de passe : root
```

### Option B — Docker (image tout-en-un)
```bash
docker run -it --name lab-linux \
  --hostname Lab-scen2 \
  --privileged \
  -v lab_data:/srv \
  ghcr.io/<votre-org>/<votre-image>:<tag>
```

### Option C (Privé) — Cloud/Proxmox (VM) :
Loremipsum Loremipsum Loremipsum Loremipsum
Loremipsum Loremipsum Loremipsum Loremipsum
Loremipsum Loremipsum Loremipsum Loremipsum

---
## 🧪 Scénario du Lab


Arborescence de référence :
```bash
/srv/
└── depts/
├── marketing/
│ └── share/ (collaboration interne)
├── dev/
│ └── share/
├── hr/
│ └── share/
└── ops/
└── share/
```



## Débuts des tickets Sprint 1 : 
