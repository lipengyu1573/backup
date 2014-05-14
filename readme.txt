任务列表文档格式：
1、文件备份：
minionid  file 路径  路径 （需要一次将需要备份的路径写全，否则最后一条备份会覆盖前面的备份）

2、mysql备份
minionid mysql dbname dbuser dbpasswd dbport dbsocket  （套接字项目可以不填，默认/tmp/mysql.sock，只支持单个数据库备份，需要备份多个数据库时，需要建立多个项目）

3、mongodb备份
minionid mongodb dbname dbuser dbpasswd dbport （只支持单个数据库备份，需要备份多个数据库时，需要建立多个项目）

4、redis备份
minionid redis dbpath dbpasswd dbport dbsocket  （套接字项目可以不填，默认/tmp/redis.sock )

每行一个任务，需要确保任务指令正确
