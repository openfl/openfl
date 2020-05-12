package openfl._internal.utils;

import openfl.display.DisplayObjectContainer;
import openfl.display._DisplayObjectContainer;
import openfl.display.DisplayObject;
import openfl.display._DisplayObject;

@:access(openfl.display.DisplayObject)
class DisplayObjectLinkedList
{
	public static #if !openfl_validate_children /*inline*/ #end function __addChild(displayObject:DisplayObjectContainer, child:DisplayObject):Void
	{
		var _displayObject:_DisplayObject = cast displayObject._;
		var _child:_DisplayObject = cast child._;

		if (child == _displayObject.__lastChild)
		{
			return;
		}

		// var args:Array<Dynamic> = [child];
		// __validateChildrenInit(displayObject, "__addChild", args);

		if (_displayObject.__firstChild == child)
		{
			_displayObject.__firstChild = _child.__nextSibling;
		}
		else if (_child.__previousSibling != null)
		{
			(_child.__previousSibling._ : _DisplayObject).__nextSibling = _child.__nextSibling;
		}

		if (_child.__nextSibling != null)
		{
			(_child.__nextSibling._ : _DisplayObject).__previousSibling = _child.__previousSibling;
		}

		if (_displayObject.__firstChild == null)
		{
			_displayObject.__firstChild = child;
		}

		if (_displayObject.__lastChild != null)
		{
			(_displayObject.__lastChild._ : _DisplayObject).__nextSibling = child;
			_child.__previousSibling = _displayObject.__lastChild;
		}

		_displayObject.__lastChild = child;
		_child.__nextSibling = null;

		#if openfl_validate_children
		_displayObject.__children.remove(child);
		_displayObject.__children.push(child);
		__validateChildren(displayObject, "__addChild");
		#end
	}

	public static function __insertChildAfter(displayObject:DisplayObjectContainer, child:DisplayObject, before:DisplayObject):Void
	{
		var _displayObject:_DisplayObject = cast displayObject._;
		var _child:_DisplayObject = cast child._;

		if (before == child || (before._ : _DisplayObject).__nextSibling == child)
		{
			return;
		}

		// var args:Array<Dynamic> = [child, before];
		// __validateChildrenInit(displayObject, "__insertChildAfter", args);

		var after = (before._ : _DisplayObject).__nextSibling;

		if (_displayObject.__firstChild == child)
		{
			_displayObject.__firstChild = _child.__nextSibling;
		}

		if (_displayObject.__lastChild == child)
		{
			_displayObject.__lastChild = _child.__previousSibling;
		}

		if (_child.__previousSibling != null)
		{
			(_child.__previousSibling._ : _DisplayObject).__nextSibling = _child.__nextSibling;
		}

		if (_child.__nextSibling != null)
		{
			(_child.__nextSibling._ : _DisplayObject).__previousSibling = _child.__previousSibling;
		}

		_child.__previousSibling = before;
		_child.__nextSibling = after;

		if (before != null)
		{
			(before._ : _DisplayObject).__nextSibling = child;
		}

		if (after != null)
		{
			(after._ : _DisplayObject).__previousSibling = child;
		}
		else
		{
			_displayObject.__lastChild = child;
		}

		#if openfl_validate_children
		_displayObject.__children.remove(child);
		var index = _displayObject.__children.indexOf(before) + 1;
		var childIndex = _displayObject.__children.indexOf(child);
		if (childIndex != index)
		{
			if (childIndex != -1 && childIndex < index)
			{
				index--;
			}
			_displayObject.__children.insert(index, child);
		}
		__validateChildren(displayObject, "__insertChildAfter");
		#end
	}

	public static function __insertChildBefore(displayObject:DisplayObjectContainer, child:DisplayObject, after:DisplayObject):Void
	{
		if (after != null && child != after && (after._ : _DisplayObject).__previousSibling != child)
		{
			if ((after._ : _DisplayObject).__previousSibling != null)
			{
				__insertChildAfter(displayObject, child, (after._ : _DisplayObject).__previousSibling);
			}
			else
			{
				__unshiftChild(displayObject, child);
			}
		}
	}

