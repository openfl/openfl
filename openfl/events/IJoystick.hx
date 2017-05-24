package events;

import openfl.events.JoystickEvent;

/**
 * The interface for Joystick events.
 */
interface IJoystick 
{
	
	/**
	 * The function called when an analogue stick on the
	 * joystick alters its axis.
	 */
	public var axisMove:JoystickEvent -> Void;
	
	/**
	 * The function called when the analogue stick on the
	 * joystick moves.
	 */
	public var ballMove:JoystickEvent -> Void;
	
	/**
	 * The function called when a button on the joystick
	 * is pressed down.
	 */
	public var buttonDown:JoystickEvent -> Void;
	
	/**
	 * The function called when a button on the joystick
	 * is released.
	 */
	public var buttonUp:JoystickEvent -> Void;
	
	/**
	 * The function called when a joystick device is
	 * received by the system.
	 */
	public var deviceAdded:JoystickEvent -> Void;
	
	/**
	 * The function called when a joystick device is
	 * no longer detected on the system.
	 */
	public var deviceRemoved:JoystickEvent -> Void;
	
	/**
	 * The function called when the Hat on the joystick
	 * device is moved.
	 */
	public var hatMove:JoystickEvent -> Void;
	
}