package openfl.system; #if (!display && !flash)


class LoaderContext {
	
	
	public var allowCodeImport:Bool;
	public var allowLoadBytesCodeExecution:Bool;
	public var applicationDomain:ApplicationDomain;
	public var checkPolicyFile:Bool;
	public var securityDomain:SecurityDomain;
	
	
	public function new (checkPolicyFile:Bool = false, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null):Void {
		
		this.checkPolicyFile = checkPolicyFile;
		this.securityDomain = securityDomain;
		this.applicationDomain = applicationDomain;
		
		allowCodeImport = true;
		allowLoadBytesCodeExecution = true;
		
	}
	
	
}


#else


import openfl.display.DisplayObjectContainer;

#if flash
@:native("flash.system.LoaderContext")
#end


extern class LoaderContext {
	
	
	#if flash
	@:require(flash10_1)
	#end
	public var allowCodeImport:Bool;
	
	#if flash
	@:require(flash10_1)
	#end
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


#end