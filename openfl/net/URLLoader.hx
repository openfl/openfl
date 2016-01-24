package openfl.net; #if (!openfl_legacy || disable_legacy_networking)


import lime.app.Event;
import lime.system.BackgroundWorker;
import lime.system.CFFI;
import lime.utils.Bytes;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.errors.IOError;
import openfl.events.SecurityErrorEvent;
import openfl.utils.ByteArray;

#if (js && html5)
import js.html.ArrayBuffer;
import js.html.EventTarget;
import js.html.XMLHttpRequest;
import js.Browser;
import js.Lib;
#end

#if lime_curl
import lime.net.curl.CURL;
import lime.net.curl.CURLEasy;
import lime.net.curl.CURLCode;
import lime.net.curl.CURLInfo;
import lime.net.curl.CURLOption;
#end

@:access(openfl.events.Event)


class URLLoader extends EventDispatcher {
	
	
	public var bytesLoaded:Int;
	public var bytesTotal:Int;
	public var data:Dynamic;
	public var dataFormat (default, set):URLLoaderDataFormat;
	
	
	#if lime_curl
	private var __curl:CURL;
	private var __data:ByteArray;
	#end
	
	
	public function new (request:URLRequest = null) {
		
		super ();
		
		bytesLoaded = 0;
		bytesTotal = 0;
		dataFormat = URLLoaderDataFormat.TEXT;
		
		#if lime_curl
		__data = new ByteArray ();
		__curl = CURLEasy.init ();
		#end
		
		if (request != null) {
			
			load (request);
			
		}
		
	}
	
	
	public function close ():Void {
		
		#if lime_curl
		CURLEasy.cleanup (__curl);
		#end
		
	}
	
	
	private dynamic function getData ():Dynamic {
		
		return null;
		
	}
	
	
	public function load (request:URLRequest):Void {
		
		#if (js && html5)
		requestUrl (request.url, request.method, request.data, request.formatRequestHeaders ());
		#else
		if (request.url != null && request.url.indexOf ("http://") == -1 && request.url.indexOf ("https://") == -1) {
			
			var worker = new BackgroundWorker ();
			worker.doWork.add (function (_) {
				
				var path = request.url;
				var index = path.indexOf ("?");
				
				if (index > -1) {
					
					path = path.substring (0, index);
					
				}
				
				var bytes:ByteArray = Bytes.readFile (path);
				worker.sendComplete (bytes);
				
			});
			worker.onComplete.add (function (bytes:ByteArray) {
				
				if (bytes != null) {
					
					switch (dataFormat) {
						
						case BINARY: this.data = bytes;
						default: this.data = bytes.readUTFBytes (bytes.length);
						
					}
					
					var evt = new Event (Event.COMPLETE);
					evt.currentTarget = this;
					dispatchEvent (evt);
					
				} else {
					
					var evt = new IOErrorEvent (IOErrorEvent.IO_ERROR);
					evt.currentTarget = this;
					dispatchEvent (evt);
					
				}
				
			});
			worker.run ();
			
		}
		#if lime_curl
		else
		{
			requestUrl (request.url, request.method, request.data, request.formatRequestHeaders ());
		}
		#end
		#end
		
	}
	
	
	#if (js && html5)
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
		
