@echo off

set SCRIPT_FILE="ftp-script.txt"
del %SCRIPT_FILE% 2>NUL

echo open nme.io>> %SCRIPT_FILE%
echo %1>> %SCRIPT_FILE%
echo %2>> %SCRIPT_FILE%
echo binary>> %SCRIPT_FILE%
echo hash>> %SCRIPT_FILE%
echo put %3ndll\%4 ndll/%4>> %SCRIPT_FILE%
echo bye>> %SCRIPT_FILE%

@echo on

ftp -s:%SCRIPT_FILE% 

@del %SCRIPT_FILE% 2>NUL