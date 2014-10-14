package events;

import openfl.events.ProgressEvent;

/**
 * The interfaces for Progress events.
 */
interface IProgress 
{
	/**
	 * The function called while something is being loaded onto the stage.
	 */
	public var progress:ProgressEvent -> Void;
	
	/**
	 * The function called while something is downloaded via a socket.
	 */
	public var socketData:ProgressEvent -> Void;
	
}