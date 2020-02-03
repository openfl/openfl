package openfl.events;

#if (display || !flash)
@:jsRequire("openfl/events/TextEvent", "default")
/**
 * An object dispatches a TextEvent object when a user enters text in a text
 * field or clicks a hyperlink in an HTML-enabled text field. There are two
 * types of text events: `TextEvent.LINK` and
 * `TextEvent.TEXT_INPUT`.
 *
 */
extern class TextEvent extends Event
{
	/**
	 * Defines the value of the `type` property of a `link`
	 * event object.
	 *
	 * This event has the following properties:
	 */
	public static inline var LINK = "link";

	/**
	 * Defines the value of the `type` property of a
	 * `textInput` event object.
	 *
	 * **Note:** This event is not dispatched for the Delete or Backspace
	 * keys.
	 *
	 * This event has the following properties:
	 */
	public static inline var TEXT_INPUT = "textInput";

	/**
	 * For a `textInput` event, the character or sequence of
	 * characters entered by the user. For a `link` event, the text of
	 * the `event` attribute of the `href` attribute of the
	 * `<a>` tag.
	 */
	public var text:String;

	/**
	 * Creates an Event object that contains information about text events. Event
	 * objects are passed as parameters to event listeners.
	 *
	 * @param type       The type of the event. Event listeners can access this
	 *                   information through the inherited `type`
	 *                   property. Possible values are:
	 *                   `TextEvent.LINK` and
	 *                   `TextEvent.TEXT_INPUT`.
	 * @param bubbles    Determines whether the Event object participates in the
	 *                   bubbling phase of the event flow. Event listeners can
	 *                   access this information through the inherited
	 *                   `bubbles` property.
	 * @param cancelable Determines whether the Event object can be canceled.
	 *                   Event listeners can access this information through the
	 *                   inherited `cancelable` property.
	 * @param text       One or more characters of text entered by the user.
	 *                   Event listeners can access this information through the
	 *                   `text` property.
	 */
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "");
}
#else
typedef TextEvent = flash.events.TextEvent;
#end
