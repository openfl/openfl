package openfl.display;

#if !flash
import openfl.errors.RangeError;
import openfl.events.Event;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class InteractiveObject extends DisplayObject
{
	// @:noCompletion @:dox(hide) public var accessibilityImplementation:openfl.accessibility.AccessibilityImplementation;
	// @:noCompletion @:dox(hide) public var contextMenu:openfl.ui.ContextMenu;
	public var doubleClickEnabled:Bool;
	public var focusRect:Null<Bool>;
	public var mouseEnabled:Bool;
	public var needsSoftKeyboard:Bool;
	public var softKeyboardInputAreaOfInterest:Rectangle;
	public var tabEnabled(get, set):Bool;
	public var tabIndex(get, set):Int;

	@:noCompletion private var __tabEnabled:Null<Bool>;
	@:noCompletion private var __tabIndex:Int;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(InteractiveObject.prototype, {
			"tabEnabled": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_tabEnabled (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_tabEnabled (v); }")
			},
			"tabIndex": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_tabIndex (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_tabIndex (v); }")
			},
		});
	}
	#end

	public function new()
	{
		super();

		doubleClickEnabled = false;
		mouseEnabled = true;
		needsSoftKeyboard = false;
		__tabEnabled = null;
		__tabIndex = -1;
	}

	#if !openfl_strict
	public function requestSoftKeyboard():Bool
	{
		openfl._internal.Lib.notImplemented();
		return false;
	}
	#end

	@:noCompletion private function __allowMouseFocus():Bool
	{
		return tabEnabled;
	}

	@:noCompletion private override function __getInteractive(stack:Array<DisplayObject>):Bool
	{
		if (stack != null)
		{
			stack.push(this);

			if (parent != null)
			{
				parent.__getInteractive(stack);
			}
		}

		return true;
	}

	@:noCompletion private override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
			hitObject:DisplayObject):Bool
	{
		if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled)) return false;
		return super.__hitTest(x, y, shapeFlag, stack, interactiveOnly, hitObject);
	}

	@:noCompletion private function __tabTest(stack:Array<InteractiveObject>):Void
	{
		if (tabEnabled)
		{
			stack.push(this);
		}
	}

	// Get & Set Methods
	@:noCompletion private function get_tabEnabled():Bool
	{
		return __tabEnabled == true ? true : false;
	}

	@:noCompletion private function set_tabEnabled(value:Bool):Bool
	{
		if (__tabEnabled != value)
		{
			__tabEnabled = value;

			dispatchEvent(new Event(Event.TAB_ENABLED_CHANGE, true, false));
		}

		return __tabEnabled;
	}

	@:noCompletion private function get_tabIndex():Int
	{
		return __tabIndex;
	}

	@:noCompletion private function set_tabIndex(value:Int):Int
	{
		if (__tabIndex != value)
		{
			if (value < -1) throw new RangeError("Parameter tabIndex must be a non-negative number; got " + value);

			__tabIndex = value;

			dispatchEvent(new Event(Event.TAB_INDEX_CHANGE, true, false));
		}

		return __tabIndex;
	}
}
#else
typedef InteractiveObject = flash.display.InteractiveObject;
#end
