package events;

import openfl.events.AccelerometerEvent;

/**
 * The interface for Accelerometer events.
 */
interface IAccelerometer 
{
	/**
	 * The function called when the meter on the device is updated.
	 */
	public var update:AccelerometerEvent -> Void;
  
}