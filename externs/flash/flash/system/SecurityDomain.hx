package flash.system;

#if flash
extern class SecurityDomain
{
	public static var currentDomain(default, never):SecurityDomain;
	#if flash
	@:require(flash11_3) public var domainID(default, never):String;
	#end
	private function new();
}
#else
typedef SecurityDomain = openfl.system.SecurityDomain;
#end
