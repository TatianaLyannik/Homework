#!/bin/bash

# Задаем переменную окружения, чтобы не писать до исполняемых файлов полный путь
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# В переменной srvName задаем имя сервиса, работоспособность которого будем контролировать
srvName=smb

# В переменной pidFile задаем файл, в котором храним pid процесса проверяемого сервиса
pidFile=/run/smbd.pid

# Если файла pid нет, то сервис не работает. Необходимо его остановить (если он в зависшем состоянии и запустить снова. 
#Также нужно отправить сообщение администратору.
if [ ! -f $pidFile ]
then
    systemctl stop $srvName
    systemctl start $srvName
    echo "Service $srvName has been stopped. Restarting" | mail -s "Service Alert" T.Lyannik@yandex.ru
fi
