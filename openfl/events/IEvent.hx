package events;

import openfl.events.Event;

/**
 * The interface for stage events.
 */
interface IEvent 
{
	/**
	 * The function called for when an event-enabled object is
	 * activated.
	 */
	public var activate:Event -> Void;
	
	/**
	 * The function called for when an object is added to this
	 * object. 
	 */
	public var added:Event -> Void;
	
	/**
	 * The function called for when an object is added to the
	 * stage.
	 */
	public var addedToStage:Event -> Void;
	
	/**
	 * The function called when an event is cancelled (ie e.preventDefault())
	 */
	public var cancel:Event -> Void;
	
	/**
	 * The function called when the value of an object is changed.
	 */
	public var change:Event -> Void;
	
	/**
	 * The function called when an object' send() function is called.
	 */
	public var channelMessage:Event -> Void;
	
	/**
	 * The function called when the Channel State's property in an object is
	 * changed.
	 */
	public var channelState:Event -> Void;
	
	/**
	 * The function called when clear is selected from an object's context
	 * menu or by its related function.
	 */
	public var clear:Event -> Void;
	
	/**
	 * The function called when an object's connection is closed.
	 */
	public var close:Event -> Void;
	
	/**
	 * The function called when a network object has completed loading.
	 */
	public var completed:Event -> Void;
	
	/**
	 * The function called when a network object has established a network connection.
	 */
	public var connect:Event -> Void;
	
	/**
	 * The function called when a Stage3D object makes a call to Stage3D.requestContext3D
	 * or reset via Context3D bound to a Stage3D object.
	 */
	public var context3dCreate:Event -> Void;
	
	/**
	 * The function called when an object's copy() function is called.
	 */
	public var copy:Event -> Void;
	
	/**
	 * The function called when an object's cut() function is called.
	 */
	public var cut:Event -> Void;
	
	/**
	 * The function called when an event-related object is deactivated.
	 */
	public var deactive:Event -> Void;

	/**
	 * The function called when an object enters a new frame. If this
	 * object has one frame, this will be continuous in relation to frame rate.
	 */
	public var enterFrame:Event -> Void;
	
	/**
	 * The function called when an object exits the next frame. If this
	 * object has one frame, this will be continuous in relation to frame rate.
	 */
	public var exitFrame:Event -> Void;
	
	/**
	 * The function called after a frame is constructed and before frame
	 * scripts are run.
	 */
	public var frameConstructed:Event -> Void;
	
	/**
	 * The function called when the stage enters or exits fullscreen mode.
	 */
	public var fullscreen:Event -> Void;
	
	/**
	 * The function called when an MP3 sound is loaded, containing ID3 data.
	 */
	public var id3:Event -> Void;
	
	/**
	 * The function called when the application is loaded, containing LoadingInfo data.
	 */
	public var init:Event -> Void;
	
	/**
	 * The function called when the Stage object when the pointer moves out of the 
	 * stage area. If the mouse button is pressed, the event is not dispatched.
	 */
	public var mouseLeave:Event -> Void;
	
	/**
	 * The function called when a file is opened.
	 */
	public var open:Event -> Void;
	
	/**
	 * The function called when the paste() function in the given object is called.
	 */
	public var paste:Event -> Void;
	
	/**
	 * The function called when an object is removed from the given object.
	 */
	public var removed:Event -> Void;
	
	/**
	 * The function called when an object is removed from the stage.
	 */
	public var removeFromStage:Event -> Void;
	
	/**
	 * The function called when an object starts rendering, before it is added to the stage.
	 * You must call the invalidate() method of the Stage object each time you want a render 
	 * event to be dispatched.
	 */
	public var render:Event -> Void;
	
	/**
	 * The function called when an object is resized.
	 */
	public var resize:Event -> Void;
	
	/**
	 * The function called when a TextField is scrolling.
	 * May also apply to containers who also dispatch this event if scrollbars are enabled.
	 */
	public var scroll:Event -> Void;
	
	/**
	 * The function called when an object is selected.
	 */
	public var select:Event -> Void;
	
	/**
	 * The function called when all objects in a container is selected.
	 */
	public var selectAll:Event -> Void;
	
	/**
	 * The function called when sound has finished playing.
	 */
	public var soundComplete:Event -> Void;
	
	/**
	 * The function called when the value of the tabChildren flag has changed.
	 */
	public var tabChildrenChanged:Event -> Void;
	
	/**
	 * The function called when the object's tabEnabled flag changes.
	 */
	public var tabEnabledChanged:Event -> Void;
	
	/**
	 * The function called when the value of the object's tabIndex property changes.
	 */
	public var tabIndexChanged:Event -> Void;
	
	/**
	 * The function called when the mode of the text field changes.
	 * Only applies to text-enabled objects. Also applies to any object implementing ITextField.
	 */
	public var textInteractionModeChange:Event -> Void;
	
	/**
	 * The function called when the LoaderInfo object associated with this application is
	 * loaded or replaced.
	 */
	public var unload:Event -> Void;
	
	/**
	 * The function called when a camera object receives a new frame and is available to
	 * be copied.
	 */
	public var videoFrame:Event -> Void;
	
	/**
	 * The function called when the value of a worker's state changes.
	 */
	public var workerState:Event -> Void;
}