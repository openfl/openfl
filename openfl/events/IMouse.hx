package events;

import openfl.events.MouseEvent;

/**
 * The interface for Mouse events.
 */
interface IMouse 
{
	/**
	 * The function called when the left mouse button is pressed and released on this
	 * object. Prevents the double-click function.
	 */
	public var click:MouseEvent -> Void;
	
	/**
	 * The function called when the middle mouse button is pressed and released twice on
	 * this object. 
	 */
	public var doubleClick:MouseEvent -> Void;
	
	/**
	 * The function called when the mouse wheel or middle button is clicked
	 * on this object.
	 */
	public var middleClick:MouseEvent -> Void;
	
	/**
	 * The function called when the mouse wheel or middle button is pressed
	 * down on this object.
	 */
	public var middleMouseDown:MouseEvent -> Void;
	
	/**
	 * The function called when the mouse wheel or middle button is released
	 * on this object.
	 */
	public var middleMouseUp:MouseEvent -> Void;
	
	/**
	 * The function called when the left mouse button is pressed down on this object.
	 */
	public var mouseDown:MouseEvent -> Void;
	
	/**
	 * The function called when the mouse moves over the object.
	 */
	public var mouseMove:MouseEvent -> Void;
	
	/**
	 * The function called when the mouse leaves the visible part of this object.
	 */
	public var mouseOut:MouseEvent -> Void;
	
	/**
	 * The function called when the mouse enters the visible part of this object.
	 */
	public var mouseOver:MouseEvent -> Void;
	
	/**
	 * The function called when the left mouse button is released from this object.
	 */
	public var mouseUp:MouseEvent -> Void;
	
	/**
	 * The function called when the mouse wheel moves up or down on this object.
	 * Use e.delta to receive the direction of the mouse wheel (> 0 is up, < 0 is down)
	 */
	public var mouseWheel:MouseEvent -> Void;
	
	/**
	 * The function called when the right mouse button is pressed and released
	 * on this object.
	 */
	public var rightClick:MouseEvent -> Void;
	
	/**
	 * The function called when the right mouse button is pressed on this
	 * object.
	 */
	public var rightMouseDown:MouseEvent -> Void;
	
	/**
	 * The function called when the right mouse button is released on this
	 * object.
	 */
	public var rightMouseUp:MouseEvent -> Void;
	
	/**
	 * The function called when the mouse leaves the container. Child objects
	 * within the container does not dispatch the rollOut event.
	 */
	public var rollOut:MouseEvent -> Void;
	
	/**
	 * The function called when the mouse enters a container object. Child objects
	 * within the container does not dispatch the rollOver event.
	 */
	public var rollOver:MouseEvent -> Void;
}