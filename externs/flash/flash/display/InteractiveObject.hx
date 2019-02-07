package flash.display;

#if flash
import openfl.geom.Rectangle;

extern class InteractiveObject extends DisplayObject
{
	#if flash
	public var accessibilityImplementation:flash.accessibility.AccessibilityImplementation;
	#end
	#if flash
	public var contextMenu:flash.ui.ContextMenu;
	#elseif air
	public var contextMenu:flash.display.NativeMenu;
	#end
	public var doubleClickEnabled:Bool;
	public var focusRect:Null<Bool>;
	public var mouseEnabled:Bool;
	@:require(flash11) public var needsSoftKeyboard:Bool;
	@:require(flash11) public var softKeyboardInputAreaOfInterest:Rectangle;
	public var tabEnabled:Bool;
	public var tabIndex:Int;
	public function new();
	@:require(flash11) public function requestSoftKeyboard():Bool;
}
#else
typedef InteractiveObject = openfl.display.InteractiveObject;
#end
