# Lab examination (Part 02) — answer sheet / solution guide

This file is a **reference solution** for checking work after attempting [02-LAB-EXPERIMENT-PROJECT-LINUX-part02.md](./02-LAB-EXPERIMENT-PROJECT-LINUX-part02.md). It follows the required phase order and keeps names/paths that the brief marks as mandatory.

Replace sample values (hostnames, subnet, passwords, usernames where optional) with your own VM values.

**Security:** never include real passwords, private SSH keys, or secret tokens in evidence.

---

## Environment assumptions (same as lab story)

- **DB / App VM:** Ubuntu machine running project files, PostgreSQL, backup script, cron, and Nginx.
- **NFS VM:** separate Ubuntu machine exporting a backup directory.
- Both VMs are reachable on the same lab network/subnet.

Example placeholders used below:

- DB VM IP: `192.168.56.20`
- NFS VM IP: `192.168.56.21`
- Lab subnet rule examples: `192.168.56.0/24`
- Project tree under home: `~/linux-labs/part02-project`
- Collaboration group: `part02editors`

---

## Phase 1 — Project tree and permissions

### Valid implementation

```bash
# create a dedicated group
sudo groupadd part02editors

# create project tree under your own home directory
mkdir -p "$HOME/linux-labs/part02-project"
printf '<h1>Part02 docs placeholder</h1>\n' > "$HOME/linux-labs/part02-project/index.html"
printf 'Part02 working notes\n' > "$HOME/linux-labs/part02-project/README.txt"

# set ownership/group and restrictive permissions
chown -R "$USER":"$USER" "$HOME/linux-labs/part02-project"
chgrp -R part02editors "$HOME/linux-labs/part02-project"
chmod 750 "$HOME/linux-labs/part02-project"
chmod 640 "$HOME/linux-labs/part02-project/"*.{html,txt}
```

### Why this satisfies the policy

- Owner (`$USER`) has full control.
- Group members can enter directory (`x`) and read files (`r`).
- Others have no access to directory (`---` for others on `750`).

### Evidence checklist

- `ls -ld ~/linux-labs/part02-project`
- `ls -l ~/linux-labs/part02-project`

---

## Phase 2 — Extra disk and persistent mount

> Use an additional disk device only (example: `/dev/sdb`), not the OS disk.

### Valid implementation

```bash
# inspect block devices first
lsblk -f

# create filesystem on the extra disk (single filesystem)
sudo mkfs.ext4 /dev/sdb

# create mount point and mount it
sudo mkdir -p /mnt/part02-data
sudo mount /dev/sdb /mnt/part02-data

# collect stable UUID and persist in fstab
sudo blkid /dev/sdb
# then add a line like this in /etc/fstab:
# UUID=<your-uuid>  /mnt/part02-data  ext4  defaults  0  2

sudoedit /etc/fstab
sudo mount -a
findmnt /mnt/part02-data

# required marker file
printf 'PART02-DISK created %s\n' "$(date -Iseconds)" | sudo tee /mnt/part02-data/marker.txt
```

### Evidence checklist

- `lsblk -f` showing the extra device and filesystem.
- `findmnt /mnt/part02-data` or `mount | rg part02-data`.
- `cat /mnt/part02-data/marker.txt` showing `PART02-DISK`.
- `/etc/fstab` line for `/mnt/part02-data`.

---

## Phase 3 — PostgreSQL install, remote access, roles, data

### 1) Install and run service

```bash
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib
sudo systemctl enable --now postgresql
systemctl status postgresql --no-pager
```

### 2) Listen on lab network + pg_hba subnet rule

Edit PostgreSQL config files (path may vary by version, commonly `/etc/postgresql/16/main/` or similar):

- `postgresql.conf`:
  - `listen_addresses = '*'` (or a specific DB VM LAN IP)
- `pg_hba.conf`:
  - add subnet rule for lab network, for example:
    - `host    all    all    192.168.56.0/24    scram-sha-256`

Then reload/restart:

```bash
sudo systemctl restart postgresql
sudo ss -ltnp | rg 5432
```

### 3) Roles and database

```bash
sudo -u postgres psql <<'SQL'
CREATE ROLE dbadmin LOGIN SUPERUSER PASSWORD 'ChangeMe_DbAdmin!';
CREATE ROLE appuser LOGIN PASSWORD 'ChangeMe_AppUser!';
CREATE DATABASE appdb OWNER dbadmin;
SQL
```

