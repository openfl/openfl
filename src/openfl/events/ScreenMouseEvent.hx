package openfl.events;

#if (!flash && sys)
/**
	The SystemTrayIcon object dispatches events of type ScreenMouseEvent in
	response to mouse interaction.

	The ScreenMouseEvent object extends the MouseEvent class to provide two
	additional properties, `screenX` and `screenY`, that report the mouse
	coordinates in relation to the primary desktop screen rather than an
	application window or stage.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ScreenMouseEvent extends MouseEvent
{
	/**
		Defines the value of the `type` property of a `click` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows). |
		| `bubbles` | `true` |
		| `buttonDown` | `true` if the primary mouse button is pressed; `false` otherwise.|
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `screenX` | The horizontal coordinate at which the event occurred in screen coordinates. |
		| `screenY` | The vertical coordinate at which the event occurred in screen coordinates. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `target` | The SystemTrayIcon instance under the pointing device. |
	**/
	public static inline var CLICK:EventType<ScreenMouseEvent> = "click";

	/**
		Defines the value of the `type` property of a `mouseDown` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows). |
		| `bubbles` | `true` |
		| `buttonDown` | `true` if the primary mouse button is pressed; `false` otherwise.|
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `screenX` | The horizontal coordinate at which the event occurred in screen coordinates. |
		| `screenY` | The vertical coordinate at which the event occurred in screen coordinates. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `target` | The SystemTrayIcon instance under the pointing device. |
	**/
	public static inline var MOUSE_DOWN:EventType<ScreenMouseEvent> = "mouseDown";

	/**
		Defines the value of the `type` property of a `mouseUp` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows). |
		| `bubbles` | `true` |
		| `buttonDown` | `true` if the primary mouse button is pressed; `false` otherwise.|
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `screenX` | The horizontal coordinate at which the event occurred in screen coordinates. |
		| `screenY` | The vertical coordinate at which the event occurred in screen coordinates. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `target` | The SystemTrayIcon instance under the pointing device. |
	**/
	public static inline var MOUSE_UP:EventType<ScreenMouseEvent> = "mouseUp";

	/**
		Defines the value of the `type` property of a `rightClick` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows). |
		| `bubbles` | `true` |
		| `buttonDown` | `true` if the primary mouse button is pressed; `false` otherwise.|
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `screenX` | The horizontal coordinate at which the event occurred in screen coordinates. |
		| `screenY` | The vertical coordinate at which the event occurred in screen coordinates. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `target` | The SystemTrayIcon instance under the pointing device. |
	**/
	public static inline var RIGHT_CLICK:EventType<ScreenMouseEvent> = "rightClick";

	/**
		Defines the value of the `type` property of a `rightMouseDown` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows). |
		| `bubbles` | `true` |
		| `buttonDown` | `true` if the primary mouse button is pressed; `false` otherwise.|
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `screenX` | The horizontal coordinate at which the event occurred in screen coordinates. |
		| `screenY` | The vertical coordinate at which the event occurred in screen coordinates. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `target` | The SystemTrayIcon instance under the pointing device. |
	**/
	public static inline var RIGHT_MOUSE_DOWN:EventType<ScreenMouseEvent> = "rightMouseDown";

	/**
		Defines the value of the `type` property of a `rightMouseUp` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `altKey` | `true` if the Alt key is active (Windows). |
		| `bubbles` | `true` |
		| `buttonDown` | `true` if the primary mouse button is pressed; `false` otherwise.|
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `commandKey` | `true` on the Mac if the Command key is active; `false` if it is inactive. Always `false` on Windows. |
		| `controlKey` | `true` if the Ctrl or Control key is active; `false` if it is inactive. |
		| `ctrlKey` | `true` on Windows or Linux if the Ctrl key is active. `true` on Mac if either the Ctrl key or the Command key is active. Otherwise, `false`. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `screenX` | The horizontal coordinate at which the event occurred in screen coordinates. |
		| `screenY` | The vertical coordinate at which the event occurred in screen coordinates. |
		| `shiftKey` | `true` if the Shift key is active; `false` if it is inactive. |
		| `target` | The SystemTrayIcon instance under the pointing device. |
	**/
	public static inline var RIGHT_MOUSE_UP:EventType<ScreenMouseEvent> = "rightMouseUp";

	/**
		The X position of the click in screen coordinates.
	**/
	public var screenX(default, null):Float;

	/**
		The Y position of the click in screen coordinates.
	**/
	public var screenY(default, null):Float;

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, screenX:Float = 0, screenY:Float = 0, ctrlKey:Bool = false,
			altKey:Bool = false, shiftKey:Bool = false, buttonDown:Bool = false, commandKey:Bool = false, controlKey:Bool = false)
	{
		super(type, bubbles, cancelable, screenX, screenY, null, ctrlKey, altKey, shiftKey, buttonDown, 0, commandKey, controlKey, 0);
		this.screenX = screenX;
		this.screenY = screenY;
	}

	public override function clone():ScreenMouseEvent
	{
		return new ScreenMouseEvent(type, bubbles, cancelable, screenX, screenY, ctrlKey, altKey, shiftKey, buttonDown, commandKey, controlKey);
	}
}
#else
#if air
typedef ScreenMouseEvent = flash.events.ScreenMouseEvent;
#end
#end
