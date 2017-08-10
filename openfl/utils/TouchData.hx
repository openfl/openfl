package openfl.utils;

import lime.ui.Touch;
import lime.utils.ObjectPool;
import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;

/**
 * ...
 * @author Zaphod
 */
class TouchData 
{
	private static var __pool = new ObjectPool<TouchData>(function() return new TouchData(), function(data) data.reset());

	public var touch:Touch;
	public var touchDownTarget:InteractiveObject;
	public var touchOverTarget:InteractiveObject;
	
	public var rollOutStack:Array<DisplayObject>;
	
	public function new() 
	{
		rollOutStack = [];
	}
	
	public function reset():Void
	{
		touch = null;
		touchDownTarget = null;
		touchOverTarget = null;
		
		rollOutStack.splice(0, rollOutStack.length);
	}
	
}