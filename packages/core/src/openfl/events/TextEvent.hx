package openfl.events;

#if !flash
import openfl._internal.utils.ObjectPool;

/**
	An object dispatches a TextEvent object when a user enters text in a text
	field or clicks a hyperlink in an HTML-enabled text field. There are two
	types of text events: `TextEvent.LINK` and
	`TextEvent.TEXT_INPUT`.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class TextEvent extends Event
{
	/**
		Defines the value of the `type` property of a `link` event object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The text field containing the hyperlink that has been clicked. The `target` is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
		| `text` | The remainder of the URL after "event:" |
	**/
	public static inline var LINK:EventType<TextEvent> = "link";

	/**
		Defines the value of the `type` property of a `textInput` event
		object.
		**Note:** This event is not dispatched for the Delete or Backspace
		keys.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `true` |
		| `cancelable` | `true`; call the `preventDefault()` method to cancel default behavior. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `target` | The text field into which characters are being entered. The target is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
		|`text` | The character or sequence of characters entered by the user. |
	**/
	public static inline var TEXT_INPUT:EventType<TextEvent> = "textInput";

	/**
		For a `textInput` event, the character or sequence of
		characters entered by the user. For a `link` event, the text of
		the `event` attribute of the `href` attribute of the
		`<a>` tag.
	**/
	public var text(get, set):String;

	/**
		Creates an Event object that contains information about text events. Event
		objects are passed as parameters to event listeners.

		@param type       The type of the event. Event listeners can access this
						  information through the inherited `type`
						  property. Possible values are:
						  `TextEvent.LINK` and
						  `TextEvent.TEXT_INPUT`.
		@param bubbles    Determines whether the Event object participates in the
						  bubbling phase of the event flow. Event listeners can
						  access this information through the inherited
						  `bubbles` property.
		@param cancelable Determines whether the Event object can be canceled.
						  Event listeners can access this information through the
						  inherited `cancelable` property.
		@param text       One or more characters of text entered by the user.
						  Event listeners can access this information through the
						  `text` property.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "")
	{
		if (_ == null)
		{
			_ = new _TextEvent(this, type, bubbles, cancelable, text);
		}

		super(type, bubbles, cancelable);
	}

	public override function clone():TextEvent
	{
		return (_ : _TextEvent).clone();
	}

	// Get & Set Methods

	@:noCompletion private function get_text():String
	{
		return (_ : _TextEvent).text;
	}

	@:noCompletion private function set_text(value:String):String
	{
		return (_ : _TextEvent).text = value;
	}
}
#else
typedef TextEvent = flash.events.TextEvent;
#end
