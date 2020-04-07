import * as internal from "../../_internal/utils/InternalAccess";
import DisplayObject from "../../display/DisplayObject";

export default class DisplayObjectIterator
{
	private current: DisplayObject;
	private entry: DisplayObject;

	public constructor()
	{
		this.entry = null;
		this.current = null;
	}

	// public hasNext(): boolean
	// {
	// 	return (current != null);
	// }

	public init(displayObject: DisplayObject, childrenOnly: boolean): void
	{
		this.entry = displayObject;

		if (this.entry != null)
		{
			this.current = childrenOnly ? (<internal.DisplayObject><any>this.entry).__firstChild : this.entry;
		}
		else
		{
			this.current = null;
		}
	}

	public [Symbol.iterator]()
	{
		return this;
	}

	public next(): IteratorResult<DisplayObject>
	{
		var _current = this.current;
		if ((<internal.DisplayObject><any>this.current).__firstChild != null)
		{
			this.current = (<internal.DisplayObject><any>this.current).__firstChild;
		}
		else if ((<internal.DisplayObject><any>this.current).__nextSibling != null)
		{
			this.current = (<internal.DisplayObject><any>this.current).__nextSibling;
		}
		else
		{
			do
			{
				if (this.current.parent == null || this.current.parent == this.entry)
				{
					this.current = null;
					(<internal.DisplayObject><any>DisplayObject).__childIterators.release(this);
					return { value: _current, done: (this.current != null) };
				}
				this.current = this.current.parent;
			}
			while ((<internal.DisplayObject><any>this.current).__nextSibling == null);
			this.current = (<internal.DisplayObject><any>this.current).__nextSibling;
			if (this.current == null)
			{
				(<internal.DisplayObject><any>DisplayObject).__childIterators.release(this);
			}
		}

		return { value: _current, done: (this.current != null) };
	}

	public skip(current: DisplayObject): void
	{
		if ((<internal.DisplayObject><any>current).__firstChild == null)
		{
			return;
		}

		if ((<internal.DisplayObject><any>current).__firstChild == this.current)
		{
			if ((<internal.DisplayObject><any>current).__nextSibling != null)
			{
				this.current = (<internal.DisplayObject><any>current).__nextSibling;
			}
			else
			{
				do
				{
					if (current.parent == null || current.parent == this.entry)
					{
						this.current = null;
						return;
					}
					current = current.parent;
				}
				while ((<internal.DisplayObject><any>current).__nextSibling == null);
				this.current = (<internal.DisplayObject><any>current).__nextSibling;
			}
		}
	}
}
