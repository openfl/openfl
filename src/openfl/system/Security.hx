package openfl.system; #if !flash


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class Security {
	
	
	// @:noCompletion @:dox(hide) @:require(flash10_1) public static var APPLICATION:String;
	
	public static inline var LOCAL_TRUSTED = "localTrusted";
	public static inline var LOCAL_WITH_FILE = "localWithFile";
	public static inline var LOCAL_WITH_NETWORK = "localWithNetwork";
	public static inline var REMOTE = "remote";
	
	public static var disableAVM1Loading:Bool;
	public static var exactSettings:Bool;
	
	// @:noCompletion @:dox(hide) @:require(flash11) public static var pageDomain (default, null):String;
	
	public static var sandboxType (default, null):String;
	
	
	public static function allowDomain (?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void {
		
		
		
	}
	
	
	public static function allowInsecureDomain (?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void {
		
		
		
	}
	
	
	// @:noCompletion @:dox(hide) @:require(flash10_1) public static function duplicateSandboxBridgeInputArguments (toplevel:Dynamic, args:Array<Dynamic>):Array<Dynamic>;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public static function duplicateSandboxBridgeOutputArgument (toplevel:Dynamic, arg:Dynamic):Dynamic;
	
	
	public static function loadPolicyFile (url:String):Void {
		
		//var res = haxe.Http.requestUrl( url );
		
	}
	
	
	// @:noCompletion @:dox(hide) public static function showSettings (panel:flash.system.SecurityPanel = null):Void;
	
	
}


#else
typedef Security = flash.system.Security;
#end