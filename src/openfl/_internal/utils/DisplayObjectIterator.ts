import DisplayObject from "../../display/DisplayObject";

export default class DisplayObjectIterator
{
	private current: DisplayObject;
	private entry: DisplayObject;

	public constructor()
	{
		entry = null;
		current = null;
	}

	public hasNext(): boolean
	{
		return (current != null);
	}

	public init(displayObject: DisplayObject, childrenOnly: boolean): void
	{
		entry = displayObject;

		if (entry != null)
		{
			current = childrenOnly ? entry.__firstChild : entry;
		}
		else
		{
			current = null;
		}
	}

	public next(): DisplayObject
	{
		var _current = current;
		if (current.__firstChild != null)
		{
			current = current.__firstChild;
		}
		else if (current.__nextSibling != null)
		{
			current = current.__nextSibling;
		}
		else
		{
			do
			{
				if (current.parent == null || current.parent == entry)
				{
					current = null;
					DisplayObject.__childIterators.release(this);
					return _current;
				}
				current = current.parent;
			}
			while (current.__nextSibling == null);
			current = current.__nextSibling;
			if (current == null)
			{
				DisplayObject.__childIterators.release(this);
			}
		}
		return _current;
	}

	public skip(current: DisplayObject): void
	{
		if (current.__firstChild == null)
		{
			return;
		}

		if (current.__firstChild == this.current)
		{
			if (current.__nextSibling != null)
			{
				this.current = current.__nextSibling;
			}
			else
			{
				do
				{
					if (current.parent == null || current.parent == entry)
					{
						this.current = null;
						return;
					}
					current = current.parent;
				}
				while (current.__nextSibling == null);
				this.current = current.__nextSibling;
			}
		}
	}
}
