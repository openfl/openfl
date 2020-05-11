package openfl.system;

#if !flash
/**
	The SecurityDomain class represents the current security "sandbox," also
	known as a security domain. By passing an instance of this class to
	`Loader.load()`, you can request that loaded media be placed in a
	particular sandbox.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:UnnecessaryConstructor")
class SecurityDomain
{
	/**
		Gets the current security domain.
	**/
	public static var currentDomain(get, never):SecurityDomain;

	// @:noCompletion @:dox(hide) @:require(flash11_3) public var domainID (default, null):String;
	@:allow(openfl) @:noCompletion private function new() {}

	// Get & Set Methods

	@:noCompletion private static function get_currentDomain():SecurityDomain
	{
		return _SecurityDomain.currentDomain;
	}
}
#else
typedef SecurityDomain = flash.system.SecurityDomain;
#end
