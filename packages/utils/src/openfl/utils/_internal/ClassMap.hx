package openfl.utils._internal;

import haxe.Constraints.IMap;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ClassMap<K:Class<Dynamic>, V> implements IMap<K, V>
{
	@:noCompletion public var types:Map<String, K>;
	@:noCompletion public var values:Map<String, V>;

	public function new():Void
	{
		types = new Map();
		values = new Map();
	}

	#if haxe4
	public function clear():Void
	{
		types.clear();
		values.clear();
	}
	#end

	#if haxe4
	public function copy():ClassMap<K, V>
	{
		var copied = new ClassMap<K, V>();
		for (key in keys())
			copied.set(key, get(key));
		return copied;
	}
	#end

	public function exists(key:K):Bool
	{
		return types.exists(Type.getClassName(key));
	}

	public function get(key:K):Null<V>
	{
		return values.get(Type.getClassName(key));
	}

	#if haxe4
	@:runtime public inline function keyValueIterator():KeyValueIterator<K, V>
	{
		return new haxe.iterators.MapKeyValueIterator(this);
	}
	#end

	public function keys():Iterator<K>
	{
		return types.iterator();
	}

	public function iterator():Iterator<V>
	{
		return values.iterator();
	}

	public function remove(key:K):Bool
	{
		var name = Type.getClassName(key);
		return (types.remove(name) || values.remove(name));
	}

	public function set(key:K, value:V):Void
	{
		var name = Type.getClassName(key);

		types.set(name, key);
		values.set(name, value);
	}

	public function toString():String
	{
		return values.toString();
	}
}
