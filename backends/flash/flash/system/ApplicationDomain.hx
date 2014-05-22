package flash.system;

/*
 It was not possible to override flash.Vector with a smarter abstract type, since this is 
 baked into genswf9.ml. Instead, we'll set classes that use flash.Vector to reference
 openfl.Vector instead.
*/

@:final extern class ApplicationDomain {
	@:require(flash10) var domainMemory : flash.utils.ByteArray;
	var parentDomain(default,null) : ApplicationDomain;
	function new(?parentDomain : ApplicationDomain) : Void;
	function getDefinition(name : String) : flash.utils.Object;
	@:require(flash11_3) function getQualifiedDefinitionNames() : openfl.Vector<String>;
	function hasDefinition(name : String) : Bool;
	@:require(flash10) static var MIN_DOMAIN_MEMORY_LENGTH(default,null) : UInt;
	static var currentDomain(default,null) : ApplicationDomain;
}
