package flash.system;

#if flash
import openfl.utils.ByteArray;
import openfl.utils.Object;
import openfl.Vector;

@:final extern class ApplicationDomain
{
	#if (haxe_ver < 4.3)
	@:require(flash10) public static var MIN_DOMAIN_MEMORY_LENGTH(default, never):UInt;
	public static var currentDomain(default, never):ApplicationDomain;
	@:require(flash10) public var domainMemory:ByteArray;
	public var parentDomain(default, never):ApplicationDomain;
	#else
	@:flash.property @:require(flash10) static var MIN_DOMAIN_MEMORY_LENGTH(get, never):UInt;
	@:flash.property static var currentDomain(get, never):ApplicationDomain;
	@:flash.property @:require(flash10) var domainMemory(get, set):ByteArray;
	@:flash.property var parentDomain(get, never):ApplicationDomain;
	#end

	public function new(parentDomain:ApplicationDomain = null);
	public function getDefinition(name:String):Dynamic;
	@:require(flash11_3) function getQualifiedDefinitionNames():Vector<String>;
	public function hasDefinition(name:String):Bool;

	#if (haxe_ver >= 4.3)
	private function get_domainMemory():ByteArray;
	private function get_parentDomain():ApplicationDomain;
	private function set_domainMemory(value:ByteArray):ByteArray;
	private static function get_MIN_DOMAIN_MEMORY_LENGTH():UInt;
	private static function get_currentDomain():ApplicationDomain;
	#end
}
#else
typedef ApplicationDomain = openfl.system.ApplicationDomain;
#end
