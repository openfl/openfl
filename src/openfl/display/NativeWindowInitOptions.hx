package openfl.display;

#if (!flash && sys)
/**
**/
class NativeWindowInitOptions
{
	/**
	**/
	public function new() {}

	/**
	**/
	public var maximizable:Bool = true;

	/**
	**/
	public var minimizable:Bool = true;

	/**
	**/
	public var owner:NativeWindow = null;

	/**
	**/
	public var renderMode:String = null;

	/**
	**/
	public var resizable:Bool = true;

	/**
	**/
	public var systemChrome:NativeWindowSystemChrome = NativeWindowSystemChrome.STANDARD;

	/**
	**/
	public var transparent:Bool = false;

	/**
	**/
	public var type:NativeWindowType = NativeWindowType.NORMAL;

	// used by openfl.display.Application for the initial window
	@:noCompletion private var __window:Window;
}
#else
#if air
typedef NativeWindowInitOptions = flash.display.NativeWindowInitOptions;
#end
#end
