package flash.errors; #if (!display && flash)


@:native("ArgumentError") extern class ArgumentError extends Error {}


#else
typedef ArgumentError = openfl.errors.ArgumentError;
#end