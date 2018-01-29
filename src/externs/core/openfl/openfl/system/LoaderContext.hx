package openfl.system; #if (display || !flash)


import openfl.display.DisplayObjectContainer;


extern class LoaderContext {
	
	
	public var allowCodeImport:Bool;
	public var allowLoadBytesCodeExecution:Bool;
	public var applicationDomain:ApplicationDomain;
	public var checkPolicyFile:Bool;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public var imageDecodingPolicy:flash.system.ImageDecodingPolicy;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public var parameters:Dynamic;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public var requestedContentParent:DisplayObjectContainer;
	#end
	
	public var securityDomain:SecurityDomain;
	
	
	public function new (checkPolicyFile:Bool = false, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null):Void;
	
	
}


#else
typedef LoaderContext = flash.system.LoaderContext;
#end