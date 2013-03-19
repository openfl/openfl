package flash.errors;
#if (flash || display)


@:native("SecurityError") extern class SecurityError extends Error {
}


#else
typedef SecurityError = nme.errors.SecurityError;
#end
