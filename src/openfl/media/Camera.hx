package openfl.media;

#if !flash
import openfl.events.EventDispatcher;

/**
	OpenFL has no camera input: `isSupported` is false and `getCamera()`
	returns null. The class lets code written for Flash and AIR, such as
	Starling's `Texture.fromCamera`, compile.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Camera extends EventDispatcher
{
	/**
		Whether the Camera class is supported on the current platform: always false.
	**/
	public static var isSupported(default, never):Bool = false;

	/**
		The names of the available cameras: always empty.
	**/
	public static var names(get, never):Array<String>;

	/**
		The current capture height, in pixels.
	**/
	public var height(default, null):Int = 0;

	/**
		The current capture width, in pixels.
	**/
	public var width(default, null):Int = 0;

	@:noCompletion private function new()
	{
		super();
	}

	/**
		Returns a reference to a Camera object for capturing video: always null.
	**/
	public static function getCamera(name:String = null):Camera
	{
		return null;
	}

	@:noCompletion private static function get_names():Array<String>
	{
		return [];
	}
}
#else
typedef Camera = flash.media.Camera;
#end
