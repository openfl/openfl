package openfl._internal;


import lime.ui.Touch;
import lime.utils.ObjectPool;
import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;


class TouchData {
	
	
	public static var __pool = new ObjectPool<TouchData> (function () return new TouchData (), function (data) data.reset ());
	
	public var rollOutStack:Array<DisplayObject>;
	public var touch:Touch;
	public var touchDownTarget:InteractiveObject;
	public var touchOverTarget:InteractiveObject;
	
	
	public function new () {
		
		rollOutStack = [];
		
	}
	
	
	public function reset ():Void {
		
		touch = null;
		touchDownTarget = null;
		touchOverTarget = null;
		
		rollOutStack.splice (0, rollOutStack.length);
		
	}
	
	
}