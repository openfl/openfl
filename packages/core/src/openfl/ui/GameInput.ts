import EventDispatcher from "../events/EventDispatcher";
import EventType from "../events/EventType";
import GameInputEvent from "../events/GameInputEvent";
import GameInputDevice from "../ui/GameInputDevice";

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
export default class GameInput extends EventDispatcher
{
	/**
		Indicates whether the current platform supports the GameInput API.
	**/
	public static readonly isSupported = true;

	protected static __deviceList: Array<GameInputDevice> = new Array();
	protected static __instances: Array<GameInput> = [];

	public constructor()
	{
		super();

		GameInput.__instances.push(this);
	}


	public addEventListener<T>(type: EventType<T>, listener: (event: T) => void, useCapture: boolean = false, priority: number = 0,
		useWeakReference: boolean = false): void
	{
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);

		if (type == GameInputEvent.DEVICE_ADDED)
		{
			for (let device of GameInput.__deviceList)
			{
				this.dispatchEvent(new GameInputEvent(GameInputEvent.DEVICE_ADDED, true, false, device));
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
	public static getDeviceAt(index: number): GameInputDevice
	{
		if (index >= 0 && index < GameInput.__deviceList.length)
		{
			return GameInput.__deviceList[index];
		}

		return null;
	}

	protected static __addInputDevice(device: GameInputDevice): void
	{
		GameInput.__deviceList.push(device);

		for (let instance of GameInput.__instances)
		{
			instance.dispatchEvent(new GameInputEvent(GameInputEvent.DEVICE_ADDED, true, false, device));
		}
	}

	protected static __removeInputDevice(device: GameInputDevice): void
	{
		let index = GameInput.__deviceList.indexOf(device);
		if (index > -1) GameInput.__deviceList.splice(index, 1);

		for (let instance of GameInput.__instances)
		{
			instance.dispatchEvent(new GameInputEvent(GameInputEvent.DEVICE_REMOVED, true, false, device));
		}
	}

	// Get & Set Methods

	/**
		Provides the number of connected input devices. When a device is connected, the
		`GameInputEvent.DEVICE_ADDED` event is fired.
	**/
	public static get numDevices(): number
	{
		return GameInput.__deviceList.length;
	}
}
