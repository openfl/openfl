#!/bin/bash

USER=$1
PASSWD=$2

ftp -n -v nme.io << EOT
binary
user $USER $PASSWD
prompt
put ndll/$3 ndll/$3
bye
EOT