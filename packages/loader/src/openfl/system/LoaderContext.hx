package openfl.system;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class LoaderContext
{
	public var allowCodeImport:Bool;
	public var allowLoadBytesCodeExecution:Bool;
	public var applicationDomain:ApplicationDomain;
	public var checkPolicyFile:Bool;

	#if false
	// @:noCompletion @:dox(hide) @:require(flash11) public var imageDecodingPolicy:openfl.system.ImageDecodingPolicy;
	#end
	#if false
	// @:noCompletion @:dox(hide) @:require(flash11) public var parameters:Dynamic;
	#end
	#if false
	// @:noCompletion @:dox(hide) @:require(flash11) public var requestedContentParent:DisplayObjectContainer;
	#end
	public var securityDomain:SecurityDomain;

	public function new(checkPolicyFile:Bool = false, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null):Void
	{
		this.checkPolicyFile = checkPolicyFile;
		this.securityDomain = securityDomain;
		this.applicationDomain = applicationDomain;

		allowCodeImport = true;
		allowLoadBytesCodeExecution = true;
	}
}
#else
typedef LoaderContext = flash.system.LoaderContext;
#end
