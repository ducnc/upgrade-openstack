# upgrade-openstack

http://docs.openstack.org/openstack-ops/content/upgrade-icehouse-juno.html 

The following order for service upgrades seems the most successful:

	1. Upgrade the OpenStack Identity Service (keystone).

	2. Upgrade the OpenStack Image service (glance).

	3. Upgrade OpenStack Compute (nova), including networking components.

	4. Upgrade OpenStack Block Storage (cinder).

	5. Upgrade the OpenStack dashboard.


The general upgrade process includes the following steps:

	1. Create a backup of configuration files and databases.

	2. Update the configuration files according to the release notes.

	3. Upgrade the packages by using your distribution's package manager.

	4. Stop services, update database schemas, and restart services.

	5. Verify proper operation of your environment.


###check version sau khi update

```sh
apt-get install apt-show-versions

apt-show-versions neutron-plugin-ml2 neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent
```

I. Upgare toan bo node Controller


1. Cách thức thực hiện

- Dựng Controller mới theo script Juno, chú ý để IP khác IP của controller cũ, sử dụng hostname (controller, network,...) khi khai báo endpoint, database,... không sử dụng IP

- Thực hiện backup cấu hình các thành phần trong Controller cũ, stop các dịch vụ, backup database

- Chuyển dữ liệu bước bên trên sang Controller mới, chạy script

- Sau khi thực hiện xong, đổi IP thành IP của controller cũ, shutdown controller cũ

2. Các bước thực hiện (Upgare Controller từ IceHouse lên Juno)

- Thực hiện các script trong juno-ubuntu14.04 cho Controller mới

- Thực hiện script old_controller.sh trên Controller cũ

- Thực hiện script new_controller.sh trên Controller mới, shutdown controller cũ, sau đó đổi IP thành Controller cũ

- Restart nova-compute trên node Compute


II. Upgrade thanh phan

1. Upgrade neutron tren node Network

```sh
apt-get -y install ubuntu-cloud-keyring
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" "trusty-updates/juno main" > /etc/apt/sources.list.d/cloudarchive-juno.list
apt-get update -y
apt-show-versions neutron-plugin-ml2 neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent
apt-get -y install --only-upgrade neutron-plugin-ml2 neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent
service openvswitch-switch restart
service neutron-plugin-openvswitch-agent restart
service neutron-l3-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
```
