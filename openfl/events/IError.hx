package events;

import openfl.events.ErrorEvent;

/**
 * The interface for Error events.
 */
interface IError 
{
	/**
	 * The function called when an error message is thrown.
	 */
	public var error:ErrorEvent -> Void;
}