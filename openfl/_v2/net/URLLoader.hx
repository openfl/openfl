package openfl._v2.net; #if lime_legacy


import sys.io.File;
import sys.FileSystem;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequestHeader;
import openfl.net.URLVariables;
import openfl.utils.ByteArray;
import openfl.Lib;


class URLLoader extends EventDispatcher {
	
	
	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	public var data:Dynamic;
	public var dataFormat:URLLoaderDataFormat;
	
	@:noCompletion private static var activeLoaders = new List<URLLoader> ();
	@:noCompletion private static inline var urlInvalid = 0;
	@:noCompletion private static inline var urlInit = 1;
	@:noCompletion private static inline var urlLoading = 2;
	@:noCompletion private static inline var urlComplete = 3;
	@:noCompletion private static inline var urlError = 4;
	
	@:noCompletion private var state:Int;
	@:noCompletion private var __handle:Dynamic;
	@:noCompletion public var __onComplete:Dynamic -> Bool;
	
	
	public function new (request:URLRequest = null) {
		
		super ();
		
		__handle = 0;
		bytesLoaded = 0;
		bytesTotal = -1;
		state = urlInvalid;
		dataFormat = URLLoaderDataFormat.TEXT;
		
		if (request != null) {
			
			load (request);
			
		}
		
	}
	
	
	public function close ():Void {
		
		
		
	}
	
	
	private function dispatchHTTPStatus (code:Int):Void {
		
		var event = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS, false, false, code);
		var headers:Array<String> = lime_curl_get_headers (__handle);
		
		for (header in headers) {
			
			var index = header.indexOf(": ");
			if (index > 0) {
				
				event.responseHeaders.push (new URLRequestHeader (header.substr (0, index), header.substr (index + 2, header.length - index - 4)));
				
			}
			
		}
		
		dispatchEvent (event);
		
	}
	
	
	public function getCookies ():Array<String> {
		
		return lime_curl_get_cookies (__handle);
		
	}
	
	
	public static function hasActive ():Bool {
		
		return !activeLoaders.isEmpty ();
		
	}
	
	
	public static function initialize (caCertFilePath:String):Void {
		
		lime_curl_initialize (caCertFilePath);
		
	}
	
	
	public function load (request:URLRequest):Void {
		
		state = urlInit;
		
		var pref = request.url.substr (0, 7);
		if (pref != "http://" && pref != "https:/") {
			
			try {
				
				var bytes = ByteArray.readFile (request.url);
				
				if (bytes == null) {
					
					throw ("Could not open file \"" + request.url + "\"");
					
				}
				
				switch (dataFormat) {
					
					case TEXT: data = bytes.asString ();
					case VARIABLES: data = new URLVariables(bytes.asString());
					default: data = bytes;
					
				}
				
			} catch (e:Dynamic) {
				
				onError (e);
				return;
				
			}
			
			__dataComplete ();
			
		} else {
			
			request.__prepare ();
			__handle = lime_curl_create (request);
			
			if (__handle == null) {
				
				onError ("Could not open URL");
				
			} else {
				
				activeLoaders.push (this);
				
			}
			
		}
		
	}
	
	
	private function onError (msg:String):Void {
		
		activeLoaders.remove (this);
		dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR, true, false, msg));
		
	}
	
	
	private function update ():Void {
		
		if (__handle != null) {
			
			var old_loaded = bytesLoaded;
			var old_total = bytesTotal;
			lime_curl_update_loader (__handle, this);
			
			if (old_total < 0 && bytesTotal > 0) {
				
				dispatchEvent (new Event (Event.OPEN));
				
			}
			
			if (bytesTotal > 0 && bytesLoaded != old_loaded) {
				
				dispatchEvent (new ProgressEvent (ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
				
			}
			
			var code:Int = lime_curl_get_code (__handle);
			
			if (state == urlComplete) {
				
				dispatchHTTPStatus (code);
				
				var bytes:ByteArray = lime_curl_get_data (__handle);
				
				switch (dataFormat) {
					
					case TEXT, VARIABLES:
						data = bytes == null ? "" : bytes.asString ();
					default:
						data = bytes;
					
				}
				
				if (code < 400) {
					
					__dataComplete ();
					
				} else {
					
					var event = new IOErrorEvent (IOErrorEvent.IO_ERROR, true, false, data, code);
					__handle = null;
					dispatchEvent (event);
					
				}
				
			} else if (state == urlError) {
				
				dispatchHTTPStatus (code);
				
				var event = new IOErrorEvent (IOErrorEvent.IO_ERROR, true, false, lime_curl_get_error_message (__handle), code);
				__handle = null;
				dispatchEvent (event);
				
			}
			
		}
		
	}
	
	
	@:noCompletion private function __dataComplete ():Void {
		
		activeLoaders.remove (this);
		
		if (__onComplete != null) {
			
			if (__onComplete (data)) {
				
				dispatchEvent (new Event (Event.COMPLETE));
				
			} else {
				
				__dispatchIOErrorEvent ();
				
			}
			
		} else {
			
			dispatchEvent (new Event (Event.COMPLETE));
			
		}
		
	}
	
	
	@:noCompletion public static function __loadPending ():Bool {
		
		return !activeLoaders.isEmpty ();
		
	}
	
	
	@:noCompletion public static function __pollData ():Void {
		
		if (!activeLoaders.isEmpty ()) {
			
			lime_curl_process_loaders ();
			var oldLoaders = activeLoaders;
			activeLoaders = new List<URLLoader> ();
			
			for (loader in oldLoaders) {
				
				loader.update ();
				if (loader.state == urlLoading) {
					
					activeLoaders.push (loader);
					
				}
				
			}
			
		}
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_curl_create = Lib.load ("lime", "lime_curl_create", 1);
	private static var lime_curl_process_loaders = Lib.load ("lime", "lime_curl_process_loaders", 0);
	private static var lime_curl_update_loader = Lib.load ("lime", "lime_curl_update_loader", 2);
	private static var lime_curl_get_code = Lib.load ("lime", "lime_curl_get_code", 1);
	private static var lime_curl_get_error_message = Lib.load ("lime", "lime_curl_get_error_message", 1);
	private static var lime_curl_get_data = Lib.load ("lime", "lime_curl_get_data", 1);
	private static var lime_curl_get_cookies = Lib.load ("lime", "lime_curl_get_cookies", 1);
	private static var lime_curl_get_headers = Lib.load ("lime", "lime_curl_get_headers", 1);
	private static var lime_curl_initialize = Lib.load ("lime", "lime_curl_initialize", 1);
	
}


#end