declare namespace openfl.system {
	
	
	export class Security {
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public static var APPLICATION:string;
		// #end
		
		public static LOCAL_TRUSTED:string;
		public static LOCAL_WITH_FILE:string;
		public static LOCAL_WITH_NETWORK:string;
		public static REMOTE:string;
		
		public static disableAVM1Loading:boolean;
		public static exactSettings:boolean;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public static var pageDomain (default, null):string;
		// #end
		
		public static readonly sandboxType:string;
		
		
		public static allowDomain (p1?:any, p2?:any, p3?:any, p4?:any, p5?:any):void;
		public static allowInsecureDomain (p1?:any, p2?:any, p3?:any, p4?:any, p5?:any):void;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public static function duplicateSandboxBridgeInputArguments (toplevel:Dynamic, args:Array<Dynamic>):Array<Dynamic>;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public static function duplicateSandboxBridgeOutputArgument (toplevel:Dynamic, arg:Dynamic):Dynamic;
		// #end
		
		public static loadPolicyFile (url:string):void;
		
		// #if flash
		// @:noCompletion @:dox(hide) public static function showSettings (panel:flash.system.SecurityPanel = null):Void;
		// #end
		
		
	}
	
	
}


export default openfl.system.Security;