	public static #if !openfl_validate_children /*inline*/ #end function __insertChildAt(displayObject:DisplayObjectContainer, child:DisplayObject,
			index:Int):Void
	{
		var _displayObject:_DisplayObject = cast displayObject._;
		if (index == 0)
		{
			__unshiftChild(displayObject, child);
		}
		else
		{
			// var args:Array<Dynamic> = [child, index];
			// __validateChildrenInit(displayObject, "__insertChildAt", args);

			var ref = _displayObject.__firstChild;
			var childFound = (ref == child);
			for (i in 0...(index - 1))
			{
				ref = (ref._ : _DisplayObject).__nextSibling;
				if (ref == null)
				{
					break;
				}
				else if (ref == child)
				{
					childFound = true;
				}
			}

			if (childFound && (ref._ : _DisplayObject).__nextSibling != null)
			{
				ref = (ref._ : _DisplayObject).__nextSibling;
			}

			if (ref == child)
			{
				return;
			}

			__insertChildAfter(displayObject, child, ref);
		}
	}

	public static #if !openfl_validate_children /*inline*/ #end function __removeChild(displayObject:DisplayObjectContainer, child:DisplayObject):Void
	{
		var _displayObject:_DisplayObjectContainer = cast displayObject._;
		var _child:_DisplayObject = cast child._;

		// var args:Array<Dynamic> = [child];
		// __validateChildrenInit(displayObject, "__removeChild", args);

		_child.parent = null;
		_displayObject.numChildren--;

		if (_displayObject.__firstChild == child)
		{
			_displayObject.__firstChild = _child.__nextSibling;
		}

		if (_displayObject.__lastChild == child)
		{
			_displayObject.__lastChild = _child.__previousSibling;
		}

		if (_child.__previousSibling != null)
		{
			(_child.__previousSibling._ : _DisplayObject).__nextSibling = _child.__nextSibling;
		}

		if (_child.__nextSibling != null)
		{
			(_child.__nextSibling._ : _DisplayObject).__previousSibling = _child.__previousSibling;
		}

		_child.__previousSibling = null;
		_child.__nextSibling = null;

		#if openfl_validate_children
		_displayObject.__children.remove(child);
		__validateChildren(displayObject, "__removeChild");
		#end
	}

	public static inline function __reparent(displayObject:DisplayObjectContainer, child:DisplayObject):Void
	{
		var _displayObject:_DisplayObjectContainer = cast displayObject._;
		var _child:_DisplayObject = cast child._;

		if (child.parent != displayObject)
		{
			if (child.parent != null)
			{
				child.parent.removeChild(child);
			}
			_child.parent = displayObject;
			_displayObject.numChildren++;
		}
	}

	public static function __swapChildren(displayObject:DisplayObjectContainer, child1:DisplayObject, child2:DisplayObject):Void
	{
		var _displayObject:_DisplayObject = cast displayObject._;
		var _child1:_DisplayObject = cast child1._;
		var _child2:_DisplayObject = cast child2._;

		// var args:Array<Dynamic> = [child1, child2];
		// __validateChildrenInit(displayObject, "__swapChildren", args);

		if (_child1.__nextSibling == child2 || _child2.__nextSibling == child1)
		{
			var first, second;
			if (_child1.__nextSibling == child2)
			{
				first = child1;
				second = child2;
			}
			else
			{
				first = child2;
				second = child1;
			}

			var before = ((first._ : _DisplayObject) : _DisplayObject).__previousSibling;
			var after = (second._ : _DisplayObject).__nextSibling;

			(first._ : _DisplayObject).__previousSibling = second;
			(first._ : _DisplayObject).__nextSibling = after;
			(second._ : _DisplayObject).__previousSibling = before;
			(second._ : _DisplayObject).__nextSibling = first;

			if (before != null)
			{
				(before._ : _DisplayObject).__nextSibling = second;
			}

			if (after != null)
			{
				(after._ : _DisplayObject).__previousSibling = first;
			}
		}
		else
		{
			var prev1 = _child1.__previousSibling;
			var next1 = _child1.__nextSibling;
			var prev2 = _child2.__previousSibling;
			var next2 = _child2.__nextSibling;

			_child1.__previousSibling = prev2;
			_child1.__nextSibling = next2;
			_child2.__previousSibling = prev1;
			_child2.__nextSibling = next1;

			if (prev1 != null)
			{
				(prev1._ : _DisplayObject).__nextSibling = child2;
			}

			if (next1 != null)
			{
				(next1._ : _DisplayObject).__previousSibling = child2;
			}

			if (prev2 != null)
			{
				(prev2._ : _DisplayObject).__nextSibling = child1;
			}

			if (next2 != null)
			{
				(next2._ : _DisplayObject).__previousSibling = child1;
			}
		}

		if (_displayObject.__firstChild == child1)
		{
			_displayObject.__firstChild = child2;
		}
		else if (_displayObject.__firstChild == child2)
		{
			_displayObject.__firstChild = child1;
		}

		if (_displayObject.__lastChild == child1)
		{
			_displayObject.__lastChild = child2;
		}
		else if (_displayObject.__lastChild == child2)
		{
			_displayObject.__lastChild = child1;
		}

		#if openfl_validate_children
		var index1 = _displayObject.__children.indexOf(child1);
		var index2 = _displayObject.__children.indexOf(child2);
		_displayObject.__children[index1] = child2;
		_displayObject.__children[index2] = child1;
		__validateChildren(displayObject, "__swapChildren");
		#end
	}

	public static #if !openfl_validate_children /*inline*/ #end function __unshiftChild(displayObject:DisplayObjectContainer, child:DisplayObject):Void
	{
		var _displayObject:_DisplayObject = cast displayObject._;
		var _child:_DisplayObject = cast child._;

		if (_displayObject.__firstChild == child)
		{
			return;
		}

		// var args:Array<Dynamic> = [child];
		// __validateChildrenInit(displayObject, "__unshiftChild", args);

		if (_child.__previousSibling != null)
		{
			(_child.__previousSibling._ : _DisplayObject).__nextSibling = _child.__nextSibling;
		}

		if (_child.__nextSibling != null)
		{
			(_child.__nextSibling._ : _DisplayObject).__previousSibling = _child.__previousSibling;
		}

		if (_displayObject.__firstChild != null)
		{
			(_displayObject.__firstChild._ : _DisplayObject).__previousSibling = child;
		}

		if (child == _displayObject.__lastChild)
		{
			_displayObject.__lastChild = _child.__previousSibling;
		}

		_child.__previousSibling = null;
		_child.__nextSibling = _displayObject.__firstChild;
		_displayObject.__firstChild = child;

		if (_child.__nextSibling == null)
		{
			_displayObject.__lastChild = child;
		}

		#if openfl_validate_children
		_displayObject.__children.remove(child);
		_displayObject.__children.insert(0, child);
		__validateChildren(displayObject, "__unshiftChild");
		#end
	}

	#if openfl_validate_children
	public static function __validateChildren(displayObject:DisplayObjectContainer, label:String):Void
	{
		var _displayObject:_DisplayObject = cast displayObject._;

		var numChildren = displayObject.numChildren;
		var __firstChild = _displayObject.__firstChild;
		var __lastChild = _displayObject.__lastChild;
		var __children = _displayObject.__children;

		var numChildrenCorrect = (numChildren == __children.length);
		var firstChildMatches = (__firstChild == __children[0]);
		var checkMap = new Map<DisplayObject, Bool>();

		for (i in 0..._displayObject.__children.length)
		{
			if (checkMap.exists(_displayObject.__children[i]))
			{
				__validateChildrenError(displayObject, '[$label] Duplicate child detected in validation array');
			}
			else
			{
				checkMap[_displayObject.__children[i]] = true;
			}
		}

		if (!numChildrenCorrect)
		{
			__validateChildrenError(displayObject, '[$label] numChildren is incorrect');
		}

		if (!firstChildMatches)
		{
			__validateChildrenError(displayObject, '[$label] firstChild does not match');
		}

		var child = __firstChild;
		var _child:_DisplayObject = null;
		if (child != null)
		{
			_child = cast child._;
			if (_child.__previousSibling != null)
			{
				__validateChildrenError(displayObject, '[$label] first_child.__previousSibling is not null');
			}
		}

		var child = __firstChild;
		_child = cast child._;
		for (i in 0..._.__children.length)
		{
			if (child != __children[i])
			{
				__validateChildrenError(displayObject, '[$label] child $i does not match');
			}

			if (i > 0)
			{
				if (_child.__previousSibling == null)
				{
					__validateChildrenError(displayObject, '[$label] _child.__previousSibling at index $i is null');
				}
				else if (_child.__previousSibling != __children[i - 1])
				{
					__validateChildrenError(displayObject, '[$label] _child.__previousSibling at index $i does not match');
				}
			}

			if (i < __children.length - 1)
			{
				if (_child.__nextSibling == null)
				{
					__validateChildrenError(displayObject, '[$label] _child.__nextSibling at index $i is null');
				}
				else if (_child.__nextSibling != __children[i + 1])
				{
					__validateChildrenError(displayObject, '[$label] _child.__nextSibling at index $i does not match');
				}
			}

			child = _child.__nextSibling;
		}

		var child = __firstChild;
		_child = cast child._;
		if (child != null)
		{
			if (__lastChild != __children[__children.length - 1])
			{
				__validateChildrenError(displayObject, '[$label] lastChild does not match');
			}
			if (__lastChild._.__nextSibling != null)
			{
				__validateChildrenError(displayObject, '[$label] last_child.__nextSibling is not null');
			}
		}
	}

	private static function __validateChildrenError(displayObject:DisplayObject, message:String):Void
	{
		var _displayObject:_DisplayObject = cast displayObject._;

		trace("ERROR: " + message);

		var msg = "__children: [";
		for (i in 0..._displayObject.__children.length)
		{
			msg += (_displayObject.__children[i] != null ? _displayObject.__children[i].name : null) + ",";
		}
		msg += "]";
		trace(msg);

		var msg = "child list: [";
		var child = _displayObject.__firstChild;
		while (child != null)
		{
			msg += (child != null ? child.name : null) + ",";
			child = (child._ : _DisplayObject).__nextSibling;
		}
		msg += "]";
		trace(msg);

		throw message;
	}

	@:noCompletion private static function __validateChildrenInit(displayObject:DisplayObjectContainer, methodName:String, args:Array<Dynamic>):Void
	{
		var _displayObject:_DisplayObject = cast displayObject._;

		var msg = methodName + "(";
		for (i in 0...args.length)
		{
			var arg = args[i];
			if (arg == null)
			{
				msg += "null";
			}
			else if (Std.is(arg, DisplayObject))
			{
				msg += cast(arg, DisplayObject).name;
			}
			else
			{
				msg += Std.string(arg);
			}

			if (i < args.length - 1)
			{
				msg += ", ";
			}
		}
		msg += ")";
		trace(msg);

		var msg = "__children: [";
		for (i in 0..._displayObject.__children.length)
		{
			msg += (_displayObject.__children[i] != null ? _displayObject.__children[i].name : null) + ",";
		}
		msg += "]";
		trace(msg);

		var msg = "child list: [";
		var child = _displayObject.__firstChild;
		while (child != null)
		{
			msg += (child != null ? child.name : null) + ",";
			child = (child._ : _DisplayObject).__nextSibling;
		}
		msg += "]";
		trace(msg);
	}
	#end
}
