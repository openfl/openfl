import EventDispatcher from "openfl/events/EventDispatcher";

export default class GameInputControl extends EventDispatcher
{
	/**
		Returns the GameInputDevice object that contains this control.
	**/
	public device(default , null): GameInputDevice;

	/**
		Returns the id of this control.
	**/
	public id(default , null): string;

	/**
		Returns the maximum value for this control.
	**/
	public maxValue(default , null): number;

	/**
		Returns the minimum value for this control.
	**/
	public minValue(default , null): number;

	/**
		Returns the value for this control.
	**/
	public value(default , null): number;

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
