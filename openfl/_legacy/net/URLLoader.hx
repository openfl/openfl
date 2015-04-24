package openfl._legacy.net; #if (openfl_legacy && !disable_legacy_networking)


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
import cpp.vm.Thread;

class URLLoadersManager {

	static var instance : URLLoadersManager;

	var managersThread : Thread;
	var activeLoaders : List<URLLoader>;
	var loadsQueue : Array<{loader : URLLoader, request : URLRequest}>;

	public static function getInstance() : URLLoadersManager {
		if (instance==null)	{
			instance = new URLLoadersManager();
		}
		return instance;
	}

	function new() {
		activeLoaders = new List<URLLoader>();
		loadsQueue = [];
		managersThread = Thread.create(mainLoop);
	}

	function mainLoop() {

		while (true) {

			var loadCall = loadsQueue.shift();
			if (loadCall!=null) {
				loadCall.loader.loadInCURLThread(loadCall.request);
			}

			if (!activeLoaders.isEmpty()) {
				lime_curl_process_loaders();
				var oldLoaders = activeLoaders;
				activeLoaders = new List<URLLoader>();
				for (loader in oldLoaders) {
					loader.update();
					if (loader.state == URLLoader.urlLoading) {
						activeLoaders.push(loader);
					}
				}
			}

			Sys.sleep(0.05);
		}

	} // mainLoop

	public function enqueueLoad(loader : URLLoader, request : URLRequest) {
		loadsQueue.push({loader : loader, request : request});
	}

	public function activeLoadersIsEmpty() {
		return activeLoaders.isEmpty();
	}

	public function getActiveLoaders() : List<URLLoader> {
		if (Thread.current()!=managersThread) throw "Wrong thread : getActiveLoaders";
		return activeLoaders;
	}

	public function create(request : URLRequest) : Dynamic {
		if (Thread.current()!=managersThread) throw "Wrong thread : create";
		return lime_curl_create(request);
	}

	public function updateLoader(handle : Dynamic, loader : URLLoader) : Void {
		if (Thread.current()!=managersThread) throw "Wrong thread : updateLoader";
		lime_curl_update_loader(handle, loader);
	}

	public function getCode(handle : Dynamic) : Int {
		if (Thread.current()!=managersThread) throw "Wrong thread : getCode";
		return lime_curl_get_code(handle);
	}

	public function getErrorMessage(handle : Dynamic) : String {
		if (Thread.current()!=managersThread) throw "Wrong thread : getErrorMessage";
		return lime_curl_get_error_message(handle);
	}

	public function getData(handle : Dynamic) : ByteArray {
		if (Thread.current()!=managersThread) throw "Wrong thread : getData";
		return lime_curl_get_data(handle);
	}

	public function getCookies(handle : Dynamic) : Array<String> {
		if (Thread.current()!=managersThread) throw "Wrong thread : getCookies";
		return lime_curl_get_cookies(handle);
	}

	public function getHeaders(handle : Dynamic) : Array<String> {
		if (Thread.current()!=managersThread) throw "Wrong thread : getHeaders";
		return lime_curl_get_headers(handle);
	}

	// Native Methods
	private static var lime_curl_create = Lib.load ("lime-legacy", "lime_legacy_curl_create", 1);
	private static var lime_curl_process_loaders = Lib.load ("lime-legacy", "lime_legacy_curl_process_loaders", 0);
	private static var lime_curl_update_loader = Lib.load ("lime-legacy", "lime_legacy_curl_update_loader", 2);
	private static var lime_curl_get_code = Lib.load ("lime-legacy", "lime_legacy_curl_get_code", 1);
	private static var lime_curl_get_error_message = Lib.load ("lime-legacy", "lime_legacy_curl_get_error_message", 1);
	private static var lime_curl_get_data = Lib.load ("lime-legacy", "lime_legacy_curl_get_data", 1);
	private static var lime_curl_get_cookies = Lib.load ("lime-legacy", "lime_legacy_curl_get_cookies", 1);
	private static var lime_curl_get_headers = Lib.load ("lime-legacy", "lime_legacy_curl_get_headers", 1);
	private static var lime_curl_initialize = Lib.load ("lime-legacy", "lime_legacy_curl_initialize", 1);

}

class URLLoader extends EventDispatcher {
	
	
	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	public var data:Dynamic;
	public var dataFormat:URLLoaderDataFormat;
	
	//@:noCompletion private static var activeLoaders = new List<URLLoader> ();
	@:noCompletion private static inline var urlInvalid = 0;
	@:noCompletion private static inline var urlInit = 1;
	
	@:allow(openfl._legacy.net.URLLoadersManager)
	@:noCompletion private static inline var urlLoading = 2;
	
	@:noCompletion private static inline var urlComplete = 3;
	@:noCompletion private static inline var urlError = 4;
	
