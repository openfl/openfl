package openfl._internal.utils;

import openfl.display.DisplayObject;
import openfl.display._DisplayObject;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:access(openfl.display.DisplayObject)
class DisplayObjectIterator
{
	private var current:DisplayObject;
	private var entry:DisplayObject;

	public function new()
	{
		entry = null;
		current = null;
	}

	public function hasNext():Bool
	{
		return (current != null);
	}

	public function init(displayObject:DisplayObject, childrenOnly:Bool):Void
	{
		entry = displayObject;

		if (entry != null)
		{
			current = childrenOnly ? (entry._ : _DisplayObject).__firstChild : entry;
		}
		else
		{
			current = null;
		}
	}

	public function next():DisplayObject
	{
		var _current = current;
		if ((current._ : _DisplayObject).__firstChild != null)
		{
			current = (current._ : _DisplayObject).__firstChild;
		}
		else if ((current._ : _DisplayObject).__nextSibling != null)
		{
			current = (current._ : _DisplayObject).__nextSibling;
		}
		else
		{
			do
			{
				if (current.parent == null || current.parent == entry)
				{
					current = null;
					_DisplayObject.__childIterators.release(this);
					return _current;
				}
				current = current.parent;
			}
			while ((current._ : _DisplayObject).__nextSibling == null);
			current = (current._ : _DisplayObject).__nextSibling;
			if (current == null)
			{
				_DisplayObject.__childIterators.release(this);
			}
		}
		return _current;
	}

	public function skip(current:DisplayObject):Void
	{
		if ((current._ : _DisplayObject).__firstChild == null)
		{
			return;
		}

		if ((current._ : _DisplayObject).__firstChild == this.current)
		{
			if ((current._ : _DisplayObject).__nextSibling != null)
			{
				this.current = (current._ : _DisplayObject).__nextSibling;
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
				while ((current._ : _DisplayObject).__nextSibling == null);
				this.current = (current._ : _DisplayObject).__nextSibling;
			}
		}
	}
}
