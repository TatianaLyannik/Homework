#!/bin/bash

# Задаем переменную окружения, чтобы не писать до исполняемых файлов полный путь
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# В переменной marker храним путь до файла, который будет сигнализировать о том, что процесс еще идет
marker=/tmp/marker

# Временный файл, в который будем сохранять результаты парсинга лога безопасности
tmpFile=/tmp/secure

# Если маркерный файл существует, то значит предыдущий процесс еще не завершился и нужно прекратить выполнение скрипта командой exit.
if [ -f $marker ]
then
    exit 10
fi

# Создаем маркерный файл. Он будет сигнализировать, что процесс запустился
touch $marker

# Находим в файле /var/log/secure все строки, в которых есть упоминание о неправильном вводе логина и пароля (Failed password). 
#Удаляем двойные пробелы (tr), так как они нам будут мешать при парсинге по пробелу. 
#Парсим строку по пробелам и извлекаем поля 3, 11, 13 — получаем время, логин и IP, с которого пытаемся ввести пароль неправильно. 
#Все записываем в файл /tmp/secure.
cat /var/log/secure | grep 'Failed password' | tr -s ' ' | cut -d ' ' -f3,11,13 > $tmpFile

# В переменную resultAnalis	записываем результат чтения количества строк в файле /tmp/secure.
resultAnalis=$(cat $tmpFile | wc -l)

# Если количество строк в файле /tmp/secure больше 0, то есть неправильные вводы пароля и нужно отправить письмо.
if [ $resultAnalis -gt 0 ]
then
    echo 'Password failed has been detected' | mail -a $tmpFile -s 'Password failed' T.Lyannik@yandex.ru
fi

# Если маркерный файл есть, то удаляем его. Это тудет свидетельством того, что процесс завершился. 
if [ -f $marker ]
then
    rm $marker
fi
