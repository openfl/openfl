package openfl.system; #if !flash


class Security {
	
	
	public static var LOCAL_TRUSTED:String;
	public static var LOCAL_WITH_FILE:String;
	public static var LOCAL_WITH_NETWORK:String;
	public static var REMOTE:String;
	public static var disableAVM1Loading:Bool;
	public static var exactSettings:Bool;
	public static var sandboxType (default, null):String;
	
	
	public static function allowDomain (?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic) { }
	public static function allowInsecureDomain (?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic) { }
	
	
	public static function loadPolicyFile (url:String) {
		
		//var res = haxe.Http.requestUrl( url );
		
	}
	
	
}


#else
typedef Security = flash.system.Security;
#end