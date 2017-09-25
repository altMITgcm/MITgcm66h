#!/bin/bash
#
# Set /etc/hosts on all containers in a set so they know about each other.
#
TPREF="foo"

# Set list of container names from command argument list
clist=$*

# Get list of IP addresses for container names passed as argument
(
for n in ${clist} ; do
 nn=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${n}`
 echo ${nn} ${n}
done
) > ${TPREF}_001.txt

# Get /etc/hosts for each containter in list
(
for n in ${clist} ; do
 echo '127.0.0.1 localhost' | cat - ${TPREF}_001.txt  | docker exec -i ${n} /bin/bash -c 'cat > /etc/hosts'
done
)

\rm ${TPREF}_001.txt
