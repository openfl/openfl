package openfl.events;

#if !flash
// import openfl.utils.ObjectPool;

/**
	The Stage object dispatches a FullScreenEvent object whenever the Stage
	enters or leaves full-screen display mode. There is only one type of
	`fullScreen` event: `FullScreenEvent.FULL_SCREEN`.

**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FullScreenEvent extends ActivityEvent
{
	/**
		The `FullScreenEvent.FULL_SCREEN` constant defines the value of the
		`type` property of a `fullScreen` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `fullScreen` | `true` if the display state is full screen or `false` if it is normal. |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The Stage object. |
	**/
	public static inline var FULL_SCREEN:EventType<FullScreenEvent> = "fullScreen";

	/**
		The `FULL_SCREEN_INTERACTIVE_ACCEPTED:String` constant defines the value of the
		type property of a `fullScreenInteractiveAccepted` event object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `fullScreen` | `true` if the display state is full screen or `false` if it is normal. |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The Stage object. |
	**/
	public static inline var FULL_SCREEN_INTERACTIVE_ACCEPTED:EventType<FullScreenEvent> = "fullScreenInteractiveAccepted";

	/**
		Indicates whether the Stage object is in full-screen mode (`true`) or
		not (`false`).
	**/
	public var fullScreen:Bool;

	/**
		Indicates whether the Stage object is in full-screen interactive mode (`true`) or
		not (`false`).
	**/
	public var interactive:Bool;

	// @:noCompletion private static var __pool:ObjectPool<FullScreenEvent> = new ObjectPool<FullScreenEvent>(function() return new FullScreenEvent(null),
	// function(event) event.__init());

	/**
		Creates an event object that contains information about `fullScreen`
		events. Event objects are passed as parameters to event listeners.

		@param type       The type of the event. Event listeners can access
						  this information through the inherited `type`
						  property. There is only one type of `fullScreen`
						  event: `FullScreenEvent.FULL_SCREEN`.
		@param bubbles    Determines whether the Event object participates in
						  the bubbling phase of the event flow. Event
						  listeners can access this information through the
						  inherited `bubbles` property.
		@param cancelable Determines whether the Event object can be canceled.
						  Event listeners can access this information through
						  the inherited `cancelable` property.
		@param fullScreen Indicates whether the device is activating (`true`)
						  or deactivating (`false`). Event listeners can
						  access this information through the `activating`
						  property.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, fullScreen:Bool = false, interactive:Bool = false)
	{
		// TODO: What is the "activating" value supposed to be?

		super(type, bubbles, cancelable);

		this.fullScreen = fullScreen;
		this.interactive = interactive;
	}

	public override function clone():FullScreenEvent
	{
		var event = new FullScreenEvent(type, bubbles, cancelable, fullScreen, interactive);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("FullscreenEvent", ["type", "bubbles", "cancelable", "fullscreen", "interactive"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		fullScreen = false;
		interactive = false;
	}
}
#else
typedef FullScreenEvent = flash.events.FullScreenEvent;
#end
