package events;

import openfl.events.TouchEvent;

/**
 * @author Colour Multimedia Enterprises
 */

interface ITouch 
{
	/** 
	 * The function called when the device receives touch from the user.
	 * */
	public var touchBegin:TouchEvent -> Void;
	
	/**
	 * The function called when the device no longer receives touch from the user.
	 */
	public var touchEnd:TouchEvent -> Void;
	
	/**
	 * The function called when the device receives movement from a touch event.
	 */
	public var touchMove:TouchEvent -> Void;
	
	/**
	 * The function called when the given object on the device no longer 
	 * receives touch events.
	 */
	public var touchOut:TouchEvent -> Void;
	
	/**
	 * The function called when the given object on the device receive touch events.
	 */
	public var touchOver:TouchEvent -> Void;
	
	/**
	 * The function called when a receiving object is dragged outside of a 
	 * container also receiving touch events.
	 */
	public var touchRollOut:TouchEvent -> Void;
	
	/**
	 * The function called when a receiving object is dragged into a container 
	 * that is about to receive touch events.
	 */
	public var touchRollOver:TouchEvent -> Void;
	
}