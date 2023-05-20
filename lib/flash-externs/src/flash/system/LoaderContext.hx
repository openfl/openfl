package flash.system;

#if flash
import openfl.display.DisplayObjectContainer;

extern class LoaderContext
{
	#if (haxe_ver < 4.3)
	@:require(flash10_1) public var allowLoadBytesCodeExecution:Bool;
	#else
	@:flash.property @:require(flash10_1) var allowLoadBytesCodeExecution(get, set):Bool;
	#end

	@:require(flash10_1) public var allowCodeImport:Bool;
	public var applicationDomain:ApplicationDomain;
	public var checkPolicyFile:Bool;
	@:require(flash11) public var imageDecodingPolicy:flash.system.ImageDecodingPolicy;
	@:require(flash11) public var parameters:Dynamic;
	@:require(flash11) public var requestedContentParent:DisplayObjectContainer;
	public var securityDomain:SecurityDomain;

	public function new(checkPolicyFile:Bool = false, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null):Void;

	#if (haxe_ver >= 4.3)
	private function get_allowLoadBytesCodeExecution():Bool;
	private function set_allowLoadBytesCodeExecution(value:Bool):Bool;
	#end
}
#else
typedef LoaderContext = openfl.system.LoaderContext;
#end
