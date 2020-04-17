import ObjectPool from "../_internal/utils/ObjectPool";
import Event from "../events/Event";
import EventType from "../events/EventType";
import GameInputDevice from "../ui/GameInputDevice";

/**
	The GameInputEvent class represents an event that is dispatched when a game input device has either been added or removed from the application platform. A game input device also dispatches events when it is turned on or off.
**/
export default class GameInputEvent extends Event
{
	/**
		Indicates that a compatible device has been connected or turned on.
	**/
	public static readonly DEVICE_ADDED: EventType<GameInputEvent> = "deviceAdded";

	/**
		Indicates that one of the enumerated devices has been disconnected or turned off.
	**/
	public static readonly DEVICE_REMOVED: EventType<GameInputEvent> = "deviceRemoved";

	/**
		Dispatched when a game input device is connected but is not usable.
	**/
	public static readonly DEVICE_UNUSABLE: EventType<GameInputEvent> = "deviceUnusable";

	protected static __pool: ObjectPool<GameInputEvent> = new ObjectPool<GameInputEvent>(() => new GameInputEvent(null),
		(event) => event.__init());

	protected __device: GameInputDevice;

	public constructor(type: string, bubbles: boolean = true, cancelable: boolean = false, device: GameInputDevice = null)
	{
		super(type, bubbles, cancelable);

		this.__device = device;
	}

	public clone(): GameInputEvent
	{
		var event = new GameInputEvent(this.__type, this.__bubbles, this.__cancelable, this.__device);
		event.__target = this.__target;
		event.__currentTarget = this.__currentTarget;
		event.__eventPhase = this.__eventPhase;
		return event;
	}

	public toString(): string
	{
		return this.formatToString("GameInputEvent", "type", "bubbles", "cancelable", "device");
	}

	protected __init(): void
	{
		super.__init();
		this.__device = null;
	}

	// Get & Set Methods

	/**
		Returns a reference to the device that was added or removed. When a device is added, use this property to get a reference to the new device, instead of enumerating all of the devices to find the new one.
	**/
	public get device(): GameInputDevice
	{
		return this.__device;
	}
}
