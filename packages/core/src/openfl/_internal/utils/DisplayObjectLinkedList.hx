package openfl._internal.utils;

import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;

@:access(openfl.display.DisplayObject)
class DisplayObjectLinkedList
{
	public static #if !openfl_validate_children /*inline*/ #end function __addChild(displayObject:DisplayObjectContainer, child:DisplayObject):Void
	{
		if (child == displayObject._.__lastChild)
		{
			return;
		}

		// var args:Array<Dynamic> = [child];
		// __validateChildrenInit(displayObject, "__addChild", args);

		if (displayObject._.__firstChild == child)
		{
			displayObject._.__firstChild = child._.__nextSibling;
		}
		else if (child._.__previousSibling != null)
		{
			child._.__previousSibling._.__nextSibling = child._.__nextSibling;
		}

		if (child._.__nextSibling != null)
		{
			child._.__nextSibling._.__previousSibling = child._.__previousSibling;
		}

		if (displayObject._.__firstChild == null)
		{
			displayObject._.__firstChild = child;
		}

		if (displayObject._.__lastChild != null)
		{
			displayObject._.__lastChild._.__nextSibling = child;
			child._.__previousSibling = displayObject._.__lastChild;
		}

		displayObject._.__lastChild = child;
		child._.__nextSibling = null;

		#if openfl_validate_children
		displayObject._.__children.remove(child);
		displayObject._.__children.push(child);
		__validateChildren(displayObject, "__addChild");
		#end
	}

	public static function __insertChildAfter(displayObject:DisplayObjectContainer, child:DisplayObject, before:DisplayObject):Void
	{
		if (before == child || before._.__nextSibling == child)
		{
			return;
		}

		// var args:Array<Dynamic> = [child, before];
		// __validateChildrenInit(displayObject, "__insertChildAfter", args);

		var after = before._.__nextSibling;

		if (displayObject._.__firstChild == child)
		{
			displayObject._.__firstChild = child._.__nextSibling;
		}

		if (displayObject._.__lastChild == child)
		{
			displayObject._.__lastChild = child._.__previousSibling;
		}

		if (child._.__previousSibling != null)
		{
			child._.__previousSibling._.__nextSibling = child._.__nextSibling;
		}

		if (child._.__nextSibling != null)
		{
			child._.__nextSibling._.__previousSibling = child._.__previousSibling;
		}

		child._.__previousSibling = before;
		child._.__nextSibling = after;

		if (before != null)
		{
			before._.__nextSibling = child;
		}

		if (after != null)
		{
			after._.__previousSibling = child;
		}
		else
		{
			displayObject._.__lastChild = child;
		}

		#if openfl_validate_children
		displayObject._.__children.remove(child);
		var index = displayObject._.__children.indexOf(before) + 1;
		var childIndex = displayObject._.__children.indexOf(child);
		if (childIndex != index)
		{
			if (childIndex != -1 && childIndex < index)
			{
				index--;
			}
			displayObject._.__children.insert(index, child);
		}
		__validateChildren(displayObject, "__insertChildAfter");
		#end
	}

