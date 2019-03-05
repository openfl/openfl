package flash.system;

#if flash
import openfl.utils.ByteArray;
import openfl.utils.Object;

@:final extern class ApplicationDomain
{
	#if flash
	@:require(flash10) public static var MIN_DOMAIN_MEMORY_LENGTH(default, never):UInt;
	#end
	public static var currentDomain(default, never):ApplicationDomain;
	#if flash
	@:require(flash10) public var domainMemory:ByteArray;
	#end
	public var parentDomain(default, never):ApplicationDomain;
	public function new(parentDomain:ApplicationDomain = null);
	public function getDefinition(name:String):Dynamic;
	#if flash
	@:require(flash11_3) function getQualifiedDefinitionNames():flash.Vector<String>;
	#end
	public function hasDefinition(name:String):Bool;
}
#else
typedef ApplicationDomain = openfl.system.ApplicationDomain;
#end
