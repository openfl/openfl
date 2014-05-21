package openfl.net;


import js.html.EventTarget;
import js.html.XMLHttpRequest;
import js.Browser;
import js.Lib;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.errors.IOError;
import openfl.events.SecurityErrorEvent;
import openfl.utils.ByteArray;


class URLLoader extends EventDispatcher {
	
	
	public var bytesLoaded:Int;
	public var bytesTotal:Int;
	public var data:Dynamic;
	public var dataFormat (default, set):URLLoaderDataFormat;
	
	
	public function new (request:URLRequest = null) {
		
		super ();
		
		bytesLoaded = 0;
		bytesTotal = 0;
		dataFormat = URLLoaderDataFormat.TEXT;
		
		if (request != null) {
			
			load (request);
			
		}
		
	}
	
	
	public function close ():Void {
		
		
		
	}
	
	
	private dynamic function getData ():Dynamic {
		
		return null;
		
	}
	
	
	public function load (request:URLRequest):Void {
		
		requestUrl (request.url, request.method, request.data, request.formatRequestHeaders ());
		
	}
	
	
	private function registerEvents (subject:EventTarget):Void {
		
		var self = this;
		if (untyped __js__("typeof XMLHttpRequestProgressEvent") != __js__('"undefined"')) {
			
			subject.addEventListener ("progress", onProgress, false);
			
		}
		
		untyped subject.onreadystatechange = function () {
			
			if (subject.readyState != 4) return;
			
			var s = try subject.status catch (e:Dynamic) null;
			
			if (s == untyped __js__("undefined")) {
				
				s = null;
				
			}
			
			if (s != null) {
				
				self.onStatus (s);
				
			}
			
			//js.Lib.alert (s);
			
			if (s != null && s >= 200 && s < 400) {
				
				self.onData (subject.response);
				
			} else {
				
				if (s == null) {
					
					self.onError ("Failed to connect or resolve host");
					
				} else if (s == 12029) {
					
					self.onError ("Failed to connect to host");
					
				} else if (s == 12007) {
					
					self.onError ("Unknown host");
					
				} else if (s == 0) {
					
					self.onError ("Unable to make request (may be blocked due to cross-domain permissions)");
					self.onSecurityError ("Unable to make request (may be blocked due to cross-domain permissions)");
					
				} else {
					
					self.onError ("Http Error #" + subject.status);
					
				}
				
			}
			
		};
		
	}
	
	
	private function requestUrl (url:String, method:String, data:Dynamic, requestHeaders:Array<URLRequestHeader>):Void {
		
		var xmlHttpRequest:XMLHttpRequest = untyped __new__("XMLHttpRequest");
		registerEvents (cast xmlHttpRequest);
		var uri:Dynamic = "";
		
		if (Std.is (data, ByteArray)) {
			
			var data:ByteArray = cast data;
			
			switch (dataFormat) {
				
				case BINARY: uri = data.__getBuffer ();
				default: uri = data.readUTFBytes (data.length);
				
			}
			
		} else if (Std.is (data, URLVariables)) {
			
			var data:URLVariables = cast data;
			
			for (p in Reflect.fields (data)) {
				
				if (uri.length != 0) uri += "&";
				uri += StringTools.urlEncode (p) + "=" + StringTools.urlEncode (Reflect.field (data, p));
				
			}
			
		} else {
			
			if (data != null) {
				
				uri = data.toString ();
				
			}
			
		}
		
		try {
			
			if (method == "GET" && uri != null && uri != "") {
				
				var question = url.split ("?").length <= 1;
				xmlHttpRequest.open (method, url + (if (question) "?" else "&") + uri, true);
				uri = "";
				
			} else {
				
				//js.Lib.alert ("open: " + method + ", " + url + ", true");
				xmlHttpRequest.open (method, url, true);
				
			}
			
		} catch (e:Dynamic) {
			
			onError (e.toString ());
			return;
			
		}
		
		//js.Lib.alert ("dataFormat: " + dataFormat);
		
		switch (dataFormat) {
			
			case BINARY: untyped xmlHttpRequest.responseType = 'arraybuffer';
			default:
			
		}
		
		for (header in requestHeaders) {
			
			//js.Lib.alert ("setRequestHeader: " + header.name + ", " + header.value);
			xmlHttpRequest.setRequestHeader (header.name, header.value);
			
		}
		
		//js.Lib.alert ("uri: " + uri);
		
		xmlHttpRequest.send (uri);
		onOpen ();
		
		getData = function () {
			
			if (xmlHttpRequest.response != null) {
				
				return xmlHttpRequest.response;
				
			} else { 
				
				return xmlHttpRequest.responseText;
				
			}
			
		};
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function onData (_):Void {
		
		var content:Dynamic = getData ();
		
		switch (dataFormat) {
			
			case BINARY: this.data = ByteArray.__ofBuffer (content);
			default: this.data = Std.string (content);
			
		}
		
		var evt = new Event (Event.COMPLETE);
		evt.currentTarget = this;
		dispatchEvent (evt);
		
	}
	
	
	private function onError (msg:String):Void {
		
		var evt = new IOErrorEvent (IOErrorEvent.IO_ERROR);
		evt.text = msg;
		evt.currentTarget = this;
		dispatchEvent (evt);
		
	}
	
	
	private function onOpen ():Void {
		
		var evt = new Event (Event.OPEN);
		evt.currentTarget = this;
		dispatchEvent (evt);
		
	}
	
	
	private function onProgress (event:XMLHttpRequestProgressEvent):Void {
		
		var evt = new ProgressEvent (ProgressEvent.PROGRESS);
		evt.currentTarget = this;
		evt.bytesLoaded = event.loaded;
		evt.bytesTotal = event.total;
		dispatchEvent (evt);
		
	}
	
	
	private function onSecurityError (msg:String):Void {
		
		var evt = new SecurityErrorEvent (SecurityErrorEvent.SECURITY_ERROR);
		evt.text = msg;
		evt.currentTarget = this;
		dispatchEvent (evt);
		
	}
	
	
	private function onStatus (status:Int):Void {
		
		var evt = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS, false, false, status);
		evt.currentTarget = this;
		dispatchEvent (evt);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_dataFormat (inputVal:URLLoaderDataFormat):URLLoaderDataFormat {
		
		// prevent inadvertently using typed arrays when they are unsupported
		// @todo move these sorts of tests somewhere common in the vein of Modernizr
		
		if (inputVal == URLLoaderDataFormat.BINARY && !Reflect.hasField (Browser.window, "ArrayBuffer")) {
			
			dataFormat = URLLoaderDataFormat.TEXT;
			
		} else {
			
			dataFormat = inputVal;
			
		}
		
		return dataFormat;
		
	}
	
	
}


typedef XMLHttpRequestProgressEvent = Dynamic;