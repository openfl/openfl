package flash.errors;
#if (flash || display)


@:native("RangeError") extern class RangeError extends flash.errors.Error {
}


#else
typedef RangeError = nme.errors.RangeError;
#end
