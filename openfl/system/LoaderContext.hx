/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.system;
#if display


extern class LoaderContext {
	@:require(flash10_1) var allowCodeImport : Bool;
	@:require(flash10_1) var allowLoadBytesCodeExecution : Bool;
	var applicationDomain : ApplicationDomain;
	var checkPolicyFile : Bool;
	@:require(flash11) var imageDecodingPolicy : ImageDecodingPolicy;
	@:require(flash11) var parameters : Dynamic;
	@:require(flash11) var requestedContentParent : openfl.display.DisplayObjectContainer;
	var securityDomain : SecurityDomain;
	function new(checkPolicyFile : Bool = false, ?applicationDomain : ApplicationDomain, ?securityDomain : SecurityDomain) : Void;
}


#end