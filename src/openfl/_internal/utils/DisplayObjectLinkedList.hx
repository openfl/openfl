package openfl._internal.utils;

import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;

@:access(openfl.display.DisplayObject)
class DisplayObjectLinkedList
{
	public static #if !openfl_validate_children inline #end function __addChild(displayObject:DisplayObjectContainer, child:DisplayObject):Void
	{
		if (child.parent != displayObject)
		{
			if (child.parent != null)
			{
				child.parent.removeChild(child);
			}
			child.parent = displayObject;
			displayObject.numChildren++;
		}

		if (displayObject.__firstChild == child)
		{
			displayObject.__firstChild = child.__nextSibling;
		}
		else if (child.__previousSibling != null)
		{
			child.__previousSibling.__nextSibling = child.__nextSibling;
		}

		if (child.__nextSibling != null)
		{
			child.__nextSibling.__previousSibling = child.__previousSibling;
		}

		if (displayObject.__firstChild == null)
		{
			displayObject.__firstChild = child;
		}

		if (displayObject.__lastChild != null)
		{
			displayObject.__lastChild.__nextSibling = child;
			child.__previousSibling = displayObject.__lastChild;
		}

		displayObject.__lastChild = child;
		child.__nextSibling = null;

		#if openfl_validate_children
		displayObject.__children.remove(child);
		displayObject.__children.push(child);
		__validateChildren(displayObject, "addChild");
		#end
	}

	public static function __insertChildAfter(displayObject:DisplayObjectContainer, child:DisplayObject, before:DisplayObject):Void
	{
		if (before == child || before.__nextSibling == child)
		{
			return;
		}

		if (child.parent != displayObject)
		{
			if (child.parent != null)
			{
				child.parent.removeChild(child);
			}
			child.parent = displayObject;
			displayObject.numChildren++;
		}

		var after = before.__nextSibling;

		if (displayObject.__firstChild == child)
		{
			displayObject.__firstChild = child.__nextSibling;
		}

		if (child.__previousSibling != null)
		{
			child.__previousSibling.__nextSibling = child.__nextSibling;
		}

		if (child.__nextSibling != null)
		{
			child.__nextSibling.__previousSibling = child.__previousSibling;
		}

		child.__previousSibling = before;
		child.__nextSibling = after;

		if (before != null)
		{
			before.__nextSibling = child;
		}

		if (after != null)
		{
			after.__previousSibling = child;
			if (displayObject.__lastChild == child)
			{
				displayObject.__lastChild = after;
			}
		}
		else
		{
			displayObject.__lastChild = child;
		}

		#if openfl_validate_children
		displayObject.__children.remove(child);
		var index = displayObject.__children.indexOf(before) + 1;
		displayObject.__children.insert(index, child);
		__validateChildren(displayObject, "insertChildAfter");
		#end
	}

	public static function __insertChildBefore(displayObject:DisplayObjectContainer, child:DisplayObject, after:DisplayObject):Void
	{
		if (after != null && child != after && after.__previousSibling != child)
		{
			if (after.__previousSibling != null)
			{
				__insertChildAfter(displayObject, child, after.__previousSibling);
			}
			else
			{
				__unshiftChild(displayObject, child);
			}
		}
	}

	public static #if !openfl_validate_children inline #end function __insertChildAt(displayObject:DisplayObjectContainer, child:DisplayObject, index:Int):Void
	{
		if (index == 0)
		{
			__unshiftChild(displayObject, child);
		}
		else
		{
			var ref = displayObject.__firstChild;
			for (i in 0...(index - 1))
			{
				ref = ref.__nextSibling;
			}

			if (ref == child)
			{
				__swapChildren(displayObject, child, child.__nextSibling);
			}
			else
			{
				__insertChildAfter(displayObject, child, ref);
			}
		}
	}

	public static #if !openfl_validate_children inline #end function __removeChild(displayObject:DisplayObjectContainer, child:DisplayObject):Void
	{
		child.parent = null;
		displayObject.numChildren--;

		if (displayObject.__firstChild == child)
		{
			displayObject.__firstChild = child.__nextSibling;
		}

		if (displayObject.__lastChild == child)
		{
			displayObject.__lastChild = child.__previousSibling;
		}

		if (child.__previousSibling != null)
		{
			child.__previousSibling.__nextSibling = child.__nextSibling;
		}

		if (child.__nextSibling != null)
		{
			child.__nextSibling.__previousSibling = child.__previousSibling;
		}

		child.__previousSibling = null;
		child.__nextSibling = null;

		#if openfl_validate_children
		displayObject.__children.remove(child);
		__validateChildren(displayObject, "removeChild");
		#end
	}

