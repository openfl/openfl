package openfl._internal.utils;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectRenderer;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:access(openfl.display.DisplayObject)
@:access(openfl.display.DisplayObjectRenderer)
class DisplayObjectIterator
{
	private var current:DisplayObject;
	private var entry:DisplayObject;
	private var renderer:DisplayObjectRenderer;

	public function new()
	{
		entry = null;
		current = null;
	}

	public function hasNext():Bool
	{
		return (current != null);
	}

	public function init(displayObject:DisplayObject, childrenOnly:Bool, renderer:DisplayObjectRenderer):Void
	{
		entry = displayObject;
		this.renderer = renderer;

		if (entry != null)
		{
			current = childrenOnly ? entry.__firstChild : entry;
		}
		else
		{
			current = null;
		}
	}

	public function next():DisplayObject
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
					if (renderer != null)
					{
						renderer.__popObject(entry);
					}
					current = null;
					DisplayObject.__childIterators.release(this);
					return _current;
				}
				else
				{
					current = current.parent;
					if (renderer != null && current != null)
					{
						renderer.__popObject(current);
					}
				}
			}
			while (current.__nextSibling == null);

			current = current.__nextSibling;

			if (current == null)
			{
				if (renderer != null)
				{
					renderer.__popObject(entry);
				}
				DisplayObject.__childIterators.release(this);
			}
		}

		if (renderer != null && current != null && current.__firstChild != null)
		{
			renderer.__pushObject(current);
		}

		return _current;
	}

	public function skip(current:DisplayObject):Void
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
						if (renderer != null)
						{
							renderer.__popObject(entry);
						}
						this.current = null;
						return;
					}
					current = current.parent;
					if (renderer != null && current != null)
					{
						renderer.__popObject(current);
					}
				}
				while (current.__nextSibling == null);

				this.current = current.__nextSibling;
			}
		}
	}
}