### 4) Table + sample rows + least-privilege grants

```bash
sudo -u postgres psql -d appdb <<'SQL'
CREATE TABLE IF NOT EXISTS employees (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  team TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO employees (name, team) VALUES
('Nadia Rahman', 'Platform'),
('Arif Hossain', 'Operations');

GRANT CONNECT ON DATABASE appdb TO appuser;
GRANT USAGE ON SCHEMA public TO appuser;
GRANT SELECT ON TABLE employees TO appuser;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO appuser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO appuser;
SQL
```

### 5) Verify separation of privilege

```bash
# app data visible
psql -h 127.0.0.1 -U appuser -d appdb -c "SELECT * FROM employees;"

# appuser is not cluster superuser
sudo -u postgres psql -c "\du"
```

Evidence should clearly show `appuser` login role is not `SUPERUSER`.

---

## Phase 4 — NFS export (server) and mount (DB client)

### NFS server VM

```bash
sudo apt-get update
sudo apt-get install -y nfs-kernel-server
sudo mkdir -p /srv/nfs/pg-backups
sudo chown -R nobody:nogroup /srv/nfs/pg-backups
sudo chmod 0777 /srv/nfs/pg-backups
```

Add export entry in `/etc/exports` (example):

```text
/srv/nfs/pg-backups 192.168.56.0/24(rw,sync,no_subtree_check)
```

Apply:

```bash
sudo exportfs -ra
sudo exportfs -v
sudo systemctl enable --now nfs-kernel-server
```

### DB VM as NFS client

```bash
sudo apt-get update
sudo apt-get install -y nfs-common
sudo mkdir -p /mnt/nfs/pg-backups
sudo mount 192.168.56.21:/srv/nfs/pg-backups /mnt/nfs/pg-backups
findmnt /mnt/nfs/pg-backups
showmount -e 192.168.56.21
```

Persist mount in `/etc/fstab` (example):

```text
192.168.56.21:/srv/nfs/pg-backups  /mnt/nfs/pg-backups  nfs  defaults,_netdev  0  0
```

Then:

```bash
sudo mount -a
findmnt /mnt/nfs/pg-backups
```

Connectivity proof:

```bash
echo "nfs test $(date -Iseconds)" > /mnt/nfs/pg-backups/share-test.txt
```

Check that `share-test.txt` is visible from the NFS server path.

---

## Phase 5 — Required dump script with mandatory identifiers

Create: `~/linux-labs/part02/pg_dump_to_nfs.sh`

```bash
mkdir -p "$HOME/linux-labs/part02"
chmod 700 "$HOME/linux-labs/part02"
```

Script content:

```bash
#!/usr/bin/env bash
set -euo pipefail

NFS_DUMP_ROOT="/mnt/nfs/pg-backups"
PGDATABASE="appdb"
PG_OS_USER="postgres"
RUN_STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
ARCHIVE_PATH="${NFS_DUMP_ROOT}/${PGDATABASE}-${RUN_STAMP}.dump"
AUDIT_LOG="${HOME}/linux-labs/part02/backup-audit.log"

mkdir -p "$(dirname "$AUDIT_LOG")"

if ! mountpoint -q "$NFS_DUMP_ROOT"; then
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) ERROR nfs-not-mounted root=${NFS_DUMP_ROOT}" | tee -a "$AUDIT_LOG" >&2
  exit 1
fi

sudo -u "$PG_OS_USER" pg_dump -Fc -d "$PGDATABASE" -f "$ARCHIVE_PATH"
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) SUCCESS dump=${ARCHIVE_PATH}" >> "$AUDIT_LOG"
```

Make executable and run:

```bash
chmod +x "$HOME/linux-labs/part02/pg_dump_to_nfs.sh"
"$HOME/linux-labs/part02/pg_dump_to_nfs.sh"
tail -n 20 "$HOME/linux-labs/part02/backup-audit.log"
ls -lh /mnt/nfs/pg-backups/*.dump
```

This satisfies all mandatory identifier rules:

- `NFS_DUMP_ROOT=/mnt/nfs/pg-backups`
- `PGDATABASE=appdb`
- `PG_OS_USER` used to run dump
- `RUN_STAMP` uses exact UTC format
- `ARCHIVE_PATH` ends with `.dump`
- `AUDIT_LOG=$HOME/linux-labs/part02/backup-audit.log`

