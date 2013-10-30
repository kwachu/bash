#!/bin/bash

# miejsce docelowe backupu
dest='/tmp/BU/backup'

# potrzebuje pliku: lista.txt z lista plikow/katalogow do backupowanie
function backupFiles() {
	echo "lista plików do backupu [OK]"
	lista=`cat lista.txt`
	arch=`date +%F`
	if [ -e "${arch}.tgz" ]; then
		echo "archiwum już istnieje: ${arch}.tgz"
		exit
	fi
	tar zcvf ${arch}.tgz ${lista} 2>&1 |grep "ok"
	if [ -e ${arch} ]; then
		echo "archiwum plików: ${arch}" 
	fi
}

# potrzebuje pliku: db.txt z lista baz do backupowanie
function backupDB() {
	echo "lista baz do backupu [OK]"
	for db in `cat db.txt |grep -v "###"`; do	
		dblogin=`echo $db |cut -f 1 -d","`
		dbpass=`echo $db |cut -f 2 -d","`
		dbhost=`echo $db |cut -f 3 -d","`
		dbname=`echo $db |cut -f 4 -d","`
		#echo "PASS: $dbpass"
		#echo "LOGI: $dblogin"
		#echo "HOST: $dbhost"
		#echo "DB: $dbname"
		mysqldump -u $dblogin -p$dbpass -h $dbhost $dbname >> ${dbname}.sql && echo "DB: $dbname [OK]"
	done
}






#MAIN
if [ -e lista.txt ]; then
	echo backupFiles
	echo "test"
else
	echo "Utwórz plik lista.txt z listą danych do backupu"	
fi

if [ -e db.txt ]; then
	backupDB
else
	echo "wczytanie listy baz do backupu - [FAIL]"
fi
