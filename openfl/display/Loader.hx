package openfl.display;


import lime.utils.AssetLibrary in LimeAssetLibrary;
import lime.utils.AssetManifest;
import openfl._internal.swf.SWFLiteLibrary;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.system.LoaderContext;
import openfl.utils.ByteArray;
import openfl.Assets;

#if (js && html5)
import js.html.ScriptElement;
import js.Browser;
#end

@:access(openfl.display.LoaderInfo)
@:access(openfl.events.Event)


class Loader extends DisplayObjectContainer {
	
	
	public var content (default, null):DisplayObject;
	public var contentLoaderInfo (default, null):LoaderInfo;
	
	
	public function new () {
		
		super ();
		
		contentLoaderInfo = LoaderInfo.create (this);
		
	}
	
	
	public function close ():Void {
		
		openfl.Lib.notImplemented ();
		
	}
	
	
	public function load (request:URLRequest, context:LoaderContext = null):Void {
		
		var loader = new URLLoader ();
		contentLoaderInfo.url = request.url;
		
		if (request.contentType == null || request.contentType == "") {
			
			var extension = "";
			var path = request.url;
			
			var queryIndex = path.indexOf ('?');
			if (queryIndex > -1) {
				
				path = path.substring (0, queryIndex);
				
			}
			
			var extIndex = path.lastIndexOf('.');
			if (extIndex > -1) {
				
				extension = path.substring(extIndex + 1);
				
			}
			
			contentLoaderInfo.contentType = switch (extension) {
				
				case "json": "application/json";
				case "swf": "application/x-shockwave-flash";
				case "jpg", "jpeg": "image/jpeg";
				case "png": "image/png";
				case "gif": "image/gif";
				case "js": "application/javascript";
				default: "application/x-www-form-urlencoded"; /*throw "Unrecognized file " + request.url;*/
				
			}
			
		} else {
			
			contentLoaderInfo.contentType = request.contentType;
			
		}
		
		loader.dataFormat = URLLoaderDataFormat.BINARY;
		
		if (contentLoaderInfo.contentType.indexOf ("/json") > -1 || contentLoaderInfo.contentType.indexOf ("/javascript") > -1 || contentLoaderInfo.contentType.indexOf ("/ecmascript") > -1) {
			
			loader.dataFormat = TEXT;
			
		}
		
		loader.addEventListener (Event.COMPLETE, loader_onComplete);
		loader.addEventListener (IOErrorEvent.IO_ERROR, loader_onError);
		loader.addEventListener (ProgressEvent.PROGRESS, loader_onProgress);
		loader.load (request);
		
	}
	
	
	public function loadBytes (buffer:ByteArray, context:LoaderContext = null):Void {
		
		BitmapData.loadFromBytes (buffer).onComplete (BitmapData_onLoad).onError (BitmapData_onError);
		
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
			
			dispatchEvent (new Event (Event.UNLOAD));
			
		}
		
	}
	
	
	public function unloadAndStop (gc:Bool = true):Void {
		
		if (content != null) {
			
			content.__stopAllMovieClips ();
			
		}
		
		for (i in 0...numChildren) {
			
			getChildAt (i).__stopAllMovieClips ();
			
		}
		
		unload ();
		
		if (gc) {
			
			#if cpp
			cpp.vm.Gc.run (false);
			#elseif neko
			neko.vm.Gc.run (false);
			#end
			
		}
		
	}
	
	
	private function __dispatchError (text:String):Void {
		
		var event = new IOErrorEvent (IOErrorEvent.IO_ERROR);
		event.text = text;
		dispatchEvent (event);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function BitmapData_onError (error:Dynamic):Void {
		
		__dispatchError (Std.string (error));
		
	}
	
	
	private function BitmapData_onLoad (bitmapData:BitmapData):Void {
		
		contentLoaderInfo.content = new Bitmap (bitmapData);
		content = contentLoaderInfo.content;
		addChild (content);
		
		contentLoaderInfo.dispatchEvent (new Event (Event.COMPLETE));
		
	}
	
	
	private function loader_onComplete (event:Event):Void {
		
		var loader:URLLoader = cast event.target;
		
		if (contentLoaderInfo.contentType.indexOf ("/json") > -1) {
			
			var manifest = AssetManifest.parse (loader.data);
			
			if (manifest == null) {
				
				__dispatchError ("Cannot parse asset manifest");
				return;
				
			}
			
			var library = LimeAssetLibrary.fromManifest (manifest);
			
			if (library == null) {
				
				__dispatchError ("Cannot open library");
				return;
				
			}
			
			if (Std.is (library, AssetLibrary)) {
				
				contentLoaderInfo.content = cast (library, AssetLibrary).getMovieClip ("");
				addChild (contentLoaderInfo.content);
				
				contentLoaderInfo.dispatchEvent (new Event (Event.COMPLETE));
				
			}
			
		} else if (contentLoaderInfo.contentType.indexOf ("/javascript") > -1 || contentLoaderInfo.contentType.indexOf ("/ecmascript") > -1) {
			
			contentLoaderInfo.content = new Sprite ();
			addChild (contentLoaderInfo.content);
			
			#if (js && html5)
			//var script:ScriptElement = cast Browser.document.createElement ("script");
			//script.innerHTML = loader.data;
			//Browser.document.head.appendChild (script);
			
			untyped __js__ ("eval") ('(function () {' + loader.data + '})()');
			#end
			
			contentLoaderInfo.dispatchEvent (new Event (Event.COMPLETE));
			
		} else {
			
			BitmapData.loadFromBytes (loader.data).onComplete (BitmapData_onLoad).onError (BitmapData_onError);
			
		}
		
	}
	
	
	private function loader_onError (event:IOErrorEvent):Void {
		
		event.target = contentLoaderInfo;
		contentLoaderInfo.dispatchEvent (event);
		
	}
	
	
	private function loader_onProgress (event:ProgressEvent):Void {
		
		event.target = contentLoaderInfo;
		contentLoaderInfo.dispatchEvent (event);
		
	}
	
	
}