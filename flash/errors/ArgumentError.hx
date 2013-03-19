package flash.errors;
#if (flash || display)


@:native("ArgumentError") extern class ArgumentError extends Error {
}


#else
typedef ArgumentError = nme.errors.ArgumentError;
#end