		if (Std.is (data, ByteArrayData)) {
			
			var data:ByteArrayData = cast data;
			
			switch (dataFormat) {
				
				case BINARY: uri = cast (data, ArrayBuffer);
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
	
	
	#elseif lime_curl
	
	
	private function prepareData (data:Dynamic):ByteArray {
		
		var uri:ByteArray = new ByteArray ();
		
		if (Std.is (data, ByteArrayData)) {
			
			var data:ByteArray = cast data;
			uri = data;
			
		} else if (Std.is (data, URLVariables)) {
			
			var data:URLVariables = cast data;
			var tmp:String = "";
			
			for (p in Reflect.fields (data)) {
				
				if (tmp.length != 0) tmp += "&";
				tmp += StringTools.urlEncode (p) + "=" + StringTools.urlEncode (Std.string (Reflect.field (data, p)));
				
			}
			
			uri.writeUTFBytes (tmp);
			
		} else {
			
			if (data != null) {
				
				uri.writeUTFBytes (Std.string (data));
				
			}
			
		}
		
		return uri;
		
	}
	
	
	private function requestUrl (url:String, method:URLRequestMethod, data:Dynamic, requestHeaders:Array<URLRequestHeader>):Void {
		
		var uri = prepareData (data);
		uri.position = 0;
		
		__data = new ByteArray ();
		bytesLoaded = 0;
		bytesTotal = 0;
		
		CURLEasy.reset (__curl);
		CURLEasy.setopt (__curl, URL, url);
		
		switch (method) {
			
			case HEAD:
				
				CURLEasy.setopt(__curl, NOBODY, true);
			
			case GET:
				
				CURLEasy.setopt(__curl, HTTPGET, true);
				
				if (uri.length > 0) {
					
					CURLEasy.setopt (__curl, URL, url + "?" + uri.readUTFBytes (uri.length));
					
				}
			
			case POST:
				
				CURLEasy.setopt(__curl, POST, true);
				CURLEasy.setopt(__curl, READFUNCTION, readFunction.bind(_, uri));
				CURLEasy.setopt(__curl, POSTFIELDSIZE, uri.length);
				CURLEasy.setopt(__curl, INFILESIZE, uri.length);
			
			case PUT:
				
				CURLEasy.setopt(__curl, UPLOAD, true);
				CURLEasy.setopt(__curl, READFUNCTION, readFunction.bind(_, uri));
				CURLEasy.setopt(__curl, INFILESIZE, uri.length);
			
			case _:
				
				CURLEasy.setopt(__curl, CUSTOMREQUEST, cast method);
				CURLEasy.setopt(__curl, READFUNCTION, readFunction.bind(_, uri));
				CURLEasy.setopt(__curl, INFILESIZE, uri.length);
			
		}
		
		var headers:Array<String> = [];
		headers.push ("Expect: "); // removes the default cURL value
		
		for (requestHeader in requestHeaders) {
			
			headers.push ('${requestHeader.name}: ${requestHeader.value}');
			
		}
		
		CURLEasy.setopt (__curl, FOLLOWLOCATION, true);
		CURLEasy.setopt (__curl, AUTOREFERER, true);
		CURLEasy.setopt (__curl, HTTPHEADER, headers);
		
		CURLEasy.setopt (__curl, PROGRESSFUNCTION, progressFunction);
		CURLEasy.setopt (__curl, WRITEFUNCTION, writeFunction);
		CURLEasy.setopt (__curl, HEADERFUNCTION, headerFunction);
		
		CURLEasy.setopt (__curl, SSL_VERIFYPEER, false);
		CURLEasy.setopt (__curl, SSL_VERIFYHOST, 0);
		CURLEasy.setopt (__curl, USERAGENT, "libcurl-agent/1.0");
		CURLEasy.setopt (__curl, CONNECTTIMEOUT, 30);
		CURLEasy.setopt (__curl, TRANSFERTEXT, dataFormat == BINARY ? 0 : 1);
		
		var worker = new BackgroundWorker ();
		worker.doWork.add (function (_) {
			
			var result = CURLEasy.perform (__curl);
			worker.sendComplete (result);
			
		});
		worker.onComplete.add (function (result) {
			
			var responseCode = CURLEasy.getinfo (__curl, RESPONSE_CODE);
			
			if (result == CURLCode.OK) {
				
				switch (dataFormat) {
					
					case BINARY:
						
						this.data = __data;
					
					default:
						
						__data.position = 0;
						this.data = __data.readUTFBytes (__data.length);
					
				}
				
				onStatus (Std.parseInt (responseCode));
				
				var evt = new Event (Event.COMPLETE);
				evt.currentTarget = this;
				dispatchEvent (evt);
				
			} else {
				
				onError ("Problem with curl: " + result);
				
			}
			
		});
		worker.run ();
		
	}
	
	
	private function writeFunction (output:haxe.io.Bytes, size:Int, nmemb:Int):Int {
		
		__data.writeBytes (ByteArray.fromBytes (output));
		return size * nmemb;
		
	}
	
	
	private function headerFunction (output:haxe.io.Bytes, size:Int, nmemb:Int):Int {
		
		// TODO
		return size * nmemb;
		
	}
	
	
	private function progressFunction (dltotal:Float, dlnow:Float, uptotal:Float, upnow:Float):Int {
		
		if (upnow > bytesLoaded || dlnow > bytesLoaded || uptotal > bytesTotal || dltotal > bytesTotal) {
			
			if (upnow > bytesLoaded) bytesLoaded = Std.int (upnow);
			if (dlnow > bytesLoaded) bytesLoaded = Std.int (dlnow);
			if (uptotal > bytesTotal) bytesTotal = Std.int (uptotal);
			if (dltotal > bytesTotal) bytesTotal = Std.int (dltotal);
			
			var evt = new ProgressEvent (ProgressEvent.PROGRESS);
			evt.currentTarget = this;
			evt.bytesLoaded = bytesLoaded;
			evt.bytesTotal = bytesTotal;
			dispatchEvent (evt);
			
		}
		
		return 0;
		
	}

	
	private function readFunction (max:Int, input:ByteArray):Bytes {
		
		return input;
		
	}
	
	
	#end
	
	
	
	
	// Event Handlers
	
	
	
	
	private function onData (_):Void {
		
		#if (js && html5)
		var content:Dynamic = getData ();
		
		switch (dataFormat) {
			
			case BINARY: this.data = ByteArray.fromArrayBuffer ((content:ArrayBuffer));
			default: this.data = Std.string (content);
			
		}
		#end
		
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
		
		#if (js && html5)
		// prevent inadvertently using typed arrays when they are unsupported
		// @todo move these sorts of tests somewhere common in the vein of Modernizr
		
		if (inputVal == URLLoaderDataFormat.BINARY && !Reflect.hasField (Browser.window, "ArrayBuffer")) {
			
			dataFormat = URLLoaderDataFormat.TEXT;
			
		} else {
			
			dataFormat = inputVal;
			
		}
		
		return dataFormat;
		#else
		return dataFormat = inputVal;
		#end
		
	}
	
	
}


typedef XMLHttpRequestProgressEvent = Dynamic;


#else
typedef URLLoader = openfl._legacy.net.URLLoader;
#end
