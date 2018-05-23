package openfl.system {
	
	
	/**
	 * @externs
	 */
	public class Security {
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public static var APPLICATION:String;
		// #end
		
		public static const LOCAL_TRUSTED:String = "localTrusted";
		public static const LOCAL_WITH_FILE:String = "localWithFile";
		public static const LOCAL_WITH_NETWORK:String = "localWithNetwork";
		public static const REMOTE:String = "remote";
		
		public static var disableAVM1Loading:Boolean;
		public static var exactSettings:Boolean;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public static var pageDomain (default, null):String;
		// #end
		
		public static function get sandboxType ():String { return null; }
		
		
		public static function allowDomain (p1:* = null, p2:* = null, p3:* = null, p4:* = null, p5:* = null):void {}
		public static function allowInsecureDomain (p1:* = null, p2:* = null, p3:* = null, p4:* = null, p5:* = null):void {}
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public static function duplicateSandboxBridgeInputArguments (toplevel:Dynamic, args:Array<Dynamic>):Array<Dynamic>;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public static function duplicateSandboxBridgeOutputArgument (toplevel:Dynamic, arg:Dynamic):Dynamic;
		// #end
		
		public static function loadPolicyFile (url:String):void {}
		
		// #if flash
		// @:noCompletion @:dox(hide) public static function showSettings (panel:flash.system.SecurityPanel = null):void {}
		// #end
		
		
	}
	
	
}