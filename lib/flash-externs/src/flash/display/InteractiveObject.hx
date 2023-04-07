package flash.display;

#if flash
import openfl.geom.Rectangle;

extern class InteractiveObject extends DisplayObject
{
	#if (haxe_ver < 4.3)
	public var accessibilityImplementation:flash.accessibility.AccessibilityImplementation;
	public var contextMenu:#if air flash.display.NativeMenu #else flash.ui.ContextMenu #end;
	public var doubleClickEnabled:Bool;
	public var focusRect:Null<Bool>;
	public var mouseEnabled:Bool;
	@:require(flash11) public var needsSoftKeyboard:Bool;
	@:require(flash11) public var softKeyboardInputAreaOfInterest:Rectangle;
	public var tabEnabled:Bool;
	public var tabIndex:Int;
	#else
	@:flash.property var accessibilityImplementation(get, set):flash.accessibility.AccessibilityImplementation;
	@:flash.property var contextMenu(get, set):#if air flash.display.NativeMenu #else flash.ui.ContextMenu #end;
	@:flash.property var doubleClickEnabled(get, set):Bool;
	@:flash.property var focusRect(get, set):Dynamic;
	@:flash.property var mouseEnabled(get, set):Bool;
	@:flash.property @:require(flash11) var needsSoftKeyboard(get, set):Bool;
	@:flash.property @:require(flash11) var softKeyboardInputAreaOfInterest(get, set):Rectangle;
	@:flash.property var tabEnabled(get, set):Bool;
	@:flash.property var tabIndex(get, set):Int;
	#end

	public function new();
	@:require(flash11) public function requestSoftKeyboard():Bool;

	#if (haxe_ver >= 4.3)
	private function get_accessibilityImplementation():flash.accessibility.AccessibilityImplementation;
	private function get_contextMenu():#if air flash.display.NativeMenu #else flash.ui.ContextMenu #end;
	private function get_doubleClickEnabled():Bool;
	private function get_focusRect():Dynamic;
	private function get_mouseEnabled():Bool;
	private function get_needsSoftKeyboard():Bool;
	private function get_softKeyboardInputAreaOfInterest():Rectangle;
	private function get_tabEnabled():Bool;
	private function get_tabIndex():Int;
	private function set_accessibilityImplementation(value:flash.accessibility.AccessibilityImplementation):flash.accessibility.AccessibilityImplementation;
	private function set_contextMenu(value:#if air flash.display.NativeMenu #else flash.ui.ContextMenu #end):#if air flash.display.NativeMenu #else flash.ui.ContextMenu #end;
	private function set_doubleClickEnabled(value:Bool):Bool;
	private function set_focusRect(value:Dynamic):Dynamic;
	private function set_mouseEnabled(value:Bool):Bool;
	private function set_needsSoftKeyboard(value:Bool):Bool;
	private function set_softKeyboardInputAreaOfInterest(value:Rectangle):Rectangle;
	private function set_tabEnabled(value:Bool):Bool;
	private function set_tabIndex(value:Int):Int;
	#end
}
#else
typedef InteractiveObject = openfl.display.InteractiveObject;
#end
