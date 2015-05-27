#!/bin/bash -ex

#######################
### Old Controller  ###
#######################

PASS='Welcome123'
NEWCTL='172.16.69.246'

service nova-api stop

mkdir backup && cd backup
for i in keystone glance nova neutron database openstack-dashboard; \
do mkdir $i-icehouse; \
done

for i in keystone glance nova neutron openstack-dashboard; \
do cp -r /etc/$i/* $i-icehouse/; \
done

mysqldump -u root -p$PASS keystone > database-icehouse/icehouse-keystone-db-backup.sql
mysqldump -u root -p$PASS glance > database-icehouse/icehouse-glance-db-backup.sql
mysqldump -u root -p$PASS nova > database-icehouse/icehouse-nova-db-backup.sql
mysqldump -u root -p$PASS neutron > database-icehouse/icehouse-neutron-db-backup.sql

cd ~
scp -r /var/lib/glance root@$NEWCTL:/var/lib/
scp -r /root/backup root@$NEWCTL:/root/

