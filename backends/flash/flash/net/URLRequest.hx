package flash.net;

@:final extern class URLRequest {
	function new(?url : String) : Void;
    public var contentType : String;
 	public var data : Dynamic;
 	public var digest : String;
    public var method : String;
    public var requestHeaders : Array<URLRequestHeader>;
    public var url : String;
    public var _userAgent : String;
    public var userAgent (get,set): String;

    inline public function get_userAgent (): String { 
        var userAgent = null;
        try { 
            userAgent = untyped this["userAgent"];
        } catch (e:Dynamic) { 
			openfl.Lib.notImplemented ("URLRequest.userAgent");
        }
        return userAgent;
    }

    inline public function set_userAgent (userAgent : String): String {
        try { 
            untyped this["userAgent"] = userAgent;
        } catch (e:Dynamic) { 
			openfl.Lib.notImplemented ("URLRequest.userAgent");
        }
        return userAgent;
    }
}
