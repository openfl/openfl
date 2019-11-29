package openfl._internal.utils;

import openfl.display.DisplayObject;

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

	public function new(displayObject:DisplayObject)
	{
		entry = displayObject;

		if (entry != null)
		{
			current = entry.__firstChild;
		}
		else
		{
			current = null;
		}
	}

	public function hasNext():Bool
	{
		return (current != null);
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
					current = null;
					return _current;
				}
				current = current.parent;
			}
			while (current.__nextSibling == null);
			current = current.__nextSibling;
		}
		return _current;
	}
}
