#! /usr/bin/env bash

sudo su
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils openssl-devel zlib-devel pcre-devel gcc gcc-c++
yum install -y glib2-devel e2fsprogs-devel slang-devel gpm-devel groff aspell-devel libssh2-devel
cd
wget http://vault.centos.org/7.5.1804/os/Source/SPackages/mc-4.8.7-11.el7.src.rpm
rpm -i ~/mc-4.8.7-11.el7.src.rpm
yum-builddep ~/rpmbuild/SPECS/mc.spec
rpmbuild -bb ~/rpmbuild/SPECS/mc.spec
yum localinstall -y ~/rpmbuild/RPMS/x86_64//mc-4.8.7-11.el7.x86_64.rpm
touch /etc/yum.repos.d/nginx.repo
echo '[nginx-stable]' >> /etc/yum.repos.d/nginx.repo
echo 'name=nginx stable repo' >> /etc/yum.repos.d/nginx.repo
echo 'baseurl=http://nginx.org/packages/centos/$releasever/$basearch/' >> /etc/yum.repos.d/nginx.repo
echo 'gpgcheck=0' >> /etc/yum.repos.d/nginx.repo
echo 'enabled=1' >> /etc/yum.repos.d/nginx.repo
yum install -y nginx
systemctl start nginx
mkdir /usr/share/nginx/html/repo
cp ~/rpmbuild/RPMS/x86_64/mc-4.8.7-11.el7.x86_64.rpm /usr/share/nginx/html/repo
createrepo /usr/share/nginx/html/repo/
N=11; sed -e $N"s/^/        autoindex on;\n/" -i /etc/nginx/conf.d/default.conf
nginx -t
nginx -s reload
rm -rf /usr/share/nginx/html/repo/repodata