	public static function __insertChildBefore(displayObject:DisplayObjectContainer, child:DisplayObject, after:DisplayObject):Void
	{
		if (after != null && child != after && after._.__previousSibling != child)
		{
			if (after._.__previousSibling != null)
			{
				__insertChildAfter(displayObject, child, after._.__previousSibling);
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
		if (index == 0)
		{
			__unshiftChild(displayObject, child);
		}
		else
		{
			// var args:Array<Dynamic> = [child, index];
			// __validateChildrenInit(displayObject, "__insertChildAt", args);

			var ref = displayObject._.__firstChild;
			var childFound = (ref == child);
			for (i in 0...(index - 1))
			{
				ref = ref._.__nextSibling;
				if (ref == null)
				{
					break;
				}
				else if (ref == child)
				{
					childFound = true;
				}
			}

			if (childFound && ref._.__nextSibling != null)
			{
				ref = ref._.__nextSibling;
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
		// var args:Array<Dynamic> = [child];
		// __validateChildrenInit(displayObject, "__removeChild", args);

		child._.parent = null;
		displayObject._.numChildren--;

		if (displayObject._.__firstChild == child)
		{
			displayObject._.__firstChild = child._.__nextSibling;
		}

		if (displayObject._.__lastChild == child)
		{
			displayObject._.__lastChild = child._.__previousSibling;
		}

		if (child._.__previousSibling != null)
		{
			child._.__previousSibling._.__nextSibling = child._.__nextSibling;
		}

		if (child._.__nextSibling != null)
		{
			child._.__nextSibling._.__previousSibling = child._.__previousSibling;
		}

		child._.__previousSibling = null;
		child._.__nextSibling = null;

		#if openfl_validate_children
		displayObject._.__children.remove(child);
		__validateChildren(displayObject, "__removeChild");
		#end
	}

	public static inline function __reparent(displayObject:DisplayObjectContainer, child:DisplayObject):Void
	{
		if (child.parent != displayObject)
		{
			if (child.parent != null)
			{
				child.parent.removeChild(child);
			}
			child._.parent = displayObject;
			displayObject._.numChildren++;
		}
	}

	public static function __swapChildren(displayObject:DisplayObjectContainer, child1:DisplayObject, child2:DisplayObject):Void
	{
		// var args:Array<Dynamic> = [child1, child2];
		// __validateChildrenInit(displayObject, "__swapChildren", args);

		if (child1._.__nextSibling == child2 || child2._.__nextSibling == child1)
		{
			var first, second;
			if (child1._.__nextSibling == child2)
			{
				first = child1;
				second = child2;
			}
			else
			{
				first = child2;
				second = child1;
			}

			var before = first._.__previousSibling;
			var after = second._.__nextSibling;

			first._.__previousSibling = second;
			first._.__nextSibling = after;
			second._.__previousSibling = before;
			second._.__nextSibling = first;

			if (before != null)
			{
				before._.__nextSibling = second;
			}

			if (after != null)
			{
				after._.__previousSibling = first;
			}
		}
		else
		{
			var prev1 = child1._.__previousSibling;
			var next1 = child1._.__nextSibling;
			var prev2 = child2._.__previousSibling;
			var next2 = child2._.__nextSibling;

			child1._.__previousSibling = prev2;
			child1._.__nextSibling = next2;
			child2._.__previousSibling = prev1;
			child2._.__nextSibling = next1;

			if (prev1 != null)
			{
				prev1._.__nextSibling = child2;
			}

			if (next1 != null)
			{
				next1._.__previousSibling = child2;
			}

			if (prev2 != null)
			{
				prev2._.__nextSibling = child1;
			}

			if (next2 != null)
			{
				next2._.__previousSibling = child1;
			}
		}

		if (displayObject._.__firstChild == child1)
		{
			displayObject._.__firstChild = child2;
		}
		else if (displayObject._.__firstChild == child2)
		{
			displayObject._.__firstChild = child1;
		}

		if (displayObject._.__lastChild == child1)
		{
			displayObject._.__lastChild = child2;
		}
		else if (displayObject._.__lastChild == child2)
		{
			displayObject._.__lastChild = child1;
		}

		#if openfl_validate_children
		var index1 = displayObject._.__children.indexOf(child1);
		var index2 = displayObject._.__children.indexOf(child2);
		displayObject._.__children[index1] = child2;
		displayObject._.__children[index2] = child1;
		__validateChildren(displayObject, "__swapChildren");
		#end
	}

	public static #if !openfl_validate_children /*inline*/ #end function __unshiftChild(displayObject:DisplayObjectContainer, child:DisplayObject):Void
	{
		if (displayObject._.__firstChild == child)
		{
			return;
		}

		// var args:Array<Dynamic> = [child];
		// __validateChildrenInit(displayObject, "__unshiftChild", args);

		if (child._.__previousSibling != null)
		{
			child._.__previousSibling._.__nextSibling = child._.__nextSibling;
		}

		if (child._.__nextSibling != null)
		{
			child._.__nextSibling._.__previousSibling = child._.__previousSibling;
		}

		if (displayObject._.__firstChild != null)
		{
			displayObject._.__firstChild._.__previousSibling = child;
		}

		if (child == displayObject._.__lastChild)
		{
			displayObject._.__lastChild = child._.__previousSibling;
		}

		child._.__previousSibling = null;
		child._.__nextSibling = displayObject._.__firstChild;
		displayObject._.__firstChild = child;

		if (child._.__nextSibling == null)
		{
			displayObject._.__lastChild = child;
		}

		#if openfl_validate_children
		displayObject._.__children.remove(child);
		displayObject._.__children.insert(0, child);
		__validateChildren(displayObject, "__unshiftChild");
		#end
	}

	#if openfl_validate_children
	public static function __validateChildren(displayObject:DisplayObjectContainer, label:String):Void
	{
		var numChildren = displayObject.numChildren;
		var __firstChild = displayObject._.__firstChild;
		var __lastChild = displayObject._.__lastChild;
		var __children = displayObject._.__children;

		var numChildrenCorrect = (numChildren == __children.length);
		var firstChildMatches = (__firstChild == __children[0]);
		var checkMap = new Map<DisplayObject, Bool>();

		for (i in 0...displayObject._.__children.length)
		{
			if (checkMap.exists(displayObject._.__children[i]))
			{
				__validateChildrenError(displayObject, '[$label] Duplicate child detected in validation array');
			}
			else
			{
				checkMap[displayObject._.__children[i]] = true;
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
		if (child != null)
		{
			if (child._.__previousSibling != null)
			{
				__validateChildrenError(displayObject, '[$label] firstChild._.__previousSibling is not null');
			}
		}

		var child = __firstChild;
		for (i in 0..._.__children.length)
		{
			if (child != __children[i])
			{
				__validateChildrenError(displayObject, '[$label] child $i does not match');
			}

			if (i > 0)
			{
				if (child._.__previousSibling == null)
				{
					__validateChildrenError(displayObject, '[$label] child._.__previousSibling at index $i is null');
				}
				else if (child._.__previousSibling != __children[i - 1])
				{
					__validateChildrenError(displayObject, '[$label] child._.__previousSibling at index $i does not match');
				}
			}

			if (i < __children.length - 1)
			{
				if (child._.__nextSibling == null)
				{
					__validateChildrenError(displayObject, '[$label] child._.__nextSibling at index $i is null');
				}
				else if (child._.__nextSibling != __children[i + 1])
				{
					__validateChildrenError(displayObject, '[$label] child._.__nextSibling at index $i does not match');
				}
			}

			child = child._.__nextSibling;
		}

		var child = __firstChild;
		if (child != null)
		{
			if (__lastChild != __children[__children.length - 1])
			{
				__validateChildrenError(displayObject, '[$label] lastChild does not match');
			}
			if (__lastChild._.__nextSibling != null)
			{
				__validateChildrenError(displayObject, '[$label] lastChild._.__nextSibling is not null');
			}
		}
	}

	private static function __validateChildrenError(displayObject:DisplayObject, message:String):Void
	{
		trace("ERROR: " + message);

		var msg = "__children: [";
		for (i in 0...displayObject._.__children.length)
		{
			msg += (displayObject._.__children[i] != null ? displayObject._.__children[i].name : null) + ",";
		}
		msg += "]";
		trace(msg);

		var msg = "child list: [";
		var _child = displayObject._.__firstChild;
		while (_child != null)
		{
			msg += (_child != null ? _child.name : null) + ",";
			_child = _child._.__nextSibling;
		}
		msg += "]";
		trace(msg);

		throw message;
	}

	@:noCompletion private static function __validateChildrenInit(displayObject:DisplayObjectContainer, methodName:String, args:Array<Dynamic>):Void
	{
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
		for (i in 0...displayObject._.__children.length)
		{
			msg += (displayObject._.__children[i] != null ? displayObject._.__children[i].name : null) + ",";
		}
		msg += "]";
		trace(msg);

		var msg = "child list: [";
		var _child = displayObject._.__firstChild;
		while (_child != null)
		{
			msg += (_child != null ? _child.name : null) + ",";
			_child = _child._.__nextSibling;
		}
		msg += "]";
		trace(msg);
	}
	#end
}
