##Create project dir and change ownership.
mkdir /postgres_test_project/ 

## Add system user postgres_user
adduser postgress --system -s /sbin/nologin -d /postgres_test_project/

##Create /postgres_test_project/data folder for
#persistent storage
mkdir /postgres_test_project/data

##Change /postgres_test_project/ ownership
chown postgress:postgress /postgres_test_project/

##Change ownership for data folder to give access
#official postgres user inside Postgress container.
chown -R 999:999 /postgres_test_project/data

##Add postgress user to docker group, to give access to docker socket. /var/run/docker.sock
usermod -aG docker postgress 


##Create service file, runs under system user postgres_user.
vim /etc/systemd/system/postgress_container.service

##Deploy 
systemctl enable docker.service --now
systemctl status docker.service
systemctl enable postgress_container.service --now	
systemctl status postgress_container.service

##Allow port 5443 on firewall cmd for pgadmin GUI access from Windows Hostmachine.
firewall-cmd --add-port 5432/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-port

##Check it out.
ss --tulpn
