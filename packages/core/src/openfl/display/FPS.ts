import Event from "../events/Event";
import TextField from "../text/TextField";
import TextFormat from "../text/TextFormat";
import Lib from "../Lib";

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
export default class FPS extends TextField
{
	protected cacheCount: number;
	protected __currentFPS: number;
	protected currentTime: number;
	protected times: Array<number>;

	public constructor(x: number = 10, y: number = 10, color: number = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		this.__currentFPS = 0;
		this.selectable = false;
		this.mouseEnabled = false;
		this.defaultTextFormat = new TextFormat("_sans", 12, color);
		this.text = "FPS: ";

		this.cacheCount = 0;
		this.currentTime = 0;
		this.times = [];

		// #if flash
		this.addEventListener(Event.ENTER_FRAME, (e) =>
		{
			var time = Lib.getTimer();
			this.__enterFrame(time - this.currentTime);
		});
		// #end
	}

	// Event Handlers

	private __enterFrame(deltaTime: number): void
	{
		this.currentTime += deltaTime;
		this.times.push(this.currentTime);

		while (this.times[0] < this.currentTime - 1000)
		{
			this.times.shift();
		}

		var currentCount = this.times.length;
		this.__currentFPS = Math.round((currentCount + this.cacheCount) / 2);

		if (currentCount != this.cacheCount /*&& visible*/)
		{
			this.text = "FPS: " + this.__currentFPS;
		}

		this.cacheCount = currentCount;
	}

	// Get & Set Methods

	/**
		The current frame rate, expressed using frames-per-second
	**/
	public get currentFPS(): number
	{
		return this.__currentFPS;
	}
}
