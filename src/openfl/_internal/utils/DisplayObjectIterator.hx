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
	private var gotNext:Bool;
	private var renderer:DisplayObjectRenderer;

	public function new()
	{
		entry = null;
		current = null;
	}

	private function getNext(skip:Bool = false):Void
	{
		if (!gotNext && current != null)
		{
			if (current.__firstChild != null && !skip)
			{
				if (renderer != null)
				{
					renderer.__pushObject(current);
				}
				current = current.__firstChild;
			}
			else if (current.__nextSibling != null)
			{
				if (current == entry)
				{
					current = null;
					gotNext = true;
					DisplayObject.__childIterators.release(this);
					return;
				}
				else
				{
					current = current.__nextSibling;
				}
			}
			else
			{
				if (renderer != null)
				{
					renderer.__popObject(current);
				}

				do
				{
					current = current.parent;
					if (renderer != null && current != null)
					{
						renderer.__popObject(current);
					}

					if (current == null || current == entry)
					{
						current = null;
						DisplayObject.__childIterators.release(this);
						gotNext = true;
						return;
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
			gotNext = true;
		}
	}

	public function hasNext():Bool
	{
		getNext();
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

		gotNext = true;
	}

	public function next():DisplayObject
	{
		if (!gotNext) getNext();
		gotNext = false;
		return current;
	}

	public function skip(current:DisplayObject):Void
	{
		if (current.__firstChild != null)
		{
			if (current == entry)
			{
				this.current = null;
				DisplayObject.__childIterators.release(this);
			}
			else
			{
				this.current = current;
				getNext(true);
			}
		}
	}
}
