package openfl._v2.net; #if lime_legacy


import openfl.net.URLRequestHeader;
import openfl.net.URLVariables;
import openfl.utils.ByteArray;


class URLRequest {
	
	
	public static inline var AUTH_BASIC = 0x0001;
	public static inline var AUTH_DIGEST = 0x0002;
	public static inline var AUTH_GSSNEGOTIATE = 0x0004;
	public static inline var AUTH_NTLM = 0x0008;
	public static inline var AUTH_DIGEST_IE = 0x0010;
	public static inline var AUTH_DIGEST_ANY = 0x000f;
	
	public var authType:Int;
	public var contentType:String;
	public var cookieString:String;
	public var credentials:String;
	public var data:Dynamic;
	public var followRedirects:Bool;
	public var method:String;
	public var requestHeaders:Array<URLRequestHeader>;
	public var url:String;
	public var userAgent:String;
	public var verbose:Bool;
	
	@:noCompletion public var __bytes:ByteArray;
	
	
	public function new (url:String = null) {
		
		if (url != null) {
			
			this.url = url;
			
		}
		
		requestHeaders = [];
		method = URLRequestMethod.GET;
		
		verbose = false;
		cookieString = "";
		authType = 0;
		contentType = "application/x-www-form-urlencoded";
		credentials = "";
		followRedirects = true;
		
	}
	
	
	public function basicAuth (user:String, password:String):Void {
		
		authType = AUTH_BASIC;
		credentials = user + ":" + password;
		
	}
	
	
	public function digestAuth (user:String, password:String):Void {
		
		authType = AUTH_DIGEST;
		credentials = user + ":" + password;
		
	}
	
	
	@:noCompletion public function __prepare ():Void {
		
		if (userAgent == null) {
			
			userAgent = ""; // hack to fix _v2 native crash
			
		}
		
		if (data == null) {
			
			__bytes = new ByteArray ();
			
		} else if (Std.is (data, ByteArray)) {
			
			__bytes = data;
			
		} else if (Std.is (data, URLVariables)) {
			
			var vars:URLVariables = data;
			var str = vars.toString ();
			__bytes = new ByteArray ();
			__bytes.writeUTFBytes (str);
			
		} else if (Std.is (data, String)) {
			
			var str:String = data;
			__bytes = new ByteArray ();
			__bytes.writeUTFBytes (str);
			
		} else if (Std.is (data, Dynamic)) {
			
			var vars:URLVariables = new URLVariables();
			
			for (i in Reflect.fields (data)) {
				
				Reflect.setField (vars, i, Reflect.field (data, i));
				
			}
			
			var str = vars.toString ();
			__bytes = new ByteArray ();
			__bytes.writeUTFBytes (str);
			
		} else {
			
			throw "Unknown data type";
			
		}
		
		//headers = requestHeaders.copy ();
		//headers.push (new URLRequestHeader ("Content-Type", contentType != null ? contentType : "application/x-www-form-urlencoded"));
		
	}
	
	
}


#end