package openfl.display; #if !openfl_legacy


import openfl.geom.Rectangle;


class InteractiveObject extends DisplayObject {
	
	
	public var doubleClickEnabled:Bool;
	public var focusRect:Dynamic;
	public var mouseEnabled:Bool;
	public var needsSoftKeyboard:Bool;
	
	public var softKeyboardInputAreaOfInterest:Rectangle;
	public var tabEnabled (get, set):Bool;
	public var tabIndex:Int;
	
	private var __tabEnabled:Bool;
	
	
	public function new () {
		
		super ();
		
		doubleClickEnabled = false;
		mouseEnabled = true;
		needsSoftKeyboard = false;
		__tabEnabled = false;
		tabIndex = -1;
		
	}
	
	
	public function requestSoftKeyboard ():Bool {
		
		openfl.Lib.notImplemented ("InteractiveObject.requestSoftKeyboard");
		
		return false;
		
	}
	
	
	private override function __getInteractive (stack:Array<DisplayObject>):Bool {
		
		if (stack != null) {
			
			stack.push (this);
			
			if (parent != null) {
				
				parent.__getInteractive (stack);
				
			}
			
		}
		
		return true;
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled)) return false;
		return super.__hitTest (x, y, shapeFlag, stack, interactiveOnly, hitObject);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_tabEnabled ():Bool {
		
		return __tabEnabled;
		
	}
	
	
	private function set_tabEnabled (value:Bool):Bool {
		
		return __tabEnabled = value;
		
	}
	
	
}


#else
typedef InteractiveObject = openfl._legacy.display.InteractiveObject;
#end