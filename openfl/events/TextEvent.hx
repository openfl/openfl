package openfl.events; #if (!display && !flash)


class TextEvent extends Event {
	
	
	public static var LINK = "link";
	public static var TEXT_INPUT = "textInput";
	
	public var text:String;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "") {
		
		super (type, bubbles, cancelable);
		
		this.text = text;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new TextEvent (type, bubbles, cancelable, text);
		event.target = target;
		event.currentTarget = currentTarget;
		#if !openfl_legacy
		event.eventPhase = eventPhase;
		#end
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("TextEvent",  [ "type", "bubbles", "cancelable", "text" ]);
		
	}
	
	
}


#else


/**
 * An object dispatches a TextEvent object when a user enters text in a text
 * field or clicks a hyperlink in an HTML-enabled text field. There are two
 * types of text events: <code>TextEvent.LINK</code> and
 * <code>TextEvent.TEXT_INPUT</code>.
 * 
 */

#if flash
@:native("flash.events.TextEvent")
#end

extern class TextEvent extends Event {
	
	
	/**
	 * Defines the value of the <code>type</code> property of a <code>link</code>
	 * event object.
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var LINK:String;
	
	/**
	 * Defines the value of the <code>type</code> property of a
	 * <code>textInput</code> event object.
	 *
	 * <p><b>Note:</b> This event is not dispatched for the Delete or Backspace
	 * keys.</p>
	 *
	 * <p>This event has the following properties:</p>
	 */
	public static var TEXT_INPUT:String;
	
	
	/**
	 * For a <code>textInput</code> event, the character or sequence of
	 * characters entered by the user. For a <code>link</code> event, the text of
	 * the <code>event</code> attribute of the <code>href</code> attribute of the
	 * <code><a></code> tag.
	 */
	public var text:String;
	
	
	/**
	 * Creates an Event object that contains information about text events. Event
	 * objects are passed as parameters to event listeners.
	 * 
	 * @param type       The type of the event. Event listeners can access this
	 *                   information through the inherited <code>type</code>
	 *                   property. Possible values are:
	 *                   <code>TextEvent.LINK</code> and
	 *                   <code>TextEvent.TEXT_INPUT</code>.
	 * @param bubbles    Determines whether the Event object participates in the
	 *                   bubbling phase of the event flow. Event listeners can
	 *                   access this information through the inherited
	 *                   <code>bubbles</code> property.
	 * @param cancelable Determines whether the Event object can be canceled.
	 *                   Event listeners can access this information through the
	 *                   inherited <code>cancelable</code> property.
	 * @param text       One or more characters of text entered by the user.
	 *                   Event listeners can access this information through the
	 *                   <code>text</code> property.
	 */
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "");
	
	
}


#end