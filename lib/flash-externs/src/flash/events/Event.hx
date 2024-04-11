package flash.events;

#if flash
import openfl.utils.Object;

extern class Event
{
	public static var ACTIVATE(default, never):String;
	public static var ADDED(default, never):String;
	public static var ADDED_TO_STAGE(default, never):String;
	@:require(flash15) public static var BROWSER_ZOOM_CHANGE(default, never):String;
	public static var CANCEL(default, never):String;
	public static var CHANGE(default, never):String;
	public static var CHANNEL_MESSAGE(default, never):String;
	public static var CHANNEL_STATE(default, never):String;
	@:require(flash10) public static var CLEAR(default, never):String;
	public static var CLOSE(default, never):String;
	#if air
	public static var CLOSING(default, never):String;
	#end
	public static var COMPLETE(default, never):String;
	public static var CONNECT(default, never):String;
	@:require(flash11) public static var CONTEXT3D_CREATE(default, never):String;
	@:require(flash10) public static var COPY(default, never):String;
	@:require(flash10) public static var CUT(default, never):String;
	public static var DEACTIVATE(default, never):String;
	#if air
	public static var DISPLAYING(default, never):String;
	#end
	public static var ENTER_FRAME(default, never):String;
	#if air
	public static var EXITING(default, never):String;
	#end
	@:require(flash10) public static var EXIT_FRAME(default, never):String;
	@:require(flash10) public static var FRAME_CONSTRUCTED(default, never):String;
	@:require(flash11_3) public static var FRAME_LABEL(default, never):String;
	public static var FULLSCREEN(default, never):String;
	#if air
	public static var HTML_BOUNDS_CHANGE(default, never):String;
	public static var HTML_DOM_INITIALIZE(default, never):String;
	public static var HTML_RENDER(default, never):String;
	#end
	public static var ID3(default, never):String;
	public static var INIT(default, never):String;
	#if air
	public static var LOCATION_CHANGE(default, never):String;
	#end
	public static var MOUSE_LEAVE(default, never):String;
	#if air
	public static var NETWORK_CHANGE(default, never):String;
	#end
	public static var OPEN(default, never):String;
	@:require(flash10) public static var PASTE(default, never):String;
	#if air
	public static var PREPARING(default, never):String;
	#end
	public static var REMOVED(default, never):String;
	public static var REMOVED_FROM_STAGE(default, never):String;
	public static var RENDER(default, never):String;
	public static var RESIZE(default, never):String;
	public static var SCROLL(default, never):String;
	public static var SELECT(default, never):String;
	@:require(flash10) public static var SELECT_ALL(default, never):String;
	public static var SOUND_COMPLETE(default, never):String;
	#if air
	public static var STANDARD_ERROR_CLOSE(default, never):String;
	public static var STANDARD_INPUT_CLOSE(default, never):String;
	public static var STANDARD_OUTPUT_CLOSE(default, never):String;
	#end
	@:require(flash11_3) public static var SUSPEND(default, never):String;
	public static var TAB_CHILDREN_CHANGE(default, never):String;
	public static var TAB_ENABLED_CHANGE(default, never):String;
	public static var TAB_INDEX_CHANGE(default, never):String;
	@:require(flash11_3) public static var TEXTURE_READY(default, never):String;
	@:require(flash11) public static var TEXT_INTERACTION_MODE_CHANGE(default, never):String;
	public static var UNLOAD(default, never):String;
	#if air
	public static var USER_IDLE(default, never):String;
	public static var USER_PRESENT(default, never):String;
	#end
	public static var VIDEO_FRAME(default, never):String;
	public static var WORKER_STATE(default, never):String;

	#if (haxe_ver < 4.3)
	public var bubbles(default, never):Bool;
	public var cancelable(default, never):Bool;
	public var currentTarget(default, never):Object;
	public var eventPhase(default, never):EventPhase;
	public var target(default, never):Object;
	public var type(default, never):String;
	#else
	@:flash.property var bubbles(get, never):Bool;
	@:flash.property var cancelable(get, never):Bool;
	@:flash.property var currentTarget(get, never):Object;
	@:flash.property var eventPhase(get, never):EventPhase;
	@:flash.property var target(get, never):Object;
	@:flash.property var type(get, never):String;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false);
	public function clone():Event;
	public function formatToString(className:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):String;
	public function isDefaultPrevented():Bool;
	public function preventDefault():Void;
	public function stopImmediatePropagation():Void;
	public function stopPropagation():Void;
	public function toString():String;

	#if (haxe_ver >= 4.3)
	private function get_bubbles():Bool;
	private function get_cancelable():Bool;
	private function get_currentTarget():Object;
	private function get_eventPhase():EventPhase;
	private function get_target():Object;
	private function get_type():String;
	#end
}
#else
typedef Event = openfl.events.Event;
#end
