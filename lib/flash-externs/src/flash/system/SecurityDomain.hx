package flash.system;

#if flash
extern class SecurityDomain
{
	#if (haxe_ver < 4.3)
	@:require(flash11_3) public var domainID(default, never):String;
	public static var currentDomain(default, never):SecurityDomain;
	#else
	@:flash.property @:require(flash11_3) var domainID(get, never):String;
	@:flash.property static var currentDomain(get, never):SecurityDomain;
	#end

	private function new();

	#if (haxe_ver >= 4.3)
	private function get_domainID():String;
	private static function get_currentDomain():SecurityDomain;
	#end
}
#else
typedef SecurityDomain = openfl.system.SecurityDomain;
#end
