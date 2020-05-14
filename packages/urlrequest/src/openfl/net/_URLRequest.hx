package openfl.net;

import haxe.macro.Compiler;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _URLRequest
{
	public var contentType:String;
	public var data:Dynamic;
	public var followRedirects:Bool;
	public var idleTimeout:Float;
	public var manageCookies:Bool;
	public var method:String;
	public var requestHeaders:Array<URLRequestHeader>;
	public var url:String;
	public var userAgent:String;

	private var urlRequest:URLRequest;

	public function new(urlRequest:URLRequest, url:String = null)
	{
		this.urlRequest = urlRequest;

		if (url != null)
		{
			this.url = url;
		}

		contentType = null; // "application/x-www-form-urlencoded";
		followRedirects = URLRequestDefaults.followRedirects;

		if (URLRequestDefaults.idleTimeout > 0)
		{
			idleTimeout = URLRequestDefaults.idleTimeout;
		}
		else
		{
			#if lime_default_timeout
			idleTimeout = Std.parseInt(Compiler.getDefine("lime-default-timeout"));
			#else
			idleTimeout = 30000;
			#end
		}

		manageCookies = URLRequestDefaults.manageCookies;
		method = URLRequestMethod.GET;
		requestHeaders = [];
		userAgent = URLRequestDefaults.userAgent;
	}

	// @:dox(hide) public function useRedirectedURL (sourceRequest:URLRequest, wholeURL:Bool = false, pattern:Dynamic = null, replace:String = null):Void;
}
