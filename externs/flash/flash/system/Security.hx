package flash.system;

#if flash
extern class Security
{
	#if flash
	@:require(flash10_1) public static var APPLICATION(default, never):String;
	#end
	public static var LOCAL_TRUSTED(default, never):String;
	public static var LOCAL_WITH_FILE(default, never):String;
	public static var LOCAL_WITH_NETWORK(default, never):String;
	public static var REMOTE(default, never):String;
	public static var disableAVM1Loading:Bool;
	public static var exactSettings:Bool;
	#if flash
	@:require(flash11) public static var pageDomain(default, never):String;
	#end
	public static var sandboxType(default, never):String;
	public static function allowDomain(?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	public static function allowInsecureDomain(?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	#if flash
	@:require(flash10_1) public static function duplicateSandboxBridgeInputArguments(toplevel:Dynamic, args:Array<Dynamic>):Array<Dynamic>;
	#end
	#if flash
	@:require(flash10_1) public static function duplicateSandboxBridgeOutputArgument(toplevel:Dynamic, arg:Dynamic):Dynamic;
	#end
	public static function loadPolicyFile(url:String):Void;
	#if flash
	public static function showSettings(panel:flash.system.SecurityPanel = null):Void;
	#end
}
#else
typedef Security = openfl.system.Security;
#end
