package openfl.system;


class Security {
	
	
	public static inline var LOCAL_TRUSTED = "localTrusted";
	public static inline var LOCAL_WITH_FILE = "localWithFile";
	public static inline var LOCAL_WITH_NETWORK = "localWithNetwork";
	public static inline var REMOTE = "remote";
	
	public static var disableAVM1Loading:Bool;
	public static var exactSettings:Bool;
	public static var sandboxType (default, null):String;
	
	
	public static function allowDomain (?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void {
		
		
		
	}
	
	
	public static function allowInsecureDomain (?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void {
		
		
		
	}
	
	
	public static function loadPolicyFile (url:String):Void {
		
		//var res = haxe.Http.requestUrl( url );
		
	}
	
	
}