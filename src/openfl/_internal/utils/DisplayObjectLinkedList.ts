import DisplayObjectContainer from "../../display/DisplayObjectContainer";
import DisplayObject from "../../display/DisplayObject";

export default class DisplayObjectLinkedList
{
	public static __addChild(displayObject: DisplayObjectContainer, child: DisplayObject): void
	{
		if (child == displayObject.__lastChild)
		{
			return;
		}

		// args:Array<Dynamic> = [child];
		// __validateChildrenInit(displayObject, "__addChild", args);

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
	}

	public static __insertChildAfter(displayObject: DisplayObjectContainer, child: DisplayObject, before: DisplayObject): void
	{
		if (before == child || before.__nextSibling == child)
		{
			return;
		}

		// args:Array<Dynamic> = [child, before];
		// __validateChildrenInit(displayObject, "__insertChildAfter", args);

		var after = before.__nextSibling;

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

		child.__previousSibling = before;
		child.__nextSibling = after;

		if (before != null)
		{
			before.__nextSibling = child;
		}

		if (after != null)
		{
			after.__previousSibling = child;
		}
		else
		{
			displayObject.__lastChild = child;
		}
	}

	public static __insertChildBefore(displayObject: DisplayObjectContainer, child: DisplayObject, after: DisplayObject): void
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

	public static __insertChildAt(displayObject: DisplayObjectContainer, child: DisplayObject,
		index: number): void
	{
		if (index == 0)
		{
			__unshiftChild(displayObject, child);
		}
		else
		{
			// args:Array<Dynamic> = [child, index];
			// __validateChildrenInit(displayObject, "__insertChildAt", args);

			var ref = displayObject.__firstChild;
			var childFound = (ref == child);
			for (i in 0...(index - 1))
			{
				ref = ref.__nextSibling;
				if (ref == null)
				{
					break;
				}
				else if (ref == child)
				{
					childFound = true;
				}
			}

			if (childFound && ref.__nextSibling != null)
			{
				ref = ref.__nextSibling;
			}

			if (ref == child)
			{
				return;
			}

			__insertChildAfter(displayObject, child, ref);
		}
	}

	public static __removeChild(displayObject: DisplayObjectContainer, child: DisplayObject): void
	{
		// args:Array<Dynamic> = [child];
		// __validateChildrenInit(displayObject, "__removeChild", args);

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
	}

	public static readonly __reparent(displayObject: DisplayObjectContainer, child: DisplayObject): void
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
	}

	public static __swapChildren(displayObject: DisplayObjectContainer, child1: DisplayObject, child2: DisplayObject): void
	{
		// args:Array<Dynamic> = [child1, child2];
		// __validateChildrenInit(displayObject, "__swapChildren", args);

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
	}

	public static __unshiftChild(displayObject: DisplayObjectContainer, child: DisplayObject): void
	{
		if (displayObject.__firstChild == child)
		{
			return;
		}

		// args:Array<Dynamic> = [child];
		// __validateChildrenInit(displayObject, "__unshiftChild", args);

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
	}
}
