package openfl.utils._internal;

import haxe.ds.ObjectMap;
import haxe.Constraints.IMap;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class UtilsObjectMap<K:Object, V> implements IMap<K, V>
{
	@:noCompletion public var map:ObjectMap<{}, V>;

	public function new():Void
	{
		map = new ObjectMap<{}, V>();
	}

	#if haxe4
	public function clear():Void
	{
		map.clear();
	}
	#end

	#if haxe4
	public function copy():UtilsObjectMap<K, V>
	{
		var copied = new UtilsObjectMap<K, V>();
		for (key in keys())
			copied.set(key, get(key));
		return copied;
	}
	#end

	public function exists(key:K):Bool
	{
		return map.exists(cast key);
	}

	public function get(key:K):Null<V>
	{
		return map.get(cast key);
	}

	#if haxe4
	@:runtime public inline function keyValueIterator():KeyValueIterator<K, V>
	{
		return new haxe.iterators.MapKeyValueIterator(this);
	}
	#end

	public function keys():Iterator<K>
	{
		return cast map.keys();
	}

	public function iterator():Iterator<V>
	{
		return cast map.iterator();
	}

	public function remove(key:K):Bool
	{
		return map.remove(cast key);
	}

	public function set(key:K, value:V):Void
	{
		map.set(cast key, value);
	}

	public function toString():String
	{
		return map.toString();
	}
}
