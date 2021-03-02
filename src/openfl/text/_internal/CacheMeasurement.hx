package openfl.text._internal;

import haxe.ds.IntMap;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class CacheMeasurement
{
	private var __collisions:Array<String>;
	private var __wordMap:IntMap<#if (js && html5) Array<Float> #else Array<GlyphPosition> #end>;

	public var hash:Int;

	public function new(wordKey:String, positions:#if (js && html5) Array<Float> #else Array<GlyphPosition> #end)
	{
		// We create a collection of collisions to store our measurements in case 2 hashes collide.
		__collisions = [];
		__wordMap = new IntMap();

		set(wordKey, positions);
	}

	public function set(wordKey:String, positions:#if (js && html5) Array<Float> #else Array<GlyphPosition> #end):Void
	{
		__addCollision(wordKey, positions);
	}

	public function get(wordKey:String):#if (js && html5) Array<Float> #else Array<GlyphPosition> #end
	{
		// If collision exists, do a slow lookup, else do a fast lookup.
		if (__collisions.length > 1)
		{
			return __wordMap.get(__collisions.indexOf(wordKey));
		}
		return __wordMap.get(0);
	}

	private function __addCollision(wordKey:String, positions:#if (js && html5) Array<Float> #else Array<GlyphPosition> #end):Void
	{
		// If the collision represents a unique value, add it to the collection
		if (!exists(wordKey))
		{
			__wordMap.set(__collisions.push(wordKey) - 1, positions);
		}
	}

	public function exists(wordKey:String):Bool
	{
		if (__collisions.length == 0)
		{
			return false;
		}
		return __collisions.indexOf(wordKey) > -1;
	}
}
