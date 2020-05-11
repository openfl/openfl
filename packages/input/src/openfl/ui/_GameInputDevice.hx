package openfl.ui;

import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.ui.GameInputControl)
@:noCompletion
class _GameInputDevice
{
	public static inline var MAX_BUFFER_SIZE:Int = 32000;

	public var enabled:Bool;
	public var id:String;
	public var name:String;
	public var numControls(get, never):Int;
	public var sampleInterval:Int;

	public var __axis:Map<Int, GameInputControl> = new Map();
	public var __button:Map<Int, GameInputControl> = new Map();
	public var __controls:Array<GameInputControl> = new Array();

	public function new(id:String, name:String)
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

	private function get_numControls():Int
	{
		return __controls.length;
	}
}
