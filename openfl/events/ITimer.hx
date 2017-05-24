package events;

import openfl.events.TimerEvent;

/**
 * The interface for Time Events.
 */
interface ITimer 
{
	/**
	 * The function called when a timer object elapses.
	 */
	public var timer:TimerEvent -> Void;
	
	/**
	 * The function called when the given time on a timer object
	 * has fully elapsed.
	 */
	public var timerComplete:TimerEvent -> Void;
}