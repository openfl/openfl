package events;

import openfl.events.AsyncErrorEvent;

/**
 * The interface for Async Error events.
 */
interface IAsyncError 
{
	/**
	 * The function called when an async error is received by the 
	 * calling object.
	 */
	public var asyncError:AsyncErrorEvent -> Void;
}