import EventDispatcher from "../events/EventDispatcher";
import GameInputDevice from "../ui/GameInputDevice";

export default class GameInputControl extends EventDispatcher
{
	/**
		Returns the GameInputDevice object that contains this control.
	**/
	public readonly device: GameInputDevice;

	/**
		Returns the id of this control.
	**/
	public readonly id: string;

	/**
		Returns the maximum value for this control.
	**/
	public readonly maxValue: number;

	/**
		Returns the minimum value for this control.
	**/
	public readonly minValue: number;

	/**
		Returns the value for this control.
	**/
	public readonly value: number;

	private constructor(device: GameInputDevice, id: string, minValue: number, maxValue: number, value: number = 0)
	{
		super();

		this.device = device;
		this.id = id;
		this.minValue = minValue;
		this.maxValue = maxValue;
		this.value = value;
	}
}
