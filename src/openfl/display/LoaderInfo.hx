package openfl.display;


import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.events.UncaughtErrorEvents;
import openfl.system.ApplicationDomain;
import openfl.utils.ByteArray;

#if (js && html5)
import js.Browser;
#end


class LoaderInfo extends EventDispatcher {
	
	
	private static var __rootURL = #if (js && html5) (Browser.supported ? Browser.document.URL : "") #else "" #end;
	
	public var applicationDomain (default, null):ApplicationDomain;
	public var bytes (default, null):ByteArray;
	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	public var childAllowsParent (default, null):Bool;
	public var content (default, null):DisplayObject;
	public var contentType (default, null):String;
	public var frameRate (default, null):Float;
	public var height (default, null):Int;
	public var loader (default, null):Loader;
	public var loaderURL (default, null):String;
	public var parameters (default, null):Dynamic<String>;
	public var parentAllowsChild (default, null):Bool;
	public var sameDomain (default, null):Bool;
	public var sharedEvents (default, null):EventDispatcher;
	public var uncaughtErrorEvents (default, null):UncaughtErrorEvents;
	public var url (default, null):String;
	public var width (default, null):Int;
	//static function getLoaderInfoByDefinition(object : Dynamic) : LoaderInfo;
	
	private var __completed:Bool;
	
	
	private function new () {
		
		super ();
		
		applicationDomain = ApplicationDomain.currentDomain;
		bytesLoaded = 0;
		bytesTotal = 0;
		childAllowsParent = true;
		parameters = {};
		
	}
	
	
	public static function create (loader:Loader):LoaderInfo {
		
		var loaderInfo = new LoaderInfo ();
		loaderInfo.uncaughtErrorEvents = new UncaughtErrorEvents ();
		
		if (loader != null) {
			
			loaderInfo.loader = loader;
			
		} else {
			
			loaderInfo.url = __rootURL;
			
		}
		
		return loaderInfo;
		
	}
	
	
	private function __complete ():Void {
		
		if (!__completed) {
			
			if (bytesLoaded < bytesTotal) {
				
				bytesLoaded = bytesTotal;
				
			}
			
			__update (bytesLoaded, bytesTotal);
			__completed = true;
			
			dispatchEvent (new Event (Event.COMPLETE));
			
		}
		
	}
	
	
	private function __update (bytesLoaded:Int, bytesTotal:Int):Void {
		
		this.bytesLoaded = bytesLoaded;
		this.bytesTotal = bytesTotal;
		
		dispatchEvent (new ProgressEvent (ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
		
	}
	
	
}