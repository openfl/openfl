/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.system;
#if display


@:final extern class ApplicationDomain {
	var domainMemory : openfl.utils.ByteArray;
	var parentDomain(default,null) : ApplicationDomain;
	function new(?parentDomain : ApplicationDomain) : Void;
	function getDefinition(name : String) : openfl.utils.Object;
	function hasDefinition(name : String) : Bool;
	static var currentDomain(default,null) : ApplicationDomain;
}


#end