	public static function __swapChildren(displayObject:DisplayObjectContainer, child1:DisplayObject, child2:DisplayObject):Void
	{
		if (child1.__nextSibling == child2 || child2.__nextSibling == child1)
		{
			var first, second;
			if (child1.__nextSibling == child2)
			{
				first = child1;
				second = child2;
			}
			else
			{
				first = child2;
				second = child1;
			}

			var before = first.__previousSibling;
			var after = second.__nextSibling;

			first.__previousSibling = second;
			first.__nextSibling = after;
			second.__previousSibling = before;
			second.__nextSibling = first;

			if (before != null)
			{
				before.__nextSibling = second;
			}

			if (after != null)
			{
				after.__previousSibling = first;
			}
		}
		else
		{
			var prev1 = child1.__previousSibling;
			var next1 = child1.__nextSibling;
			var prev2 = child2.__previousSibling;
			var next2 = child2.__nextSibling;

			child1.__previousSibling = prev2;
			child1.__nextSibling = next2;
			child2.__previousSibling = prev1;
			child2.__nextSibling = next1;

			if (prev1 != null)
			{
				prev1.__nextSibling = child2;
			}

			if (next1 != null)
			{
				next1.__previousSibling = child2;
			}

			if (prev2 != null)
			{
				prev2.__nextSibling = child1;
			}

			if (next2 != null)
			{
				next2.__previousSibling = child1;
			}
		}

		if (displayObject.__firstChild == child1)
		{
			displayObject.__firstChild = child2;
		}
		else if (displayObject.__firstChild == child2)
		{
			displayObject.__firstChild = child1;
		}

		if (displayObject.__lastChild == child1)
		{
			displayObject.__lastChild = child2;
		}
		else if (displayObject.__lastChild == child2)
		{
			displayObject.__lastChild = child1;
		}

		#if openfl_validate_children
		var index1 = displayObject.__children.indexOf(child1);
		var index2 = displayObject.__children.indexOf(child2);
		displayObject.__children[index1] = child2;
		displayObject.__children[index2] = child1;
		__validateChildren(displayObject, "swapChildren");
		#end
	}

	public static #if !openfl_validate_children inline #end function __unshiftChild(displayObject:DisplayObjectContainer, child:DisplayObject):Void
	{
		if (child.parent != displayObject)
		{
			if (child.parent != null)
			{
				child.parent.removeChild(child);
			}
			child.parent = displayObject;
			displayObject.numChildren++;
		}

		if (child.__previousSibling != null)
		{
			child.__previousSibling.__nextSibling = child.__nextSibling;
		}

		if (child.__nextSibling != null)
		{
			child.__nextSibling.__previousSibling = child.__previousSibling;
		}

		if (displayObject.__firstChild != null)
		{
			displayObject.__firstChild.__previousSibling = child;
		}

		if (child == displayObject.__lastChild)
		{
			displayObject.__lastChild = child.__previousSibling;
		}

		child.__previousSibling = null;
		child.__nextSibling = displayObject.__firstChild;
		displayObject.__firstChild = child;

		if (child.__nextSibling == null)
		{
			displayObject.__lastChild = child;
		}

		#if openfl_validate_children
		displayObject.__children.remove(child);
		displayObject.__children.insert(0, child);
		__validateChildren(displayObject, "addChildAt (index == 0)");
		#end
	}

