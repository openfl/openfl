package openfl._v2.display; #if lime_legacy


import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.UncaughtErrorEvents;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.system.ApplicationDomain;
import openfl.utils.ByteArray;


class LoaderInfo extends URLLoader {
	
	
	public var applicationDomain:ApplicationDomain;
	public var bytes (get, null):ByteArray;
	public var childAllowsParent (default, null):Bool;
	public var content:DisplayObject;
	public var contentType:String;
	public var frameRate (default, null):Float;
	public var height (default, null):Int;
	public var loader (default, null):Loader;
	public var loaderURL (default, null):String;
	public var parameters (default, null):Dynamic <String>;
	public var parentAllowsChild (default, null):Bool;
	public var sameDomain (default, null):Bool;
	public var sharedEvents (default, null):EventDispatcher;
	public var url (default, null):String;
	public var width (default, null):Int;
	public var uncaughtErrorEvents(default, null) : UncaughtErrorEvents;
	
	@:noCompletion private var __pendingURL:String;
	
	
	private function new () {
		
		super ();
		
		applicationDomain = ApplicationDomain.currentDomain;
		childAllowsParent = true;
		frameRate = 0;
		dataFormat = URLLoaderDataFormat.BINARY;
		loaderURL = null;
		
	}
	
	
	public static function create (loader:Loader):LoaderInfo {
		
		var loaderInfo = new LoaderInfo ();
		loaderInfo.loader = loader;
		loaderInfo.uncaughtErrorEvents = new UncaughtErrorEvents();
		loaderInfo.addEventListener (Event.COMPLETE, loaderInfo.this_onComplete);
		
		if (loader == null) {
			
			loaderInfo.url = "";
			
		}
		
		return loaderInfo;
		
	}
	
	
	public override function load (request:URLRequest):Void {
		
		__pendingURL = request.url;
		var dot = __pendingURL.lastIndexOf (".");
		var extension = dot > 0 ? __pendingURL.substr (dot + 1).toLowerCase () : "";
		
		if (extension.indexOf('?') != -1) 
			extension = extension.split('?')[0];
		
		contentType = switch (extension) {
			
			case "swf": "application/x-shockwave-flash";
			case "jpg","jpeg": "image/jpeg";
			case "png": "image/png";
			case "gif": "image/gif";
			default:
				throw "Unrecognized file " + __pendingURL;
			
		}
		
		url = null;
		
		super.load (request);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function this_onComplete (event:Event):Void {
		
		url = __pendingURL;
		removeEventListener (Event.COMPLETE, this_onComplete);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_bytes ():ByteArray {
		
		return data;
		
	}
	
	
}


#end