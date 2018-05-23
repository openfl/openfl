package openfl.system {
	
	
	import openfl.display.DisplayObjectContainer;
	
	
	/**
	 * @externs
	 */
	public class LoaderContext {
		
		
		public var allowCodeImport:Boolean;
		public var allowLoadBytesCodeExecution:Boolean;
		public var applicationDomain:ApplicationDomain;
		public var checkPolicyFile:Boolean;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public var imageDecodingPolicy:flash.system.ImageDecodingPolicy;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public var parameters:Dynamic;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public var requestedContentParent:DisplayObjectContainer;
		// #end
		
		public var securityDomain:SecurityDomain;
		
		
		public function LoaderContext (checkPolicyFile:Boolean = false, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null) {}
		
		
	}
	
	
}