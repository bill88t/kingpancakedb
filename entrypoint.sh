#!/bin/sh

for i in /pre-init.d/*.sh
do
	if [ -e "${i}" ]; then
		echo "NOTE: pre-init.d - $i"
		. "${i}"
	fi
done

if [ ! -d "/run/mysqld" ]; then
	echo "NOTE: mysqld not found, creating...."
	mkdir -p /run/mysqld
fi
chown -R mysql:mysql /run/mysqld

chown -R mysql:mysql /var/lib/mysql
if [ ! -d /var/lib/mysql/mysql ]; then
	echo "NOTE: MySQL data directory not found, creating initial DBs"
	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

	if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
		MYSQL_ROOT_PASSWORD=`pwgen 16 1`
		echo "WARN: MySQL root Password = \"$MYSQL_ROOT_PASSWORD\""
	fi

	MYSQL_DATABASE=${MYSQL_DATABASE:-""}
	MYSQL_USER=${MYSQL_USER:-""}
	MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

	tf=`mktemp`
	if [ ! -f "$tf" ]; then
	    return 1
	fi

	cat << EOF > $tf
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

	if [ "$MYSQL_DATABASE" != "" ]; then
	    echo "NOTE: Creating database, $MYSQL_DATABASE"
        echo "NOTE: with character set: 'utf8' and collation: 'utf8_general_ci'"
        echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tf

		if [ "$MYSQL_USER" != "" ]; then
			echo "NOTE: Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
			echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tf
		fi
	fi

	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $tf
	rm -f $tf

	echo -e '\nNOTE: MySQL init process done. Ready for start up.\n'
fi

for i in /pre-exec.d/*.sh
do
	if [ -e "${i}" ]; then
		echo "NOTE: pre-exec.d - $i"
		. ${i}
	fi
done

exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0
