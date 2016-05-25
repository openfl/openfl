package openfl.system; #if (display || !flash)


extern class Security {
	
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public static var APPLICATION:String;
	#end
	
	public static inline var LOCAL_TRUSTED = "localTrusted";
	public static inline var LOCAL_WITH_FILE = "localWithFile";
	public static inline var LOCAL_WITH_NETWORK = "localWithNetwork";
	public static inline var REMOTE = "remote";
	
	public static var disableAVM1Loading:Bool;
	public static var exactSettings:Bool;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public static var pageDomain (default, null):String;
	#end
	
	public static var sandboxType (default, null):String;
	
	
	public static function allowDomain (?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	public static function allowInsecureDomain (?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public static function duplicateSandboxBridgeInputArguments (toplevel:Dynamic, args:Array<Dynamic>):Array<Dynamic>;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public static function duplicateSandboxBridgeOutputArgument (toplevel:Dynamic, arg:Dynamic):Dynamic;
	#end
	
	public static function loadPolicyFile (url:String):Void;
	
	#if flash
	@:noCompletion @:dox(hide) public static function showSettings (panel:flash.system.SecurityPanel = null):Void;
	#end
	
	
}


#else
typedef Security = flash.system.Security;
#end