	#if openfl_validate_children
	@:noCompletion private static function __validateChildren(displayObject:DisplayObjectContainer, label:String):Void
	{
		var numChildren = displayObject.numChildren;
		var __firstChild = displayObject.__firstChild;
		var __lastChild = displayObject.__lastChild;
		var __children = displayObject.__children;

		var numChildrenCorrect = (numChildren == __children.length);
		var firstChildMatches = (__firstChild == __children[0]);
		// var lastChildMatches = (__lastChild == __children[__children.length - 1]);

		// var map = new Map<DisplayObject, Bool>();
		var checkMap = new Map<DisplayObject, Bool>();

		// trace("------------" + label);
		// trace((firstChildMatches ? "CORRECT" : "ERROR") + " - FIRST CHILD: " + (__firstChild != null ? __firstChild.name : null));
		// trace((lastChildMatches ? "CORRECT" : "ERROR") + " - LAST CHILD: " + (__lastChild != null ? __lastChild.name : null));
		// trace((numChildrenCorrect ? "CORRECT" : "ERROR") + " - NUM CHILDREN: " + numChildren);

		for (i in 0...displayObject.__children.length)
		{
			if (checkMap.exists(displayObject.__children[i]))
			{
				__validateChildrenError(displayObject, '[$label] Duplicate child detected in validation array');
			}
			else
			{
				checkMap[displayObject.__children[i]] = true;
			}
		}

		var child = __firstChild;
		// var i = 0;
		// while (child != null)
		// {
		// 	// var childMatches = (child == __children[i]);
		// 	// var parentMatches = (__children[i] != null && child.parent == __children[i].parent);
		// 	// var prevSiblingMatches = (child.__previousSibling == __children[i - 1]);
		// 	// var nextSiblingMatches = (child.__nextSibling == __children[i + 1]);

		// 	// trace((childMatches ? "CORRECT" : "ERROR") + " -> CHILD [" + i + "]: " + child.name + " (should be "
		// 	// 	+ (__children[i] != null ? __children[i].name : null) + ")");
		// 	// trace((parentMatches ? "CORRECT" : "ERROR") + " --- PARENT: " + (child.parent != null ? child.parent.name : null));
		// 	// trace((prevSiblingMatches ? "CORRECT" : "ERROR")
		// 	// 	+ " - -- PREV SIBLING: "
		// 	// 	+ (child.__previousSibling != null ? child.__previousSibling.name : null));
		// 	// trace((nextSiblingMatches ? "CORRECT" : "ERROR") + " --- NEXT SIBLING: " + (child.__nextSibling != null ? child.__nextSibling.name : null));

		// 	if (map.exists(child))
		// 	{
		// 		__validateChildrenError(displayObject, '[$label] Duplicate child detected');
		// 	}
		// 	else
		// 	{
		// 		map[child] = true;
		// 	}

		// 	child = child.__nextSibling;
		// 	i++;
		// }

		child = __firstChild;
		if (!numChildrenCorrect)
		{
			__validateChildrenError(displayObject, '[$label] numChildren is incorrect');
		}

		if (!firstChildMatches)
		{
			__validateChildrenError(displayObject, '[$label] firstChild does not match');
		}

		if (child != null)
		{
			if (child.__previousSibling != null)
			{
				__validateChildrenError(displayObject, '[$label] firstChild.__previousSibling is not null');
			}
		}

		var child = __firstChild;
		for (i in 0...__children.length)
		{
			if (child != __children[i])
			{
				__validateChildrenError(displayObject, '[$label] child $i does not match');
			}
			if (i > 0)
			{
				if (child.__previousSibling == null)
				{
					__validateChildrenError(displayObject, '[$label] child.__previousSibling at index $i is null');
				}
				else if (child.__previousSibling != __children[i - 1])
				{
					__validateChildrenError(displayObject, '[$label] child.__previousSibling at index $i does not match');
				}
			}
			if (i < __children.length - 1)
			{
				if (child.__nextSibling == null)
				{
					__validateChildrenError(displayObject, '[$label] child.__nextSibling at index $i is null');
				}
				else if (child.__nextSibling != __children[i + 1])
				{
					__validateChildrenError(displayObject, '[$label] child.__nextSibling at index $i does not match');
				}
			}

			child = child.__nextSibling;
		}

		if (child != null)
		{
			if (__lastChild != __children[__children.length - 1])
			{
				__validateChildrenError(displayObject, '[$label] lastChild does not match');
			}
			if (__lastChild.__nextSibling != null)
			{
				__validateChildrenError(displayObject, '[$label] lastChild.__nextSibling is not null');
			}
		}
	}

	private static function __validateChildrenError(displayObject:DisplayObject, message:String):Void
	{
		trace("ERROR: " + message);

		var msg = "__children: [";
		for (i in 0...displayObject.__children.length)
		{
			msg += (displayObject.__children[i] != null ? displayObject.__children[i].name : null) + ",";
		}
		msg += "]";
		trace(msg);

		var msg = "child list: [";
		var _child = displayObject.__firstChild;
		while (_child != null)
		{
			msg += (_child != null ? _child.name : null) + ",";
			_child = _child.__nextSibling;
		}
		msg += "]";
		trace(msg);

		throw message;
	}
	#end
}
