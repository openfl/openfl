package openfl.errors; #if (display || !flash)


@:jsRequire("openfl/errors/ArgumentError", "default")

extern class ArgumentError extends Error {}


#else
typedef ArgumentError = flash.errors.ArgumentError;
#end