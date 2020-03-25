import ByteArray from "openfl/utils/ByteArray";

export default class GameInputDevice
{
	/**
		Specifies the maximum size for the buffer used to cache sampled control values.
		If `startCachingSamples` returns samples that require more memory than you specify,
		it throws a memory error.
	**/
	public static readonly MAX_BUFFER_SIZE: number = 32000;

	/**
		Enables or disables this device.
	**/
	public enabled: boolean;

	/**
		Returns the ID of this device.
	**/
	public id(default , null): string;

	/**
		Returns the name of this device.
	**/
	public name(default , null): string;

	/**
		Returns the number of controls on this device.
	**/
	public numControls(get, never): number;

	/**
		Specifies the rate (in milliseconds) at which to retrieve control values.
	**/
	public sampleInterval: number;

	protected __axis: Map<Int, GameInputControl> = new Map();
	protected __button: Map<Int, GameInputControl> = new Map();
	protected __controls: Array<GameInputControl> = new Array();

	protected new(id: string, name: string)
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
		if (i >= 0 && i < __controls.length)
		{
			return __controls[i];
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
	protected get_numControls(): number
	{
		return __controls.length;
	}
}
