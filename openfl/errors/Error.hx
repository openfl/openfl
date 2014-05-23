/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.errors;
#if display


extern class Error #if (flash && !flash_strict) implements Dynamic #end {
	var errorID(default,null) : Int;
	var message : Dynamic;
	var name : Dynamic;
	function new(?message : Dynamic, id : Dynamic = 0) : Void;
	function getStackTrace() : String;
}


#end
