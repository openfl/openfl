import ObjectPool from "../_internal/utils/ObjectPool";
import Event from "../events/Event";
import EventType from "../events/EventType";

/**
	Almost exactly StageVideoEvent.
**/
export default class VideoTextureEvent extends Event
{
	/**
		The `VideoTextureEvent.RENDER_STATE` constant defines the value of the `type`
		property of a `renderState` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `colorSpace` | The available color spaces for displaying the video. |
		| `currentTarget` | The object that is actively processing the StageVideoEvent object with an event listener. |
		| `status` | Indicates whether the video is being rendered (decoded and displayed) by hardware or software, or not at all. |
		| `target` | The VideoTexture object that changed state. |
	**/
	public static readonly RENDER_STATE: EventType<VideoTextureEvent> = "renderState";

	protected static __pool: ObjectPool<VideoTextureEvent> = new ObjectPool<VideoTextureEvent>(() => new VideoTextureEvent(null),
		(event) => event.__init());

	protected __colorSpace: string;
	protected __status: string;

	public constructor(type: string, bubbles: boolean = false, cancelable: boolean = false, status: string = null, colorSpace: string = null)
	{
		super(type, bubbles, cancelable);
		this.__status = status;
		this.__colorSpace = colorSpace;
	}

	public clone(): VideoTextureEvent
	{
		var event = new VideoTextureEvent(this.__type, this.__bubbles, this.__cancelable, this.__status, this.__colorSpace);
		event.__target = this.__target;
		event.__currentTarget = this.__currentTarget;
		event.__eventPhase = this.__eventPhase;
		return event;
	}

	public toString(): string
	{
		return this.formatToString("VideoTextureEvent", "type", "bubbles", "cancelable", "status", "colorSpace");
	}

	protected __init(): void
	{
		super.__init();
		this.__status = null;
		this.__colorSpace = null;
	}

	// Get & Set Methods

	/**
		The color space used by the video being displayed in the VideoTexture object.
	**/
	public get colorSpace(): string
	{
		return this.__colorSpace;
	}

	/**
		The status of the VideoTexture object.
	**/
	public get status(): string
	{
		return this.__status;
	}
}
