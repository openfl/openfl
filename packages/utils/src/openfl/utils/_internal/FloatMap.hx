package openfl.utils._internal;

import haxe.Constraints.IMap;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FloatMap<K:Float, V> implements IMap<K, V>
{
	@:noCompletion public var floatKeys:Array<K>;
	@:noCompletion public var values:Array<V>;

	public function new():Void
	{
		floatKeys = new Array<K>();
		values = new Array<V>();
	}

	#if haxe4
	public function clear():Void
	{
		floatKeys = new Array<K>();
		values = new Array<V>();
	}
	#end

	#if haxe4
	public function copy():FloatMap<K, V>
	{
		var copied = new FloatMap<K, V>();
		for (key in keys())
			copied.set(key, get(key));
		return copied;
	}
	#end

	public function exists(key:K):Bool
	{
		return indexOf(key) > -1;
	}

	public function get(key:K):Null<V>
	{
		var ind = indexOf(key);
		return ind > -1 ? values[ind] : null;
	}

	#if haxe4
	@:runtime public inline function keyValueIterator():KeyValueIterator<K, V>
	{
		return new haxe.iterators.MapKeyValueIterator(this);
	}
	#end

	public function keys():Iterator<K>
	{
		return floatKeys.copy().iterator();
	}

	public function iterator():Iterator<V>
	{
		return values.copy().iterator();
	}

	public function remove(key:K):Bool
	{
		var ind = indexOf(key);

		if (ind > -1)
		{
			floatKeys.splice(ind, 1);
			values.splice(ind, 1);
			return true;
		}

		return false;
	}

	public function set(key:K, value:V):Void
	{
		insertSorted(key, value);
	}

	/**
		Binary search through floatKeys array, which is sorted, to find an index of a given key. If the array
		doesn't contain such key -1 is returned.
	**/
	@:noCompletion public function indexOf(key:K):Int
	{
		var len:Int = floatKeys.length;
		var startIndex:Int = 0;
		var endIndex:Int = len - 1;

		if (len == 0)
		{
			return -1;
		}

		var midIndex:Int = 0;

		while (startIndex < endIndex)
		{
			midIndex = Math.floor((startIndex + endIndex) / 2);

			if (floatKeys[midIndex] == key)
			{
				return midIndex;
			}
			else if (floatKeys[midIndex] > key)
			{
				endIndex = midIndex - 1;
			}
			else
			{
				startIndex = midIndex + 1;
			}
		}

		if (floatKeys[startIndex] == key)
		{
			return startIndex;
		}
		else
		{
			return -1;
		}
	}

	/**
		Insert the key at a proper index in the array and return the index. The array must will remain sorted.
				  The keys are unique so if the key already existis in the array it isn't added but it's index is returned.
	**/
	@:noCompletion public function insertSorted(key:K, value:V):Void
	{
		var len:Int = floatKeys.length;
		var startIndex:Int = 0;
		var endIndex:Int = len - 1;

		if (len == 0)
		{
			floatKeys.push(key);
			values.push(value);
			return;
		}

		var midIndex:Int = 0;
		while (startIndex < endIndex)
		{
			midIndex = Math.floor((startIndex + endIndex) / 2);

			if (floatKeys[midIndex] == key)
			{
				values[midIndex] = value;
				return;
			}
			else if (floatKeys[midIndex] > key)
			{
				endIndex = midIndex - 1;
			}
			else
			{
				startIndex = midIndex + 1;
			}
		}

		if (floatKeys[startIndex] > key)
		{
			floatKeys.insert(startIndex, key);
			values.insert(startIndex, value);
		}
		else if (floatKeys[startIndex] < key)
		{
			floatKeys.insert(startIndex + 1, key);
			values.insert(startIndex + 1, value);
		}
		else
		{
			values[startIndex] = value;
		}
	}

	public function toString():String
	{
		return values.toString();
	}
}