---

## Phase 6 — User cron with HEARTBEAT log

Requirement says log must be under the Phase 1 project directory.

Example heartbeat script:

```bash
cat > "$HOME/linux-labs/part02/heartbeat.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) HEARTBEAT" >> "$HOME/linux-labs/part02-project/heartbeat.log"
EOF

chmod +x "$HOME/linux-labs/part02/heartbeat.sh"
```

Add user crontab entry (every 5 minutes):

```bash
crontab -e
```

Add:

```text
*/5 * * * * /bin/bash /home/<your-user>/linux-labs/part02/heartbeat.sh
```

Verify:

```bash
crontab -l
tail -n 20 "$HOME/linux-labs/part02-project/heartbeat.log"
```

Wait for multiple schedule intervals before taking screenshot evidence.

---

## Phase 7 — Nginx static routing requirements

### Site files

```bash
sudo apt-get update
sudo apt-get install -y nginx

sudo mkdir -p /var/www/part02-site
printf '<h1>Part02 Home</h1>\n' | sudo tee /var/www/part02-site/index.html >/dev/null
printf '<h1>Part02 FAQ</h1>\n' | sudo tee /var/www/part02-site/faq.html >/dev/null
printf '<h1>Part02 Team</h1>\n' | sudo tee /var/www/part02-site/team.html >/dev/null
```

### Nginx server block example

Create `/etc/nginx/sites-available/part02`:

```nginx
server {
    listen 80;
    server_name _;

    root /var/www/part02-site;
    index index.html;

    location = /home {
        try_files /index.html =404;
    }

    location / {
        try_files $uri $uri.html $uri/ =404;
    }
}
```

Enable and test:

```bash
sudo ln -sf /etc/nginx/sites-available/part02 /etc/nginx/sites-enabled/part02
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

Validation:

```bash
curl -I http://127.0.0.1/
curl -I http://127.0.0.1/home
curl -I http://127.0.0.1/faq
curl -I http://127.0.0.1/team
curl -I http://127.0.0.1/secret
```

Expected:

- `/`, `/home`, `/faq`, `/team` -> 200 (or other successful 2xx for your config)
- `/secret` -> 404

---

## Phase 8 — Concept memo model answers

### 1) Mountpoint check before backup

Checking `mountpoint` is safer because a plain directory can still exist even when the NFS share is down. If backup code only checks directory existence, it may write dump files to the local root filesystem path (for example `/mnt/nfs/pg-backups` as an unmounted folder) instead of the remote share. That creates a false sense of successful backup, consumes local disk unexpectedly, and leaves no copy on the backup server where restore operations expect it.

### 2) `try_files $uri $uri.html $uri/ =404;` for `/faq`

For `/faq`, Nginx first checks whether a file exactly matching `$uri` exists under `root` (for example `/var/www/part02-site/faq`). If not found, it tries `$uri.html` (for example `/var/www/part02-site/faq.html`), which succeeds in this lab and is returned. If that also failed, it would try `$uri/` as a directory path, and if none matched it would return `404` by the final `=404`.

### 3) Interactive shell vs cron differences

Cron runs with a minimal non-interactive environment, so scripts that work in a terminal can fail under cron. Common causes include missing `PATH` entries (commands found interactively but not in cron) and missing environment variables (like `HOME`, custom exports, virtualenv variables, or DB-related vars set in `.bashrc`). Working directory assumptions also break often because cron starts jobs from a different default directory unless paths are absolute.

---

## Evidence pack quick checklist

- Phase 1: owner/group/mode proof for directory and files.
- Phase 2: extra disk, active mount `/mnt/part02-data`, marker file, `fstab` entry.
- Phase 3: Postgres running, listen + `pg_hba` subnet rule, roles/db/table/data/grants.
- Phase 4: export on NFS server + client mount `/mnt/nfs/pg-backups` + persistent fstab + shared test file.
- Phase 5: script screenshot (first lines with six variables), run result, audit log, `.dump` file on NFS mount.
- Phase 6: user `crontab -l` + multiple timestamped `HEARTBEAT` lines.
- Phase 7: `nginx -t` clean + `curl -I` responses for required paths.
- Phase 8: three paragraph answers in own words.

---

*End of Part 02 solution guide.*
