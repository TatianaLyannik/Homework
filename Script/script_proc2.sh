#!/bin/sh
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

nice -n 20 dd if=/dev/urandom | nice -n 20 bzip2 -1 > /dev/null &
nice -n -19 dd if=/dev/urandom | nice -n -19 bzip2 -1 > /dev/null &

# Создадим файл лога. Внесем в него шапку команды top
echo "  PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM TIME+ COMMAND" > process.log

# Цикл из 10 итераций. В каждой мы смотрим состояние top - вытаскиваем значения для процесса bzip и сохраняем их в лог файл.
for ((i=1;i<=10;i++));
do
        echo $i
        echo "$i second:" >> process.log
        top -b -n 1 | grep bzip >> process.log
        echo "" >> process.log
        sleep 1
done

# Останавливаем процесс bzip2
kill `pgrep bzip2` 
