package openfl.net;

import haxe.macro.Compiler;

@:final class URLRequest {
	
	
	public var contentType:String;
	public var data:Dynamic;
	public var followRedirects:Bool;
	public var idleTimeout:Float;
	public var manageCookies:Bool;
	public var method:String;
	public var requestHeaders:Array<URLRequestHeader>;
	public var url:String;
	public var userAgent:String;
	
	
	public function new (url:String = null) {
		
		if (url != null) {
			
			this.url = url;
			
		}
		
		contentType = null; // "application/x-www-form-urlencoded";
		followRedirects = URLRequestDefaults.followRedirects;
		idleTimeout = URLRequestDefaults.idleTimeout > 0 ? URLRequestDefaults.idleTimeout : #if lime_default_timeout Std.parseInt (Compiler.getDefine ("lime-default-timeout")) #else 30000 #end;
		manageCookies = URLRequestDefaults.manageCookies;
		method = URLRequestMethod.GET;
		requestHeaders = [];
		userAgent = URLRequestDefaults.userAgent;
		
	}
	
	
}
