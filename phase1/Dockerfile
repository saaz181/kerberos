# Use a base image with the desired operating system
FROM ubuntu:latest


# Install necessary packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y krb5-kdc krb5-admin-server expect

RUN apt-get install -y nano

# Copy Kerberos configuration files
COPY krb5.conf /etc/krb5.conf
COPY kdc.conf /etc/krb5kdc/kdc.conf
COPY kadm5.acl /etc/krb5kdc/kadm5.acl

# Use expect to automate the interactive input for kdb5_util create
RUN echo '#!/usr/bin/expect -f' > /tmp/expect_script && \
    echo 'set timeout -1' >> /tmp/expect_script && \
    echo 'spawn kdb5_util create -s -r UNIVERSITY' >> /tmp/expect_script && \
    echo 'expect "Enter KDC database master key:"' >> /tmp/expect_script && \
    echo 'send -- "YOUR_MASTER_PASSWORD\n"' >> /tmp/expect_script && \
    echo 'expect "Re-enter KDC database master key to verify:"' >> /tmp/expect_script && \
    echo 'send -- "YOUR_MASTER_PASSWORD\n"' >> /tmp/expect_script && \
    echo 'expect eof' >> /tmp/expect_script && \
    chmod +x /tmp/expect_script && \
    /tmp/expect_script && \
    rm /tmp/expect_script

# Add users to the Kerberos database
RUN kadmin.local -q "addprinc -randkey su1/student@UNIVERSITY" && \
    kadmin.local -q "addprinc -randkey su2/student@UNIVERSITY" && \
    kadmin.local -q "addprinc -randkey tu1/teacher@UNIVERSITY" && \
    kadmin.local -q "addprinc -randkey tu2/teacher@UNIVERSITY"

# Create a script to start the Kerberos services
RUN echo '#!/bin/bash' > /start_services.sh && \
    echo '/usr/sbin/krb5kdc -n &' >> /start_services.sh && \
    echo '/usr/sbin/kadmind -nofork' >> /start_services.sh && \
    chmod +x /start_services.sh

# Expose Kerberos ports
EXPOSE 88 749

# Start the Kerberos KDC and admin server using the script
CMD ["/start_services.sh"]
