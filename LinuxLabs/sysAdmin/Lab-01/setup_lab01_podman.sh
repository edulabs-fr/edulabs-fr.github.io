#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# prepare_lab.sh — Version autonome pour conteneur non privilégié
# ---------------------------------------------------------------------------

set -euo pipefail

# Ne teste pas EUID — inutile dans un conteneur de dev
# need_root() { (( EUID == 0 )) || { echo "Run as root." >&2; exit 1; }; }

write() {
  local path="$1" mode="${2:-0644}" tmp
  tmp=$(mktemp); cat >"$tmp"
  install -D -m "$mode" "$tmp" "$path"
  rm -f "$tmp"
}

main() {
  export DEBIAN_FRONTEND=noninteractive

  # 1. Installation de base (facultatif si tout est en image)
  apt-get update -qq && apt-get install -yqq --no-install-recommends \
    acl sudo tree jq git vim zip tar openssh-client

  # 2. Groupes fictifs (inutiles si pas de sudo ou ACL spécifiques)
  for g in marketing dev hr ops sftp-ext; do
    groupadd -f "$g" || true
  done

  # 3. Répertoires de lab dans /lab
  install -d -o root -g root -m 0755 /lab /lab/depts /lab/projects
  for g in marketing dev hr ops; do
    install -d -o root -g "$g" -m 0770 "/lab/depts/$g"
    install -d -o root -g "$g" -m 0740 "/lab/depts/$g/share"
  done
  for p in siteweb apimobile dataviz; do
    install -d -o root -g dev -m 0775 "/lab/projects/$p"
  done

  # 5. Arborescence lab
  install -d -m 0755 /opt/labs/{bin,tickets/{sprint1,incidents}}

  # Incidents (adaptés pour conteneur)
  write /opt/labs/bin/prepare_inc01.sh 0755 <<'SH'
#!/usr/bin/env bash
chmod 0740 /lab/depts/marketing/share
SH

  write /opt/labs/bin/fix_inc01.sh 0755 <<'SH'
#!/usr/bin/env bash
chmod 2770 /lab/depts/marketing/share
SH

  write /opt/labs/bin/prepare_inc02.sh 0755 <<'SH'
#!/usr/bin/env bash
dir=/lab/depts/marketing/share
mkdir -p "$dir"
for n in {01..08}; do
  touch "$dir/fichier$n"
done
chmod g+rwx "$dir"
chmod -t    "$dir"
SH

  write /opt/labs/bin/fix_inc02.sh 0755 <<'SH'
#!/usr/bin/env bash
chmod +t /lab/depts/marketing/share
SH

  write /opt/labs/bin/prepare_inc03.sh 0755 <<'SH'
#!/usr/bin/env bash
echo "[INC-03] Simulation : blocage d'une commande sensible"
touch /opt/labs/tickets/incidents/shadow.locked
SH

  write /opt/labs/bin/fix_inc03.sh 0755 <<'SH'
#!/usr/bin/env bash
rm -f /opt/labs/tickets/incidents/shadow.locked
echo "[INC-03] Simulation annulée"
SH

  write /opt/labs/bin/prepare_inc04.sh 0755 <<'SH'
#!/usr/bin/env bash
echo "Simulation de mauvaise config SSH (fichier public trop ouvert)"
mkdir -p /home/labuser/.ssh
touch /home/labuser/.ssh/authorized_keys
chmod 0666 /home/labuser/.ssh/authorized_keys
SH

  write /opt/labs/bin/fix_inc04.sh 0755 <<'SH'
#!/usr/bin/env bash
chmod 600 /home/labuser/.ssh/authorized_keys
chown labuser:labuser /home/labuser/.ssh/authorized_keys
SH

  # Aliases globaux
  for i in 01 02 03 04; do
    ln -sf "/opt/labs/bin/prepare_inc${i}.sh" "/usr/local/bin/go-incident${i}"
    ln -sf "/opt/labs/bin/fix_inc${i}.sh"     "/usr/local/bin/stop-incident${i}"
    chmod +x "/usr/local/bin/go-incident${i}" "/usr/local/bin/stop-incident${i}"
  done

  echo "Lab prêt dans /lab — Incidents prêts à simuler !"
}

main "$@"