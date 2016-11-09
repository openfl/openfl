package openfl.net;


import haxe.io.Bytes;
import lime.app.Event;
import lime.app.Future;
import lime.net.HTTPRequest;
import lime.net.HTTPRequestHeader;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLRequestMethod;
import openfl.utils.ByteArray;


class URLLoader extends EventDispatcher {
	
	
	public var bytesLoaded:Int;
	public var bytesTotal:Int;
	public var data:Dynamic;
	public var dataFormat:URLLoaderDataFormat;
	
	private var __httpRequest:_IHTTPRequest;
	
	
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
		
		if (__httpRequest != null) {
			
			__httpRequest.cancel ();
			
		}
		
	}
	
	
	public function load (request:URLRequest):Void {
		
		if (dataFormat == BINARY) {
			
			var httpRequest = new HTTPRequest<ByteArray> ();
			__prepareRequest (httpRequest, request);
			
			httpRequest.load ().onProgress (function (progress:Float):Void {
				
				// TODO: Need total download size
				
				var event = new ProgressEvent (ProgressEvent.PROGRESS);
				event.bytesLoaded = progress * 100;
				event.bytesTotal = 100;
				dispatchEvent (event);
				
			}).onError (function (error:Dynamic):Void {
				
				if (error == 403) {
					
					var event = new SecurityErrorEvent (SecurityErrorEvent.SECURITY_ERROR);
					dispatchEvent (event);
					
				} else {
					
					var event = new IOErrorEvent (IOErrorEvent.IO_ERROR);
					dispatchEvent (event);
					
				}
				
			}).onComplete (function (data:ByteArray):Void {
				
				this.data = data;
				
				var event = new Event (Event.COMPLETE);
				dispatchEvent (event);
				
			});
			
		} else {
			
			var httpRequest = new HTTPRequest<String> ();
			__prepareRequest (httpRequest, request);
			
			httpRequest.load ().onProgress (function (progress:Float):Void {
				
				// TODO: Need total download size
				
				var event = new ProgressEvent (ProgressEvent.PROGRESS);
				event.bytesLoaded = progress * 100;
				event.bytesTotal = 100;
				dispatchEvent (event);
				
			}).onError (function (error:Dynamic):Void {
				
				if (error == 403) {
					
					var event = new SecurityErrorEvent (SecurityErrorEvent.SECURITY_ERROR);
					dispatchEvent (event);
					
				} else {
					
					var event = new IOErrorEvent (IOErrorEvent.IO_ERROR);
					dispatchEvent (event);
					
				}
				
			}).onComplete (function (data:String):Void {
				
				this.data = data;
				
				var event = new Event (Event.COMPLETE);
				dispatchEvent (event);
				
			});
			
		}
		
	}
	
	
	private function __prepareRequest (httpRequest:_IHTTPRequest, request:URLRequest):Void {
		
		__httpRequest = httpRequest;
		__httpRequest.uri = request.url;
		
		__httpRequest.method = switch (request.method) {
			
			case URLRequestMethod.DELETE: DELETE;
			case URLRequestMethod.HEAD: HEAD;
			case URLRequestMethod.OPTIONS: OPTIONS;
			case URLRequestMethod.POST: POST;
			case URLRequestMethod.PUT: PUT;
			default: GET;
			
		}
		
		if (request.data != null) {
			
			if (Std.is (request.data, URLVariables)) {
				
				var fields = Reflect.fields (request.data);
				
				for (field in fields) {
					
					__httpRequest.formData.set (field, Reflect.field (request.data, field));
					
				}
				
			} else if (Std.is (request.data, Bytes)) {
				
				__httpRequest.data = request.data;
				
			} else {
				
				__httpRequest.data = Bytes.ofString (Std.string (request.data));
				
			}
			
		}
		
		__httpRequest.contentType = request.contentType;
		
		if (request.requestHeaders != null) {
			
			for (header in request.requestHeaders) {
				
				__httpRequest.headers.push (new HTTPRequestHeader (header.name, header.value));
				
			}
			
		}
		
		__httpRequest.userAgent = request.userAgent;
		
	}
	
	
}