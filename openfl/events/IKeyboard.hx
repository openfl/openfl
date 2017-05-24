package events;

import openfl.events.KeyboardEvent;

/**
 * The interface for Keyboard events.
 */
interface IKeyboard 
{
	/**
	 * The function to call when a key is released.
	 */
	public var keyUp:KeyboardEvent -> Void;
	
	/**
	 * The function to call when a key is down.
	 */
	public var keyDown:KeyboardEvent -> Void;
}