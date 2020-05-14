package openfl.ui;

import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events._EventDispatcher;
import openfl.events.EventType;
import openfl.events.GameInputEvent;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.ui.GameInputControl)
@:access(openfl.ui.GameInputDevice)
@:noCompletion
class _GameInput extends _EventDispatcher
{
	public static var isSupported = true;
	public static var numDevices = 0;

	public static var __deviceList:Array<GameInputDevice> = new Array();
	public static var __instances:Array<GameInput> = [];

	private var gameInput:GameInput;

	public function new(gameInput:GameInput)
	{
		this.gameInput = gameInput;

		super(gameInput);

		__instances.push(gameInput);
	}

	public override function addEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false, priority:Int = 0,
			useWeakReference:Bool = false):Void
	{
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);

		if (type == GameInputEvent.DEVICE_ADDED)
		{
			for (device in __deviceList)
			{
				dispatchEvent(new GameInputEvent(GameInputEvent.DEVICE_ADDED, true, false, device));
			}
		}
	}

	public static function getDeviceAt(index:Int):GameInputDevice
	{
		if (index >= 0 && index < __deviceList.length)
		{
			return __deviceList[index];
		}

		return null;
	}

	public static function __addInputDevice(device:GameInputDevice):Void
	{
		__deviceList.push(device);
		numDevices = __deviceList.length;

		for (instance in __instances)
		{
			instance.dispatchEvent(new GameInputEvent(GameInputEvent.DEVICE_ADDED, true, false, device));
		}
	}

	public static function __removeInputDevice(device:GameInputDevice):Void
	{
		__deviceList.remove(device);
		numDevices = __deviceList.length;

		for (instance in __instances)
		{
			instance.dispatchEvent(new GameInputEvent(GameInputEvent.DEVICE_REMOVED, true, false, device));
		}
	}
}
