import * as internal from "../../_internal/utils/InternalAccess";
import DisplayObjectContainer from "../../display/DisplayObjectContainer";
import DisplayObject from "../../display/DisplayObject";

export default class DisplayObjectLinkedList
{
	public static __addChild(displayObject: DisplayObjectContainer, child: DisplayObject): void
	{
		if (child == (<internal.DisplayObject><any>displayObject).__lastChild)
		{
			return;
		}

		// args:Array<Dynamic> = [child];
		// __validateChildrenInit(displayObject, "__addChild", args);

		if ((<internal.DisplayObject><any>displayObject).__firstChild == child)
		{
			(<internal.DisplayObject><any>displayObject).__firstChild = (<internal.DisplayObject><any>child).__nextSibling;
		}
		else if ((<internal.DisplayObject><any>child).__previousSibling != null)
		{
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>child).__previousSibling).__nextSibling = (<internal.DisplayObject><any>child).__nextSibling;
		}

		if ((<internal.DisplayObject><any>child).__nextSibling != null)
		{
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>child).__nextSibling).__previousSibling = (<internal.DisplayObject><any>child).__previousSibling;
		}

		if ((<internal.DisplayObject><any>displayObject).__firstChild == null)
		{
			(<internal.DisplayObject><any>displayObject).__firstChild = child;
		}

		if ((<internal.DisplayObject><any>displayObject).__lastChild != null)
		{
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>displayObject).__lastChild).__nextSibling = child;
			(<internal.DisplayObject><any>child).__previousSibling = (<internal.DisplayObject><any>displayObject).__lastChild;
		}

		(<internal.DisplayObject><any>displayObject).__lastChild = child;
		(<internal.DisplayObject><any>child).__nextSibling = null;
	}

	public static __insertChildAfter(displayObject: DisplayObjectContainer, child: DisplayObject, before: DisplayObject): void
	{
		if (before == child || (<internal.DisplayObject><any>before).__nextSibling == child)
		{
			return;
		}

		// args:Array<Dynamic> = [child, before];
		// __validateChildrenInit(displayObject, "__insertChildAfter", args);

		var after = (<internal.DisplayObject><any>before).__nextSibling;

		if ((<internal.DisplayObject><any>displayObject).__firstChild == child)
		{
			(<internal.DisplayObject><any>displayObject).__firstChild = (<internal.DisplayObject><any>child).__nextSibling;
		}

		if ((<internal.DisplayObject><any>displayObject).__lastChild == child)
		{
			(<internal.DisplayObject><any>displayObject).__lastChild = (<internal.DisplayObject><any>child).__previousSibling;
		}

		if ((<internal.DisplayObject><any>child).__previousSibling != null)
		{
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>child).__previousSibling).__nextSibling = (<internal.DisplayObject><any>child).__nextSibling;
		}

		if ((<internal.DisplayObject><any>child).__nextSibling != null)
		{
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>child).__nextSibling).__previousSibling = (<internal.DisplayObject><any>child).__previousSibling;
		}

		(<internal.DisplayObject><any>child).__previousSibling = before;
		(<internal.DisplayObject><any>child).__nextSibling = after;

		if (before != null)
		{
			(<internal.DisplayObject><any>before).__nextSibling = child;
		}

		if (after != null)
		{
			(<internal.DisplayObject><any>after).__previousSibling = child;
		}
		else
		{
			(<internal.DisplayObject><any>displayObject).__lastChild = child;
		}
	}

	public static __insertChildBefore(displayObject: DisplayObjectContainer, child: DisplayObject, after: DisplayObject): void
	{
		if (after != null && child != after && (<internal.DisplayObject><any>after).__previousSibling != child)
		{
			if ((<internal.DisplayObject><any>after).__previousSibling != null)
			{
				this.__insertChildAfter(displayObject, child, (<internal.DisplayObject><any>after).__previousSibling);
			}
			else
			{
				this.__unshiftChild(displayObject, child);
			}
		}
	}

	public static __insertChildAt(displayObject: DisplayObjectContainer, child: DisplayObject,
		index: number): void
	{
		if (index == 0)
		{
			this.__unshiftChild(displayObject, child);
		}
		else
		{
			// args:Array<Dynamic> = [child, index];
			// __validateChildrenInit(displayObject, "__insertChildAt", args);

			var ref = (<internal.DisplayObject><any>displayObject).__firstChild;
			var childFound = (ref == child);
			for (let i = 0; i < (index - 1); i++)
			{
				ref = (<internal.DisplayObject><any>ref).__nextSibling;
				if (ref == null)
				{
					break;
				}
				else if (ref == child)
				{
					childFound = true;
				}
			}

			if (childFound && (<internal.DisplayObject><any>ref).__nextSibling != null)
			{
				ref = (<internal.DisplayObject><any>ref).__nextSibling;
			}

			if (ref == child)
			{
				return;
			}

			this.__insertChildAfter(displayObject, child, ref);
		}
	}

	public static __removeChild(displayObject: DisplayObjectContainer, child: DisplayObject): void
	{
		// args:Array<Dynamic> = [child];
		// __validateChildrenInit(displayObject, "__removeChild", args);

		(<internal.DisplayObject><any>child).__parent = null;
		(<internal.DisplayObjectContainer><any>displayObject).__numChildren--;

		if ((<internal.DisplayObject><any>displayObject).__firstChild == child)
		{
			(<internal.DisplayObject><any>displayObject).__firstChild = (<internal.DisplayObject><any>child).__nextSibling;
		}

		if ((<internal.DisplayObject><any>displayObject).__lastChild == child)
		{
			(<internal.DisplayObject><any>displayObject).__lastChild = (<internal.DisplayObject><any>child).__previousSibling;
		}

		if ((<internal.DisplayObject><any>child).__previousSibling != null)
		{
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>child).__previousSibling).__nextSibling = (<internal.DisplayObject><any>child).__nextSibling;
		}

		if ((<internal.DisplayObject><any>child).__nextSibling != null)
		{
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>child).__nextSibling).__previousSibling = (<internal.DisplayObject><any>child).__previousSibling;
		}

		(<internal.DisplayObject><any>child).__previousSibling = null;
		(<internal.DisplayObject><any>child).__nextSibling = null;
	}

	public static __reparent(displayObject: DisplayObjectContainer, child: DisplayObject): void
	{
		if (child.parent != displayObject)
		{
			if (child.parent != null)
			{
				child.parent.removeChild(child);
			}
			(<internal.DisplayObject><any>child).__parent = displayObject;
			(<internal.DisplayObjectContainer><any>displayObject).__numChildren++;
		}
	}

	public static __swapChildren(displayObject: DisplayObjectContainer, child1: DisplayObject, child2: DisplayObject): void
	{
		// args:Array<Dynamic> = [child1, child2];
		// __validateChildrenInit(displayObject, "__swapChildren", args);

		if ((<internal.DisplayObject><any>child1).__nextSibling == child2 || (<internal.DisplayObject><any>child2).__nextSibling == child1)
		{
			var first, second;
			if ((<internal.DisplayObject><any>child1).__nextSibling == child2)
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
				(<internal.DisplayObject><any>before).__nextSibling = second;
			}

			if (after != null)
			{
				(<internal.DisplayObject><any>after).__previousSibling = first;
			}
		}
		else
		{
			var prev1 = (<internal.DisplayObject><any>child1).__previousSibling;
			var next1 = (<internal.DisplayObject><any>child1).__nextSibling;
			var prev2 = (<internal.DisplayObject><any>child2).__previousSibling;
			var next2 = (<internal.DisplayObject><any>child2).__nextSibling;

			(<internal.DisplayObject><any>child1).__previousSibling = prev2;
			(<internal.DisplayObject><any>child1).__nextSibling = next2;
			(<internal.DisplayObject><any>child2).__previousSibling = prev1;
			(<internal.DisplayObject><any>child2).__nextSibling = next1;

			if (prev1 != null)
			{
				(<internal.DisplayObject><any>prev1).__nextSibling = child2;
			}

			if (next1 != null)
			{
				(<internal.DisplayObject><any>next1).__previousSibling = child2;
			}

			if (prev2 != null)
			{
				(<internal.DisplayObject><any>prev2).__nextSibling = child1;
			}

			if (next2 != null)
			{
				(<internal.DisplayObject><any>next2).__previousSibling = child1;
			}
		}

		if ((<internal.DisplayObject><any>displayObject).__firstChild == child1)
		{
			(<internal.DisplayObject><any>displayObject).__firstChild = child2;
		}
		else if ((<internal.DisplayObject><any>displayObject).__firstChild == child2)
		{
			(<internal.DisplayObject><any>displayObject).__firstChild = child1;
		}

		if ((<internal.DisplayObject><any>displayObject).__lastChild == child1)
		{
			(<internal.DisplayObject><any>displayObject).__lastChild = child2;
		}
		else if ((<internal.DisplayObject><any>displayObject).__lastChild == child2)
		{
			(<internal.DisplayObject><any>displayObject).__lastChild = child1;
		}
	}

	public static __unshiftChild(displayObject: DisplayObjectContainer, child: DisplayObject): void
	{
		if ((<internal.DisplayObject><any>displayObject).__firstChild == child)
		{
			return;
		}

		// args:Array<Dynamic> = [child];
		// __validateChildrenInit(displayObject, "__unshiftChild", args);

		if ((<internal.DisplayObject><any>child).__previousSibling != null)
		{
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>child).__previousSibling).__nextSibling = (<internal.DisplayObject><any>child).__nextSibling;
		}

		if ((<internal.DisplayObject><any>child).__nextSibling != null)
		{
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>child).__nextSibling).__previousSibling = (<internal.DisplayObject><any>child).__previousSibling;
		}

		if ((<internal.DisplayObject><any>displayObject).__firstChild != null)
		{
			(<internal.DisplayObject><any>(<internal.DisplayObject><any>displayObject).__firstChild).__previousSibling = child;
		}

		if (child == (<internal.DisplayObject><any>displayObject).__lastChild)
		{
			(<internal.DisplayObject><any>displayObject).__lastChild = (<internal.DisplayObject><any>child).__previousSibling;
		}

		(<internal.DisplayObject><any>child).__previousSibling = null;
		(<internal.DisplayObject><any>child).__nextSibling = (<internal.DisplayObject><any>displayObject).__firstChild;
		(<internal.DisplayObject><any>displayObject).__firstChild = child;

		if ((<internal.DisplayObject><any>child).__nextSibling == null)
		{
			(<internal.DisplayObject><any>displayObject).__lastChild = child;
		}
	}
}
