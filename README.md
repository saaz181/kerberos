# Project Documentation: Phase 1 - Kerberos Server

## File Structure

```
phase1
|-- krb5.conf
|-- kdc.conf
|-- Dockerfile
|-- conf.sh
|-- kadm5.acl
```

### 1. **krb5.conf**

#### Description:

The `krb5.conf` file is the Kerberos V5 general configuration file. It defines default settings, realms, and domain-to-realm mappings.

#### Content:

```ini
# [libdefaults] section

# [realms] section
UNIVERSITY = {
    kdc = 172.17.0.2:88
    admin_server = 172.17.0.2:749
    default_domain = UNIVERSITY
}

# [domain_realm] section
.UNIVERSITY = UNIVERSITY
UNIVERSITY = UNIVERSITY
```

### 2. **kdc.conf**

#### Description:

The `kdc.conf` file configures the Kerberos Key Distribution Center (KDC). It specifies default realm settings and realm-specific configurations.

#### Content:

```ini
# [kdcdefaults] section

# [realms] section
UNIVERSITY = {
    database_module = UNIVERSITY
    kdc_ports = 88
    max_life = 10h 0m 0s
    max_renewable_life = 7d 0h 0m 0s
    master_key_type = des3-cbc-sha1
    supported_enctypes = des3-cbc-sha1
    default_principal_flags = +preauth
}
```

### 3. **Dockerfile**

#### Description:

The `Dockerfile` defines the Docker image for the Kerberos server. It installs necessary packages, copies configuration files, and sets up the Kerberos environment.

### 4. **conf.sh**

#### Description:

The `conf.sh` script contains Kerberos configuration commands, including keytab generation and policy setup.


## Usage Instructions

1. **Building the Docker Image:**
   ```bash
   sudo docker build -t kerberos-server ./phase1
   ```

2. **Running the Docker Container:**
   ```bash
   sudo docker run -d -p 88:88 -p 749:749 kerberos-server
   ```

3. **Initializing the Kerberos Database:**
   ```bash
   # Example: Initialize the KDC database with a master password
   sudo docker exec -it <container_id> kdb5_util create -s -r UNIVERSITY
   ```

4. **Adding Principals and Keytabs:**
   ```bash
   # Example: Add principals and generate keytabs
   sudo docker exec -it <container_id> /bin/bash conf.sh
   ```

## Notes

- Ensure proper firewall rules for ports 88 and 749.
- Update configurations as needed for your specific environment.


# Project Documentation: Phase 2 - Kerberos Authentication

**SERVERS:**
  - coffeserver/
    - coffeserver.py
    - Dockerfile
    - requirements.txt
  - swimserver/
    - swimserver.py
    - Dockerfile
    - requirements.txt


## Usage Instructions

To Build Docker image for swimserver/coffeserver:

**swimserver:**
```
sudo docker build -t swimserver phase2/swimserver
```

**coffeserver:**
```
sudo docker build -t coffeserver phase2/coffeserver
```

In both app that written using **Flask** it uses `flask_gssapi` to authenticate the users and the instruction for users
```
tu1
su1
tu2
su2
```
defined in `phase1->conf.sh`:
```bash

# hostname = 172.17.0.2
# encryption method = aes256-cts
# REALM = UNIVERSITY
addprinc -randkey -e aes256-cts coffeserver/172.17.0.2@UNIVERSITY  
addprinc -randkey -e aes256-cts swimserver/172.17.0.2@UNIVERSITY

ktadd -k coffeserver.keytab coffeserver/172.17.0.2@UNIVERSITY
ktadd -k swimserver.keytab swimserver/172.17.0.2@UNIVERSITY

ank -randkey tu1@UNIVERSITY
ank -randkey su1@UNIVERSITY
ank -randkey tu2@UNIVERSITY
ank -randkey su2@UNIVERSITY

xst -norandkey -k tu1.keytab tu1@UNIVERSITY
xst -norandkey -k su1.keytab su1@UNIVERSITY
xst -norandkey -k tu2.keytab tu2@UNIVERSITY
xst -norandkey -k su2.keytab su2@UNIVERSITY

ktadd -k tu1.keytab tu1@UNIVERSITY
ktadd -k su1.keytab su1@UNIVERSITY
ktadd -k tu2.keytab tu2@UNIVERSITY
ktadd -k su2.keytab su2@UNIVERSITY

addprinc -randkey -e aes256-cts coffeserver/172.17.0.2@UNIVERSITY
addprinc -randkey -e aes256-cts swimserver/172.17.0.2@UNIVERSITY

ktadd -k coffeserver.keytab coffeserver/172.17.0.2@UNIVERSITY
ktadd -k swimserver.keytab swimserver/172.17.0.2@UNIVERSITY

# ADD PRINCIPALS FOR users at UNIVERSITY
# for access to coffeserver and swimserver

addpol "coffeepolicy" "coffeserver/172.17.0.2@UNIVERSITY"
addpol "swimpolicy" "swimserver/172.17.0.2@UNIVERSITY"


# add principals to users
addprinc -randkey -e aes256-cts -policy coffeepolicy tu1@UNIVERSITY
addprinc -randkey -e aes256-cts -policy coffeepolicy su1@UNIVERSITY
addprinc -randkey -e aes256-cts -policy swimpolicy tu2@UNIVERSITY
addprinc -randkey -e aes256-cts -policy swimpolicy su2@UNIVERSITY

# add keytab to users
ktadd -k tu1.keytab tu1@UNIVERSITY
ktadd -k su1.keytab su1@UNIVERSITY
ktadd -k tu2.keytab tu2@UNIVERSITY
ktadd -k su2.keytab su2@UNIVERSITY
```

