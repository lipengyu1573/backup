#!/bin/bash
all=`cat ./configuration.cnf`
my_name=`more /etc/salt/minion | grep -v "^#" | grep -v "^$" | grep id | awk '{print $2}'`
my_task=`echo "$all" | grep "^$minion"`
storage_dir="/root/backups"
model_dir="/root/Backup/models/"

logger_new(){
    logger -s -t crontab_center -p local3.${1}
}

echo "$my_task" | while read line
do 
type=`echo "$line"|awk '{print $2}'`
if [ "$type" == "file" ] ;then
	echo "$line"| sed 's/[[:blank:]]\{2,\}/ /g' | cut -d ' ' -f3- | sed 's/\//\\\//g' > dir.tmp
	dir=`cat ./dir.tmp`
	rm -f ./dir.tmp
	cp my_backup.rb.model ./my_backup.rb
	for i in $dir
	do
		abc="archive.add     \"${i}\""
		sed -i "0,/archive.add/s/.*archive.add.*/&\n${abc}/" ./my_backup.rb
	done
    sed -i "s/backups_xiu/${my_name}/g" ./my_backup.rb
	mv ./my_backup.rb ${model_dir}
	abc=`backup perform --trigger my_backup 2>&1 `
	[ "$?" == "0" ] || echo "$abc" | logger_new err
elif [ "$type" == "mysql"  ] ;then
	db_name=`echo "$line" | awk '{print $3}'`
    db_user=`echo "$line" | awk '{print $4}'`
    db_passwd=`echo "$line" | awk '{print $5}'`
    db_port=`echo "$line" | awk '{print $6}'`
    echo "$line" | awk '{print $7}' | sed 's/\//\\\//g' > db_socket.tmp
    db_socket=`cat ./db_socket.tmp`
    rm -f ./db_socket.tmp	
	cp mysql_backup.rb.model ./mysql_${db_name}_backup.rb
	sed -i "s/mysql_backup/mysql_${db_name}_backup/g" ./mysql_${db_name}_backup.rb
	sed -i "s/my_database_name/${db_name}/g" ./mysql_${db_name}_backup.rb
    sed -i "s/my_username/${db_user}/" ./mysql_${db_name}_backup.rb
    sed -i "s/my_password/${db_passwd}/g" ./mysql_${db_name}_backup.rb
	[ "$db_port" == "" ] || sed -i "s/3306/${db_port}/g" ./mysql_${db_name}_backup.rb
	[ "$db_socket" == "" ] || sed -i "s/\/tmp\/mysql.sock/${db_socket}/g" ./mysql_${db_name}_backup.rb
	sed -i "s/backups_xiu/${my_name}/g" ./mysql_${db_name}_backup.rb
	mv ./mysql_${db_name}_backup.rb ${model_dir}
	abc=`backup  perform --trigger mysql_${db_name}_backup`
	[ "$?" == "0" ] || echo "$abc" | logger_new err
elif [ "$type" == "mongodb"  ] ;then
	db_name=`echo "$line" | awk '{print $3}'`
    db_user=`echo "$line" | awk '{print $4}'`
    db_passwd=`echo "$line" | awk '{print $5}'`
    db_port=`echo "$line" | awk '{print $6}'`
	cp mongodb_backup.rb.model ./mongodb_${db_name}_backup.rb
    sed -i "s/mongodb_backup/mongodb_${db_name}_backup/g" ./mongodb_${db_name}_backup.rb
    sed -i "s/my_database_name/${db_name}/g" ./mongodb_${db_name}_backup.rb
    sed -i "s/my_username/${db_user}/g" ./mongodb_${db_name}_backup.rb
    sed -i "s/my_password/${db_passwd}/" ./mongodb_${db_name}_backup.rb
	[ "$db_port" == "" ] || sed -i "s/5432/${db_port}/g" ./mongodb_${db_name}_backup.rb
	sed -i "s/backups_xiu/${my_name}/g" ./mongodb_${db_name}_backup.rb
	mv ./mongodb_${db_name}_backup.rb ${model_dir}
	abc=`backup  perform --trigger mongodb_${db_name}_backup`
	[ "$?" == "0" ] || echo "$abc" | logger_new err
elif [ "$type" == "redis"  ] ;then
    echo "$line" | awk '{print $3}' | sed 's/\//\\\//g'  > db_path.tmp
	db_path=`cat ./db_path.tmp`
	rm -f ./db_path.tmp
    db_passwd=`echo "$line" | awk '{print $4}'`
    db_port=`echo "$line" | awk '{print $5}'`
	echo "$line" | awk '{print $6}' | sed 's/\//\\\//g' > db_socket.tmp
    db_socket=`cat ./db_socket.tmp`
	rm -f ./db_socket.tmp
	cp redis_backup.rb.model ./redis_backup.rb
    sed -i "s/\/var\/lib\/redis\/dump.rdb/${db_path}/g" ./redis_backup.rb
    sed -i "s/my_password/${db_passwd}/g" ./redis_backup.rb
    sed -i "s/6379/${db_port}/g" ./redis_backup.rb
    sed -i "s/\/tmp\/redis.sock/${db_socket}/g" ./redis_backup.rb
    sed -i "s/backups_xiu/${my_name}/g" ./redis_backup.rb
    mv ./redis_backup.rb  ${model_dir}
	abc=`backup  perform --trigger redis_backup`
	[ "$?" == "0" ] || echo "$abc" | logger_new err
fi
echo "--------------------------------------------------------------------------------------------------"
done
