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
	public var tabIndex (get, set):Int;
	
	private var __tabEnabled:Null<Bool>;
	private var __tabIndex:Int;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (InteractiveObject.prototype, {
			"tabEnabled": { get: untyped __js__ ("function () { return this.get_tabEnabled (); }"), set: untyped __js__ ("function (v) { return this.set_tabEnabled (v); }") },
			"tabIndex": { get: untyped __js__ ("function () { return this.get_tabIndex (); }"), set: untyped __js__ ("function (v) { return this.set_tabIndex (v); }") },
		});
		
	}
	#end
	
	
	public function new () {
		
		super ();
		
		doubleClickEnabled = false;
		mouseEnabled = true;
		needsSoftKeyboard = false;
		__tabEnabled = null;
		__tabIndex = -1;
		
	}
	
	
	public function requestSoftKeyboard ():Bool {
		
		openfl._internal.Lib.notImplemented ();
		
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
	
	
	private function get_tabIndex ():Int {
		
		return __tabIndex;
		
	}
	
	
	private function set_tabIndex (value:Int):Int {
		
		return __tabIndex = value;
		
	}
	
	
}
