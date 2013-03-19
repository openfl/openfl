package flash.errors;
#if (flash || display)


@:native("TypeError") extern class TypeError extends Error {
}


#else
typedef TypeError = nme.errors.TypeError;
#end
