package openfl.display;

import openfl.errors.RangeError;
import openfl.events.Event;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _InteractiveObject extends _DisplayObject
{
	public var doubleClickEnabled:Bool;
	public var focusRect:Null<Bool>;
	public var mouseEnabled:Bool;
	public var needsSoftKeyboard:Bool;
	public var softKeyboardInputAreaOfInterest:Rectangle;
	public var tabEnabled(get, set):Bool;
	public var tabIndex(get, set):Int;

	public var __tabEnabled:Null<Bool>;
	public var __tabIndex:Int;

	private var interactiveObject:InteractiveObject;

	public function new(interactiveObject:InteractiveObject)
	{
		this.interactiveObject = interactiveObject;

		super(interactiveObject);

		doubleClickEnabled = false;
		mouseEnabled = true;
		needsSoftKeyboard = false;
		__tabEnabled = null;
		__tabIndex = -1;
	}

	public function requestSoftKeyboard():Bool
	{
		openfl._internal.Lib.notImplemented();
		return false;
	}

	public function __allowMouseFocus():Bool
	{
		return tabEnabled;
	}

	public override function __getInteractive(stack:Array<DisplayObject>):Bool
	{
		if (stack != null)
		{
			stack.push(this.interactiveObject);

			if (parent != null)
			{
				(parent._ : _DisplayObject).__getInteractive(stack);
			}
		}

		return true;
	}

	// public override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
	// 		hitObject:DisplayObject):Bool
	// {
	// 	if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled)) return false;
	// 	return inline super.__hitTest(x, y, shapeFlag, stack, interactiveOnly, hitObject);
	// }

	public function __tabTest(stack:Array<InteractiveObject>):Void
	{
		if (tabEnabled)
		{
			stack.push(this.interactiveObject);
		}
	}

	// Get & Set Methods

	private function get_tabEnabled():Bool
	{
		return __tabEnabled == true ? true : false;
	}

	private function set_tabEnabled(value:Bool):Bool
	{
		if (__tabEnabled != value)
		{
			__tabEnabled = value;

			dispatchEvent(new Event(Event.TAB_ENABLED_CHANGE, true, false));
		}

		return __tabEnabled;
	}

	private function get_tabIndex():Int
	{
		return __tabIndex;
	}

	private function set_tabIndex(value:Int):Int
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
