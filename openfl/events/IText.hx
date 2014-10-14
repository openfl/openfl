package events;

import openfl.events.TextEvent;

/**
 * The interface for Text events.
 */
interface IText 
{
	/**
	 * When a hyperlink is clicked in a given text field, this is
	 * the calling function. Does not work outside of Flash.
	 */
	public var link:TextEvent -> Void;
	
	/**
	 * The function called when the given text field receives input.
	 */
	public var input:TextEvent -> Void;
}