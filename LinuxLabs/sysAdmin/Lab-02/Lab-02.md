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

### Option A — ISO (VM)
1. Créez une VM (2 vCPU, 2 Go RAM, 15 Go disque).
2. Démarrez sur l’ISO préparée, terminez l’installation.
3. Connectez-vous en root (ou via `sudo`).

### Option B — Docker (image tout-en-un)
```bash
docker run -it --name lab-linux \
  --hostname Lab-scen1 \
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
