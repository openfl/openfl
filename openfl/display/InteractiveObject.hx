package openfl.display; #if !flash #if (next || js)


import openfl.geom.Rectangle;


class InteractiveObject extends DisplayObject {
	
	
	public var doubleClickEnabled:Bool;
	public var focusRect:Dynamic;
	public var mouseEnabled:Bool;
	public var needsSoftKeyboard:Bool;
	public var softKeyboardInputAreaOfInterest:Rectangle;
	public var tabEnabled:Bool;
	public var tabIndex:Int;
	
	
	public function new () {
		
		super ();
		
		doubleClickEnabled = false;
		mouseEnabled = true;
		needsSoftKeyboard = false;
		tabEnabled = true;
		tabIndex = -1;
		
	}
	
	
	public function requestSoftKeyboard ():Bool {
		
		openfl.Lib.notImplemented ("InteractiveObject.requestSoftKeyboard");
		
		return false;
		
	}
	
	
	private override function __getInteractive (stack:Array<DisplayObject>):Void {
		
		stack.push (this);
		
		if (parent != null) {
			
			parent.__getInteractive (stack);
			
		}
		
	}
	
	
}


#else
typedef InteractiveObject = openfl._v2.display.InteractiveObject;
#end
#else
typedef InteractiveObject = flash.display.InteractiveObject;
#end