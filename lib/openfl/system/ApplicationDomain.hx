package openfl.system; #if (display || !flash)


import openfl.utils.ByteArray;
import openfl.utils.Object;

@:jsRequire("openfl/system/ApplicationDomain", "default")


@:final extern class ApplicationDomain {
	
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var MIN_DOMAIN_MEMORY_LENGTH (default, null):UInt;
	#end
	
	public static var currentDomain (default, null):ApplicationDomain;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var domainMemory:ByteArray;
	#end
	
	public var parentDomain (default, null):ApplicationDomain;
	
	
	public function new (parentDomain:ApplicationDomain = null);
	public function getDefinition (name:String):Dynamic;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) function getQualifiedDefinitionNames() : flash.Vector<String>;
	#end
	
	public function hasDefinition (name:String):Bool;
	
	
}


#else
typedef ApplicationDomain = flash.system.ApplicationDomain;
#end