package events;

import openfl.events.IOErrorEvent;

/**
 * The interface for IO Error events.
 */
interface IIOError 
{
	/**
	 * The function called when an error message specific to IO handles
	 * is thrown.
	 */
	public var ioError:IOErrorEvent -> Void;
}