	@:allow(openfl._legacy.net.URLLoadersManager)
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
		//var headers:Array<String> = lime_curl_get_headers (__handle);
		var headers = URLLoadersManager.getInstance().getHeaders(__handle);
		
		for (header in headers) {
			
			var index = header.indexOf(": ");
			if (index > 0) {
				
				event.responseHeaders.push (new URLRequestHeader (header.substr (0, index), header.substr (index + 2, header.length - index - 4)));
				
			}
			
		}
		
		//dispatchEvent (event);
		enqueueEvent(this, event);
		
	}
	
	
	public function getCookies ():Array<String> {
		trace("GET COOKIES");
		return [];
		/*
		return lime_curl_get_cookies (__handle);
		*/
	}
	
	
	public static function hasActive ():Bool {
		
		return !URLLoadersManager.getInstance().activeLoadersIsEmpty();
		
	}
	
	
	public static function initialize (caCertFilePath:String):Void {
		trace("INITIALIZE");
		/*
		lime_curl_initialize (caCertFilePath);
		*/
		
	}
	
	
	public function load (request:URLRequest):Void {
		
		URLLoadersManager.getInstance().enqueueLoad(this, request);

	}

	@:allow(openfl._legacy.net.URLLoadersManager)
	function loadInCURLThread(request:URLRequest):Void {

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

			//__handle = lime_curl_create (request);
			__handle = URLLoadersManager.getInstance().create(request);
			
			if (__handle == null) {
				
				onError ("Could not open URL");
				
			} else {
				
				URLLoadersManager.getInstance().getActiveLoaders().push (this);
				
			}
			
		}

	}
	
	
	private function onError (msg:String):Void {
		
		URLLoadersManager.getInstance().getActiveLoaders().remove (this);
		//dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR, true, false, msg));
		enqueueEvent(this, new IOErrorEvent (IOErrorEvent.IO_ERROR, true, false, msg));
		
	}
	
	@:allow(openfl._legacy.net.URLLoadersManager)
	private function update():Void {

		if (__handle != null) {

			var old_loaded = bytesLoaded;
			var old_total = bytesTotal;
			//lime_curl_update_loader (__handle, this);
			URLLoadersManager.getInstance().updateLoader(__handle, this);

			if (old_total < 0 && bytesTotal > 0) {
				//dispatchEvent (new Event (Event.OPEN));
				enqueueEvent(this, new Event (Event.OPEN));
			}
			
			if (bytesTotal > 0 && bytesLoaded != old_loaded) {
				//dispatchEvent (new ProgressEvent (ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
				var evt = new ProgressEvent (ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal);
				enqueueEvent(this, evt);
			}
			
			//var code:Int = lime_curl_get_code (__handle);
			var code = URLLoadersManager.getInstance().getCode(__handle);
			
			if (state == urlComplete) {

				dispatchHTTPStatus (code);
				//var bytes:ByteArray = lime_curl_get_data (__handle);
				var bytes = URLLoadersManager.getInstance().getData(__handle);
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
					//dispatchEvent (event);
					enqueueEvent(this, event);
				}
				
			} else if (state == urlError) {
				dispatchHTTPStatus (code);
				var errorMessage = URLLoadersManager.getInstance().getErrorMessage(__handle);
				var event = new IOErrorEvent (IOErrorEvent.IO_ERROR, true, false, errorMessage, code);
				__handle = null;
				//dispatchEvent (event);
				enqueueEvent(this, event);
			}
			
		}
		
	}
	
	
	@:noCompletion private function __dataComplete ():Void {
		
		URLLoadersManager.getInstance().getActiveLoaders().remove (this);
		
		if (__onComplete != null) {
			
			if (__onComplete (data)) {
				
				//dispatchEvent (new Event (Event.COMPLETE));
				enqueueEvent(this, new Event (Event.COMPLETE));
				
			} else {
				
				__dispatchIOErrorEvent ();
				
			}
			
		} else {
			
			//dispatchEvent (new Event (Event.COMPLETE));
			enqueueEvent(this, new Event (Event.COMPLETE));
			
		}
		
	}
	
	
	@:noCompletion public static function __loadPending ():Bool {
		
		return !URLLoadersManager.getInstance().activeLoadersIsEmpty();
		
	}
	
	static var eventsQueue : Array<{loader : URLLoader, event : Event}> = [];

	static function enqueueEvent(loader : URLLoader, event : Event) {
		eventsQueue.push({loader : loader, event : event});
	}

	@:noCompletion public static function __pollData ():Void {
		var evt = eventsQueue.shift();
		if (evt!=null) {
			evt.loader.dispatchEvent(evt.event);
		}
	}

}


#else
typedef URLLoader = openfl.net.URLLoader;
#end