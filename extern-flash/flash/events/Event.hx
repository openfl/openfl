package flash.events; #if (!display && flash)


extern class Event {
	
	
	public static var ACTIVATE (default, never):String;
	public static var ADDED (default, never):String;
	public static var ADDED_TO_STAGE (default, never):String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash15) public static var BROWSER_ZOOM_CHANGE (default, never):String;
	#end
	
	public static var CANCEL (default, never):String;
	public static var CHANGE (default, never):String;
	
	#if flash
	@:noCompletion @:dox(hide) public static var CHANNEL_MESSAGE (default, never):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var CHANNEL_STATE (default, never):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var CLEAR (default, never):String;
	#end
	
	public static var CLOSE (default, never):String;
	public static var COMPLETE (default, never):String;
	public static var CONNECT (default, never):String;
	
	@:require(flash11) public static var CONTEXT3D_CREATE (default, never):String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var COPY (default, never):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var CUT (default, never):String;
	#end
	
	public static var DEACTIVATE (default, never):String;
	public static var ENTER_FRAME (default, never):String;
	
	#if air
	public static var EXITING : String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var EXIT_FRAME (default, never):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var FRAME_CONSTRUCTED (default, never):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public static var FRAME_LABEL (default, never):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var FULLSCREEN (default, never):String;
	#end
	
	public static var ID3 (default, never):String;
	public static var INIT (default, never):String;
	public static var MOUSE_LEAVE (default, never):String;
	public static var OPEN (default, never):String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var PASTE (default, never):String;
	#end
	
	public static var REMOVED (default, never):String;
	public static var REMOVED_FROM_STAGE (default, never):String;
	public static var RENDER (default, never):String;
	public static var RESIZE (default, never):String;
	public static var SCROLL (default, never):String;
	public static var SELECT (default, never):String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var SELECT_ALL (default, never):String;
	#end
	
	public static var SOUND_COMPLETE (default, never):String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public static var SUSPEND (default, never):String;
	#end
	
	public static var TAB_CHILDREN_CHANGE (default, never):String;
	public static var TAB_ENABLED_CHANGE (default, never):String;
	public static var TAB_INDEX_CHANGE (default, never):String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public static var TEXTURE_READY (default, never):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public static var TEXT_INTERACTION_MODE_CHANGE (default, never):String;
	#end
	
	public static var UNLOAD (default, never):String;
	
	#if flash
	@:noCompletion @:dox(hide) public static var VIDEO_FRAME (default, never):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var WORKER_STATE (default, never):String;
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
	
	#if (flash && air)
	static var NETWORK_CHANGE : String;
	static var STANDARD_OUTPUT_CLOSE : String;
	#end
}


#else
typedef Event = openfl.events.Event;
#end