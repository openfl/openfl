package openfl.system;

#if (display || !flash)
@:jsRequire("openfl/system/SecurityDomain", "default")
extern class SecurityDomain
{
	public static var currentDomain(default, null):SecurityDomain;
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public var domainID(default, null):String;
	#end
	// private function new() {}
}
#else
typedef SecurityDomain = flash.system.SecurityDomain;
#end
