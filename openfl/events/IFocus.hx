package events;

import openfl.events.FocusEvent;

/**
 * The interface for Focus events.
 */
interface IFocus 
{
	/**
	 * The function called when an object receives focus.
	 */
	public var focusIn:FocusEvent -> Void;
	
	/**
	 * The function called when an object loses focus.
	 */
	public var focusOut:FocusEvent -> Void;
	
	/**
	 * The function called when a keyboard event changes.
	 */
	public var keyFocusChange:FocusEvent -> Void;
	
	/**
	 * The function called when a mouse event changes.
	 */
	public var mouseFocusChange:FocusEvent -> Void;
}