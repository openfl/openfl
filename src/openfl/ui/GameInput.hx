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

/**
	The GameInput class is the entry point into the GameInput API. You can use this API to
	manage the communications between an application and game input devices (for example:
	joysticks, gamepads, and wands).

	The main purpose of this class is to provide access to the supported input devices that
	are connected to your application platform. This static class enumerates the connected
	input devices in a list. You access a device from the list using the
	`getDeviceAt(index:Int)` method.

	The `numDevices` property provides the number of input devices currently connected to
	your platform. Use this value to determine the upper bound of the list of devices.

	Use an instance of this class to listen for events that notify you about the addition
	and removal of input devices. To listen these events, do the following:

	1. Create an instance of the GameInput class.
	2. Add event listeners for the `GameInputEvent.DEVICE_ADDED` and
	`GameInputEvent.DEVICE_REMOVED` events. (Events can only be registered on an instance
	of the class.)

	This class also features the `isSupported` flag, which indicates whether the GameInput
	API is supported on your platform.

	For more information, see the Adobe Air Developer Center article: Game controllers on
	Adobe AIR.

	For Android, this feature supports a minimum Android OS version of 4.1 and requires the
	minimum SWF version 20 and namespace 3.7. For iOS, this feature supports a minimum iOS
	version of 9.0 and requires the minimum SWF version 34 and namespace 23.0.

	**How to Detect One Game Input Device From Among Identical Devices**

	A common requirement for two-or-more player games is detecting one device from among
	identical devices. For example, applications sometimes must determine which device
	represents "Player 1", "Player 2", ..., "Player N".

	Solution:

	1. Add event listeners to every control on all undetected input devices. These event
	listeners listen for `Event.CHANGE` events, which are dispatched whenever a control
	value changes.
	2. The first time any control is activated (for example a button press or trigger pull)
	the application labels that device.
	3. Remove all of the event listeners from the remaining undetected input devices.
	4. Repeat steps 1-3 as required to identify the rest of the undetected input devices.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.ui.GameInputControl)
@:access(openfl.ui.GameInputDevice)
@:final class GameInput extends EventDispatcher
{
	/**
		Indicates whether the current platform supports the GameInput API.
	**/
	public static var isSupported(default, null) = true;

	/**
		Provides the number of connected input devices. When a device is connected, the
		`GameInputEvent.DEVICE_ADDED` event is fired.
	**/
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

	/**
		Gets the input device at the specified index location in the list of connected
		input devices.

		The order of devices in the index may change whenever a device is added or removed.
		You can check the name and id properties on a GameInputDevice object to match a
		specific input device.

		@param	index	The index position in the list of input devices.
		@returns	The specified GameInputDevice.
		@throws	RangeError	When the provided index is less than zero or greater than
		(`numDevices` - 1).
	**/
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
