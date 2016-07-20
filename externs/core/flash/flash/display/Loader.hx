package flash.display; #if (!display && flash)


import openfl.events.UncaughtErrorEvents;
import openfl.net.URLRequest;
import openfl.system.LoaderContext;
import openfl.utils.ByteArray;


extern class Loader extends DisplayObjectContainer {
	
	
	public var content (default, null):DisplayObject;
	public var contentLoaderInfo (default, null):LoaderInfo;
	
	#if flash
	@:require(flash10_1) public var uncaughtErrorEvents (default, null):UncaughtErrorEvents;
	#end
	
	public function new ();
	public function close ():Void;
	public function load (request:URLRequest, context:LoaderContext = null):Void;
	public function loadBytes (buffer:ByteArray, context:LoaderContext = null):Void;
	public function unload ():Void;
	@:require(flash10) public function unloadAndStop (gc:Bool = true):Void;
	
	
}


#else
typedef Loader = openfl.display.Loader;
#end