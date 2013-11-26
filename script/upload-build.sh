#!/bin/bash

USER=$1
PASSWD=$2

ftp -n -v openfl.org << EOT
binary
user $USER $PASSWD
prompt
put $3ndll/$4 ndll/$4
bye
EOT