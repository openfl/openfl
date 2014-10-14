package events;

import openfl.events.NetStatusEvent;

/**
 * The interface for Net Status events.
 */
interface INetStatus 
{
	/**
	 * The function called when a sound object or microphone device requests
	 * new audio data.
	 */
	public var netStatus:NetStatusEvent -> Void;
  
}