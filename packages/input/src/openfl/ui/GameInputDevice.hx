package openfl.ui;

#if !flash
import openfl.utils.ByteArray;
#if lime
import lime.ui.Gamepad;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.ui.GameInputControl)
@:final class GameInputDevice
{
	public static inline var MAX_BUFFER_SIZE:Int = 32000;

	public var enabled:Bool;
	public var id(default, null):String;
	public var name(default, null):String;
	public var numControls(get, never):Int;
	public var sampleInterval:Int;

	@:noCompletion private var __axis:Map<Int, GameInputControl> = new Map();
	@:noCompletion private var __button:Map<Int, GameInputControl> = new Map();
	@:noCompletion private var __controls:Array<GameInputControl> = new Array();
	#if lime
	@:noCompletion private var __gamepad:Gamepad;
	#end

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(GameInputDevice.prototype, {
			"numControls": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_numControls (); }")},
		});
	}
	#end

	@:noCompletion private function new(id:String, name:String)
	{
		this.id = id;
		this.name = name;

		var control;

		for (i in 0...6)
		{
			control = new GameInputControl(this, "AXIS_" + i, -1, 1);
			__axis.set(i, control);
			__controls.push(control);
		}

		for (i in 0...15)
		{
			control = new GameInputControl(this, "BUTTON_" + i, 0, 1);
			__button.set(i, control);
			__controls.push(control);
		}
	}

	public function getCachedSamples(data:ByteArray, append:Bool = false):Int
	{
		return 0;
	}

	public function getControlAt(i:Int):GameInputControl
	{
		if (i >= 0 && i < __controls.length)
		{
			return __controls[i];
		}

		return null;
	}

	public function startCachingSamples(numSamples:Int, controls:Vector<String>):Void {}

	public function stopCachingSamples():Void {}

	// Get & Set Methods
	@:noCompletion private function get_numControls():Int
	{
		return __controls.length;
	}
}
#else
typedef GameInputDevice = flash.ui.GameInputDevice;
#end
