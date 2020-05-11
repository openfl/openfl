package openfl.ui;

import openfl.events.EventDispatcher;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _GameInputControl extends _EventDispatcher
{
	public var device:GameInputDevice;
	public var id:String;
	public var maxValue:Float;
	public var minValue:Float;
	public var value:Float;

	public function new(device:GameInputDevice, id:String, minValue:Float, maxValue:Float, value:Float = 0)
	{
		super();

		this.device = device;
		this.id = id;
		this.minValue = minValue;
		this.maxValue = maxValue;
		this.value = value;
	}
}
