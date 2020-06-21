package openfl.ui;

#if !flash
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.EventType;
import openfl.events.GameInputEvent;
#if lime
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.ui.GameInputControl)
@:access(openfl.ui.GameInputDevice)
@:final class GameInput extends EventDispatcher
{
	public static var isSupported(default, null) = true;
	public static var numDevices(default, null) = 0;

	@:noCompletion private static var __deviceList:Array<GameInputDevice> = new Array();
	@:noCompletion private static var __instances:Array<GameInput> = [];
	#if lime
	@:noCompletion private static var __devices:Map<Gamepad, GameInputDevice> = new Map();
	#end

	public function new()
	{
		super();

		__instances.push(this);
	}

	@SuppressWarnings("checkstyle:Dynamic")
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

	#if lime
	@:noCompletion private static function __getDevice(gamepad:Gamepad):GameInputDevice
	{
		if (gamepad == null) return null;

		if (!__devices.exists(gamepad))
		{
			var device = new GameInputDevice(gamepad.guid, gamepad.name);
			__deviceList.push(device);
			__devices.set(gamepad, device);
			numDevices = __deviceList.length;
		}

		return __devices.get(gamepad);
	}
	#end

	#if lime
	@:noCompletion private static function __onGamepadAxisMove(gamepad:Gamepad, axis:GamepadAxis, value:Float):Void
	{
		var device = __getDevice(gamepad);
		if (device == null) return;

		if (device.enabled)
		{
			if (!device.__axis.exists(axis))
			{
				var control = new GameInputControl(device, "AXIS_" + axis, -1, 1);
				device.__axis.set(axis, control);
				device.__controls.push(control);
			}

			var control = device.__axis.get(axis);
			control.value = value;
			control.dispatchEvent(new Event(Event.CHANGE));
		}
	}
	#end

	#if lime
	@:noCompletion private static function __onGamepadButtonDown(gamepad:Gamepad, button:GamepadButton):Void
	{
		var device = __getDevice(gamepad);
		if (device == null) return;

		if (device.enabled)
		{
			if (!device.__button.exists(button))
			{
				var control = new GameInputControl(device, "BUTTON_" + button, 0, 1);
				device.__button.set(button, control);
				device.__controls.push(control);
			}

			var control = device.__button.get(button);
			control.value = 1;
			control.dispatchEvent(new Event(Event.CHANGE));
		}
	}
	#end

	#if lime
	@:noCompletion private static function __onGamepadButtonUp(gamepad:Gamepad, button:GamepadButton):Void
	{
		var device = __getDevice(gamepad);
		if (device == null) return;

		if (device.enabled)
		{
			if (!device.__button.exists(button))
			{
				var control = new GameInputControl(device, "BUTTON_" + button, 0, 1);
				device.__button.set(button, control);
				device.__controls.push(control);
			}

			var control = device.__button.get(button);
			control.value = 0;
			control.dispatchEvent(new Event(Event.CHANGE));
		}
	}
	#end

	#if lime
	@:noCompletion private static function __onGamepadConnect(gamepad:Gamepad):Void
	{
		var device = __getDevice(gamepad);
		if (device == null) return;

		for (instance in __instances)
		{
			instance.dispatchEvent(new GameInputEvent(GameInputEvent.DEVICE_ADDED, true, false, device));
		}
	}
	#end

	#if lime
	@:noCompletion private static function __onGamepadDisconnect(gamepad:Gamepad):Void
	{
		var device = __devices.get(gamepad);

		if (device != null)
		{
			if (__devices.exists(gamepad))
			{
				__deviceList.remove(__devices.get(gamepad));
				__devices.remove(gamepad);
			}

			numDevices = __deviceList.length;

			for (instance in __instances)
			{
				instance.dispatchEvent(new GameInputEvent(GameInputEvent.DEVICE_REMOVED, true, false, device));
			}
		}
	}
	#end
}
#else
typedef GameInput = flash.ui.GameInput;
#end
