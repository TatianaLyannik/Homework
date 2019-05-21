#!/bin/bash

# Задаем переменную окружения, чтобы не писать до исполняемых файлов полный путь
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin										

# Временный файл, в который будем сохранять результаты парсинга лога безопасности
tmpFile=/tmp/secure

# Находим в файле /var/log/secure все строки, в которых есть упоминание о неправильном вводе логина и пароля (Failed password). Удаляем двойные пробелы (tr), так как они нам будут мешать при парсинге по пробелу. Парсим строку по пробелам и извлекаем поля 3, 11, 13 — получаем время, логин и IP, с которого пытаемся ввести пароль неправильно. Все записываем в файл /tmp/secure.
cat /var/log/secure | grep 'Failed password' | tr -s ' ' | cut -d ' ' -f3,11,13 > $tmpFile		

# В переменную resultAnalis	записываем результат чтения количества строк в файле /tmp/secure.
resultAnalis=$(cat $tmpFile | wc -l)

# Если количество строк в файле /tmp/secure больше 0, то есть неправильные вводы пароля и нужно отправить письмо администратору.
if [ $resultAnalis -gt 0 ]
then
    echo 'Password failed has been detected' | mail -a $tmpFile -s 'Password failed' T.Lyannik@yandex.ru
fi
