package flash.display; #if (!display && flash)


import openfl.geom.Rectangle;


extern class InteractiveObject extends DisplayObject {
	
	
	#if flash
	@:noCompletion @:dox(hide) public var accessibilityImplementation:flash.accessibility.AccessibilityImplementation;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public var contextMenu:flash.ui.ContextMenu;
	#end
	
	public var doubleClickEnabled:Bool;
	public var focusRect:Dynamic;
	public var mouseEnabled:Bool;
	@:require(flash11) public var needsSoftKeyboard:Bool;
	@:require(flash11) public var softKeyboardInputAreaOfInterest:Rectangle;
	public var tabEnabled:Bool;
	public var tabIndex:Int;
	
	public function new ();
	@:require(flash11) public function requestSoftKeyboard ():Bool;
	
	
}


#else
typedef InteractiveObject = openfl.display.InteractiveObject;
#end