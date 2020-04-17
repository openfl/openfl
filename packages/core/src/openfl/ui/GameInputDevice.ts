import * as internal from "../_internal/utils/InternalAccess";
import GameInputControl from "../ui/GameInputControl";
import ByteArray from "../utils/ByteArray";
import Vector from "../Vector";

export default class GameInputDevice
{
	/**
		Specifies the maximum size for the buffer used to cache sampled control values.
		If `startCachingSamples` returns samples that require more memory than you specify,
		it throws a memory error.
	**/
	public static readonly MAX_BUFFER_SIZE: number = 32000;

	/**
		Returns the ID of this device.
	**/
	public readonly id: string;

	/**
		Enables or disables this device.
	**/
	public enabled: boolean;

	/**
		Returns the name of this device.
	**/
	public readonly name: string;

	/**
		Specifies the rate (in milliseconds) at which to retrieve control values.
	**/
	public sampleInterval: number;

	protected __axis: Map<number, GameInputControl> = new Map();
	protected __button: Map<number, GameInputControl> = new Map();
	protected __controls: Array<GameInputControl> = new Array();

	private constructor(id: string, name: string)
	{
		this.id = id;
		this.name = name;

		var control;

		for (let i = 0; i < 6; i++)
		{
			control = new (<internal.GameInputControl><any>GameInputControl)(this, "AXIS_" + i, -1, 1);
			this.__axis.set(i, control);
			this.__controls.push(control);
		}

		for (let i = 0; i < 15; i++)
		{
			control = new (<internal.GameInputControl><any>GameInputControl)(this, "BUTTON_" + i, 0, 1);
			this.__button.set(i, control);
			this.__controls.push(control);
		}
	}

	/**
		Writes cached sample values to the ByteArray.
		@param	data
		@param	append
		@return
	**/
	public getCachedSamples(data: ByteArray, append: boolean = false): number
	{
		return 0;
	}

	/**
		Retrieves a specific control from a device.
		@param	i
		@return
	**/
	public getControlAt(i: number): GameInputControl
	{
		if (i >= 0 && i < this.__controls.length)
		{
			return this.__controls[i];
		}

		return null;
	}

	/**
		Requests this device to start keeping a cache of sampled values.
		@param	numSamples
		@param	controls
	**/
	public startCachingSamples(numSamples: number, controls: Vector<string>): void { }

	/**
		Stops sample caching.
	**/
	public stopCachingSamples(): void { }

	// Get & Set Methods

	/**
		Returns the number of controls on this device.
	**/
	public get numControls(): number
	{
		return this.__controls.length;
	}
}
