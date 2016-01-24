package flash.events; #if (!display && flash)


extern class Event {
	
	
	public static var ACTIVATE:String;
	public static var ADDED:String;
	public static var ADDED_TO_STAGE:String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash15) public static var BROWSER_ZOOM_CHANGE:String;
	#end
	
	public static var CANCEL:String;
	public static var CHANGE:String;
	
	#if flash
	@:noCompletion @:dox(hide) public static var CHANNEL_MESSAGE:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var CHANNEL_STATE:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var CLEAR:String;
	#end
	
	public static var CLOSE:String;
	public static var COMPLETE:String;
	public static var CONNECT:String;
	
	@:require(flash11) public static var CONTEXT3D_CREATE:String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var COPY:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var CUT:String;
	#end
	
	public static var DEACTIVATE:String;
	public static var ENTER_FRAME:String;
	#if air
	public static var EXITING : String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var EXIT_FRAME:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var FRAME_CONSTRUCTED:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public static var FRAME_LABEL:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var FULLSCREEN:String;
	#end
	
	public static var ID3:String;
	public static var INIT:String;
	public static var MOUSE_LEAVE:String;
	public static var OPEN:String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var PASTE:String;
	#end
	
	public static var REMOVED:String;
	public static var REMOVED_FROM_STAGE:String;
	public static var RENDER:String;
	public static var RESIZE:String;
	public static var SCROLL:String;
	public static var SELECT:String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var SELECT_ALL:String;
	#end
	
	public static var SOUND_COMPLETE:String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public static var SUSPEND:String;
	#end
	
	public static var TAB_CHILDREN_CHANGE:String;
	public static var TAB_ENABLED_CHANGE:String;
	public static var TAB_INDEX_CHANGE:String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public static var TEXTURE_READY:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public static var TEXT_INTERACTION_MODE_CHANGE:String;
	#end
	
	public static var UNLOAD:String;
	
	#if flash
	@:noCompletion @:dox(hide) public static var VIDEO_FRAME:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var WORKER_STATE:String;
	#end
	
	public var bubbles (default, null):Bool;
	public var cancelable (default, null):Bool;
	public var currentTarget (default, null):Dynamic;
	public var eventPhase (default, null):EventPhase;
	public var target (default, null):Dynamic;
	public var type (default, null):String;
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false);
	public function clone ():Event;
	public function formatToString (className:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):String;
	public function isDefaultPrevented ():Bool;
	public function preventDefault ():Void;
	public function stopImmediatePropagation ():Void;
	public function stopPropagation ():Void;
	public function toString ():String;
	
	
}


#else
typedef Event = openfl.events.Event;
#end