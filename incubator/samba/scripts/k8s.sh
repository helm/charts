#!/bin/sh
#passwd files need to be stored on the persistent storage
if [ ! -f /privatepersist/etc/passwd ]; then
  mkdir -p /privatepersist/etc
  cp /etc/passwd /privatepersist/etc/passwd
fi
rm -f /etc/passwd
ln -s /privatepersist/etc/passwd /etc/passwd
#tdb files need to be stored on the persistent storage
if [ ! -f /privatepersist/varlibsamba/private/passdb.tdb ]; then
  mkdir /privatepersist/varlibsamba
  tar c -C /var/lib/samba . | tar x -C /privatepersist/varlibsamba
fi
rm -rf /var/lib/samba
ln -s /privatepersist/varlibsamba /var/lib/samba
#create required users
if ! md5sum -c /privatepersist/k8s-users-checksum > /dev/null 2>&1; then
  rm /var/lib/samba/private/passdb.tdb
  if [ -s /secrets/create-users ]; then
    for line in $(cat /secrets/create-users); do
      USER=$(echo $line | cut -f1 -d:)
      PASS=$(echo $line | cut -f2 -d:)
      adduser -s /sbin/nologin -h /home/samba -H -D $USER
      yes "$PASS" | smbpasswd -a $USER
    done
  fi
  md5sum /secrets/create-users > /privatepersist/k8s-users-checksum
fi
# bug where smbd stops on "end of input"
ionice -c 3 smbd --foreground --log-stdout < /dev/null