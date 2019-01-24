#!/bin/bash
# This scirpt disable SE Linux, install mysql client and create TitoDB

##### Variables
db_name=TitoDB
db_password=Tito2016
db_username=root
init_db_password=Tito2016
init_db_username=root
init_db=$1

echo
echo "####### BIND VARIABLES #######"
echo 'db_name=$db_name' > tito_db.script
echo 'db_username=$db_username' >> tito_db.script
echo 'db_password=$db_password' >> tito_db.script
echo 'init_db_username=$init_db_username' >> tito_db.script
echo 'init_db_password=$init_db_password' >> tito_db.script
echo 'init_db=$init_db' >> tito_db.script
echo "##############################"

##### Dsiable SE Linux
sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux && cat /etc/sysconfig/selinux

##### Install mysql and configure client
yum install -y mysql

cat > ~/.my.cnf <<EOF
[mysql]
user = '$init_db_username'
password = '$init_db_password'
EOF

chmod 600 ~/.my.cnf

##### Write MySQL Script to create DB

cat > $db_name.sql <<EOF

create database if not exists TitoDB;
use TitoDB;

CREATE TABLE TitoTable (id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY, home VARCHAR(50) NOT NULL, work VARCHAR(50) NOT NULL, hour_home_departure VARCHAR(50) NOT NULL, hour_work_departure VARCHAR(50) NOT NULL)

EOF

##### Run Script
echo
echo "STARTUP SCRIPT mysql -u ....."
#   OLD NOOK - mysql -u$init_db_username -p$init_db_password  <  $db_name.sql   # NOOK

#	OLD NOOK - mysql --user=$init_db_username --password=$init_db_password < $db_name.sql    # OK

mysql -u$init_db_username -h$init_db < $db_name.sql

echo
echo "TitoDB creation script end"
