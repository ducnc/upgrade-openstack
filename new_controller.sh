#!/bin/bash -ex

#######################
### New Controller  ###
#######################

PASS='Welcome123'
OLDCTL='172.16.69.31'
NEWCTL='172.16.69.246'


# Upgrade Keystone
echo "Upgrade Keystone"

service keystone stop
cat << EOF | mysql -uroot -p$PASS
DROP DATABASE IF EXISTS keystone;
DROP DATABASE IF EXISTS glance;
DROP DATABASE IF EXISTS nova;
DROP DATABASE IF EXISTS neutron;
CREATE DATABASE nova;
CREATE DATABASE glance;
CREATE DATABASE keystone;
CREATE DATABASE neutron;
FLUSH PRIVILEGES;
EOF
#

cd backup/
mysql -u root -p$PASS keystone  < database-icehouse/icehouse-keystone-db-backup.sql
keystone-manage db_sync

service keystone start
source source /root/admin-openrc.sh


#Upgrade Glance
echo "Upgrade Glance"
for i in glance-api glance-registry; do service $i stop; done
mysql -u root -p$PASS glance < database-icehouse/icehouse-glance-db-backup.sql
glance-manage db_sync
for i in glance-api glance-registry; do service $i start; done


#Upgrade Nova
echo "Upgrade Nova"
for i in nova-cert nova-scheduler nova-consoleauth nova-conductor; do service $i stop; done
mysql -u root -p$PASS nova < database-icehouse/icehouse-nova-db-backup.sql
nova-manage db sync

echo "[upgrade_levels]" >> /etc/nova/nova.conf
echo "compute=icehouse" >> /etc/nova/nova.conf

for i in nova-cert nova-scheduler nova-consoleauth nova-conductor; do service $i start; done
service nova-api restart

#Upgrade Neutron
echo "Upgrade Neutron"
service neutron-server stop
mysql -u root -p$PASS neutron  < database-icehouse/icehouse-neutron-db-backup.sql
neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini stamp icehouse
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
--config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade juno" neutron
service neutron-server start


#Upgrade Horizon
#echo "Upgrade Horizon"
#sed -i 's\OPENSTACK_HOST = "127.0.0.1"\OPENSTACK_HOST = "$OLDCTL"\g' /etc/openstack-dashboard/local_settings.py

#Kiem tra cac service
echo "Kiem tra cac service"
sleep 5
echo "Kiem tra keystone endpoint-list"
keystone endpoint-list
echo "Kiem tra Nova"
nova-manage service list
echo "Kiem tra glance image-list"
glance image-list
echo "Kiem tra Neutron"
neutron agent-list


echo "Cai dat hoan tat. Chinh lai IP thanh IP Controller cu va tat Controller cu di, restart nova-compute !"
sleep 1
echo "Cai dat hoan tat. Chinh lai IP thanh IP Controller cu va tat Controller cu di, restart nova-compute !"
sleep 1
echo "Cai dat hoan tat. Chinh lai IP thanh IP Controller cu va tat Controller cu di, restart nova-compute !"
sleep 1
echo "Cai dat hoan tat. Chinh lai IP thanh IP Controller cu va tat Controller cu di, restart nova-compute !"
sleep 1
echo "Cai dat hoan tat. Chinh lai IP thanh IP Controller cu va tat Controller cu di, restart nova-compute !"
sleep 1
echo "Cai dat hoan tat. Chinh lai IP thanh IP Controller cu va tat Controller cu di, restart nova-compute !"
sleep 1
echo "Cai dat hoan tat. Chinh lai IP thanh IP Controller cu va tat Controller cu di, restart nova-compute !"
sleep 1