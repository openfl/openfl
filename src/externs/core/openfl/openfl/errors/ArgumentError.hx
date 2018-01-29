package openfl.errors; #if (display || !flash)


extern class ArgumentError extends Error {}


#else
typedef ArgumentError = flash.errors.ArgumentError;
#end