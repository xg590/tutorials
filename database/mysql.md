mysql_dbname=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 10 | head -n 1)
mysql_dbuser=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 10 | head -n 1)
mysql_dbpass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
apt -y update && apt install -y mariadb-server
# Configure Database
mysqladmin create $mysql_dbname
mysql $mysql_dbname << EOF
CREATE USER '$mysql_dbuser'@'localhost' IDENTIFIED BY '$mysql_dbpass';
GRANT ALL ON $mysql_dbname.* TO '$mysql_dbuser'@'localhost' IDENTIFIED BY '$mysql_dbpass' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
# Document Some Sensitive Info
cat << EOF > /root/mysql.info
MySQL Database Info:
  dbname    : $mysql_dbname
  dbuser    : $mysql_dbuser
  dbpassword: $mysql_dbpass
EOF
echo Done!
