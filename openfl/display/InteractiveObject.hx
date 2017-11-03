package openfl.display;


import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class InteractiveObject extends DisplayObject {
	
	
	public var doubleClickEnabled:Bool;
	public var focusRect:Null<Bool>;
	public var mouseEnabled:Bool;
	public var needsSoftKeyboard:Bool;
	
	public var softKeyboardInputAreaOfInterest:Rectangle;
	public var tabEnabled (get, set):Bool;
	public var tabIndex:Int;
	
	private var __tabEnabled:Null<Bool>;
	
	
	public function new () {
		
		super ();
		
		doubleClickEnabled = false;
		mouseEnabled = true;
		needsSoftKeyboard = false;
		__tabEnabled = null;
		tabIndex = -1;
		
	}
	
	
	public function requestSoftKeyboard ():Bool {
		
		openfl.Lib.notImplemented ();
		
		return false;
		
	}
	
	
	private function __allowMouseFocus ():Bool {
		
		return tabEnabled;
		
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
		
		return __tabEnabled == true ? true : false;
		
	}
	
	
	private function set_tabEnabled (value:Bool):Bool {
		
		return __tabEnabled = value;
		
	}
	
	
}