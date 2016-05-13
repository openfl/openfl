package openfl.display; #if !openfl_legacy


import lime.system.BackgroundWorker;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.geom.Rectangle;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.system.LoaderContext;
import openfl.utils.ByteArray;

@:access(openfl.display.LoaderInfo)
@:access(openfl.events.Event)


class Loader extends DisplayObjectContainer {
	
	
	public var content (default, null):DisplayObject;
	public var contentLoaderInfo (default, null):LoaderInfo;
	
	private var mImage:BitmapData;
	private var mShape:Shape;
	
	
	public function new () {
		
		super ();
		
		contentLoaderInfo = LoaderInfo.create (this);
		
	}
	
	
	public function close ():Void {
		
		openfl.Lib.notImplemented ("Loader.close");
		
	}
	
	
	public function load (request:URLRequest, context:LoaderContext = null):Void {
		
		var extension = "";
		var parts = request.url.split (".");
		
		if (parts.length > 0) {
			
			extension = parts[parts.length - 1].toLowerCase ();
			
		}
		
		if (extension.indexOf ('?') != -1) {
			
			extension = extension.split ('?')[0];
			
		}
		
		var transparent = true;
		
		contentLoaderInfo.url = request.url;
		
		if (request.contentType == null || request.contentType == "") {
			
			contentLoaderInfo.contentType = switch (extension) {
				
				case "swf": "application/x-shockwave-flash";
				case "jpg", "jpeg": transparent = false; "image/jpeg";
				case "png": "image/png";
				case "gif": "image/gif";
				default: "application/x-www-form-urlencoded"; /*throw "Unrecognized file " + request.url;*/
				
			}
			
		} else {
			
			contentLoaderInfo.contentType = request.contentType;
			
		}
		
		#if sys
		if (request.url != null && request.url.indexOf ("http://") > -1 || request.url.indexOf ("https://") > -1) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (e) {
				
				BitmapData_onLoad (BitmapData.fromBytes (loader.data));
				
			});
			loader.addEventListener (IOErrorEvent.IO_ERROR, function (e) {
				
				BitmapData_onError (e);
				
			});
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load (request);
			return;
			
		} else 
		#end
		{
			
			var worker = new BackgroundWorker ();
			
			worker.doWork.add (function (_) {
				
				var path = request.url;
				
				#if sys
				var index = path.indexOf ("?");
				
				if (index > -1) {
					
					path = path.substring (0, index);
					
				}
				#end
				
				BitmapData.fromFile (path, function (bitmapData) worker.sendComplete (bitmapData), function () worker.sendError (IOErrorEvent.IO_ERROR));
				
			});
			
			worker.onError.add (BitmapData_onError);
			worker.onComplete.add (BitmapData_onLoad);
			worker.run ();
			
		}
		
	}
	
	
	public function loadBytes (buffer:ByteArray, context:LoaderContext = null):Void {
		
		var worker = new BackgroundWorker ();
		
		worker.doWork.add (function (_) {
			
			BitmapData.fromBytes (buffer, function (bitmapData) worker.sendComplete (bitmapData));
			
		});
		
		worker.onComplete.add (BitmapData_onLoad);
		worker.run ();
		
	}
	
	
	public function unload ():Void {
		
		if (numChildren > 0) {
			
			while (numChildren > 0) {
				
				removeChildAt (0);
				
			}
			
			content = null;
			contentLoaderInfo.url = null;
			contentLoaderInfo.contentType = null;
			contentLoaderInfo.content = null;
			contentLoaderInfo.bytesLoaded = 0;
			contentLoaderInfo.bytesTotal = 0;
			contentLoaderInfo.width = 0;
			contentLoaderInfo.height = 0;
			
			var event = new Event (Event.UNLOAD);
			event.currentTarget = this;
			__dispatchEvent (event);
			
		}
		
	}
	
	
	public function unloadAndStop (gc:Bool = true):Void {
		
		openfl.Lib.notImplemented ("Loader.unloadAndStop");
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function BitmapData_onLoad (bitmapData:BitmapData):Void {
		
		contentLoaderInfo.content = new Bitmap (bitmapData);
		content = contentLoaderInfo.content;
		addChild (contentLoaderInfo.content);
		
		var event = new Event (Event.COMPLETE);
		event.target = contentLoaderInfo;
		event.currentTarget = contentLoaderInfo;
		contentLoaderInfo.dispatchEvent (event);
		
	}
	
	
	private function BitmapData_onError (_):Void {
		
		var event = new IOErrorEvent (IOErrorEvent.IO_ERROR);
		event.target = contentLoaderInfo;
		event.currentTarget = contentLoaderInfo;
		contentLoaderInfo.dispatchEvent (event);
		
	}
	
	
}


#else
typedef Loader = openfl._legacy.display.Loader;
#end
