package flash.errors;
#if (flash || display)


extern class Error #if !flash_strict implements Dynamic #end {
	var errorID(default,null) : Int;
	var message : Dynamic;
	var name : Dynamic;
	function new(?message : Dynamic, id : Dynamic = 0) : Void;
	function getStackTrace() : String;
	static var length : Int;
	static function getErrorMessage(index : Int) : String;
	static function throwError(type : Class<Dynamic>, index : Int, ?p1 : Dynamic, ?p2 : Dynamic, ?p3 : Dynamic, ?p4 : Dynamic, ?p5 : Dynamic) : Dynamic;
}


#end
