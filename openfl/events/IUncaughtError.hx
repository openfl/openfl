package events;

import openfl.events.UncaughtErrorEvent;

/**
 * The interface for Uncaught Error events.
 */
interface IUncaughtError 
{
	/**
	 * The function called when an error fails to throw.
	 */
	public var uncaughtError:UncaughtErrorEvent -> Void;
}