package openfl.utils;

#if (!flash || display)
#if (!openfljs || !js)
import haxe.ds.StringMap;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import haxe.ds.EnumValueMap;
import haxe.Constraints.IMap;

/**
	The Dictionary class lets you create a dynamic collection of properties,
	which uses strict equality (`===`) for key comparison. When an object is
	used as a key, the object's identity is used to look up the object, and
	not the value returned from calling `toString()` on it.
	The following statements show the relationship between a Dictionary object
	and a key object:

	```as3
	var dict = new Dictionary();
	var obj = new Object();
	var key:Object = new Object();
	key.toString = function() { return "key" }

	dict[key] = "Letters";
	obj["key"] = "Letters";

	dict[key] == "Letters"; // true
	obj["key"] == "Letters"; // true
	obj[key] == "Letters"; // true because key == "key" is true b/c key.toString == "key"
	dict["key"] == "Letters"; // false because "key" === key is false
	delete dict[key]; //removes the key
	```
**/
@:multiType(K)
abstract Dictionary<K, V>(IMap<K, V>)
{
	/**
		Creates a new Dictionary object. To remove a key from a Dictionary
		object, use the `delete` operator.

		@param weakKeys Instructs the Dictionary object to use "weak"
						references on object keys. If the only reference to an
						object is in the specified Dictionary object, the key
						is eligible for garbage collection and is removed from
						the table when the object is collected.
	**/
	public function new(weakKeys:Bool = false);

	/**
		Returns `true` if `key` has a mapping, `false` otherwise.

		If key is `null`, the result is unspecified.
	**/
	public inline function exists(key:K):Bool
	{
		return this.exists(key);
	}

	/**
		Returns the current mapping of `key`.

		If no such mapping exists, `null` is returned.

		Note that a check like `dict.get(key) == null` can hold for two reasons:

		1. The Dictionary has no mapping for `key`
		2. The Dictionary has a mapping with a value of `null`

		If it is important to distinguish these cases, `exists()` should be used.

		If `key` is null, the result is unspecified.
	**/
	@:arrayAccess public inline function get(key:K):V
	{
		return this.get(key);
	}

	#if (haxe_ver >= "4.0.0")
	/**
		Returns an Iterator over the keys and values of this Dictionary.

		The order of values is undefined.
	**/
	public inline function keyValueIterator():KeyValueIterator<K, V>
	{
		return this.keyValueIterator();
	}
	#end

	/**
		Removes the mapping of `key` and returns `true` if such a mapping existed, `false` otherwise.

		If `key` is `null`, the result is unspecified.
	**/
	public inline function remove(key:K):Bool
	{
		return this.remove(key);
	}

	/**
		Maps `key` to `value`.

		If `key` already has a mapping, the previous value disappears.

		If `key` is `null`, the result is unspecified.
	**/
	@:arrayAccess public inline function set(key:K, value:V):V
	{
		this.set(key, value);
		return value;
	}

	/**
		Returns an Iterator over the keys of this Dictionary.

		The order of values is undefined.
	**/
	public inline function iterator():Iterator<K>
	{
		return this.keys();
	}

	/**
		Returns an Iterator over each of the values of this Dictionary.

		The order of values is undefined.
	**/
	public inline function each():Iterator<V>
	{
		return this.iterator();
	}

	@:to private static function toStringMap<K:String, V>(t:IMap<K, V>, weakKeys:Bool):StringMap<V>
	{
		return new StringMap<V>();
	}

	@:to private static function toIntMap<K:Int, V>(t:IMap<K, V>, weakKeys:Bool):IntMap<V>
	{
		return new IntMap<V>();
	}

	@:to private static function toFloatMap<K:Float, V>(t:IMap<K, V>, weakKeys:Bool):FloatMap<K, V>
	{
		return new FloatMap<K, V>();
	}

	@:to private static function toEnumValueMapMap<K:EnumValue, V>(t:IMap<K, V>, weakKeys:Bool):EnumValueMap<K, V>
	{
		return new EnumValueMap<K, V>();
	}

	@:to private static function toObjectMap<K:{}, V>(t:IMap<K, V>, weakKeys:Bool):ObjectMap<K, V>
	{
		return new ObjectMap<K, V>();
	}

	@:to private static function toUtilsObjectMap<K:Object, V>(t:IMap<K, V>, weakKeys:Bool):UtilsObjectMap<K, V>
	{
		return new UtilsObjectMap<K, V>();
	}

	@:to private static function toClassMap<K:Class<Dynamic>, V>(t:IMap<K, V>, weakKeys:Bool):ClassMap<K, V>
	{
		return new ClassMap<K, V>();
	}

	@:from private static inline function fromStringMap<V>(map:StringMap<V>):Dictionary<String, V>
	{
		return cast map;
	}

	@:from private static inline function fromIntMap<V>(map:IntMap<V>):Dictionary<Int, V>
	{
		return cast map;
	}

	@:from private static inline function fromFloatMap<K:Float, V>(map:FloatMap<K, V>):Dictionary<K, V>
	{
		return cast map;
	}

	@:from private static inline function fromObjectMap<K:{}, V>(map:ObjectMap<K, V>):Dictionary<K, V>
	{
		return cast map;
	}

	@:from private static inline function fromUtilsObjectMap<K:Object, V>(map:UtilsObjectMap<K, V>):Dictionary<K, V>
	{
		return cast map;
	}

	@:from private static inline function fromClassMap<K:Class<Dynamic>, V>(map:ClassMap<K, V>):Dictionary<K, V>
	{
		return cast map;
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:dox(hide) private class ClassMap<K:Class<Dynamic>, V> implements IMap<K, V>
{
	@:noCompletion private var types:Map<String, K>;
	@:noCompletion private var values:Map<String, V>;

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

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:dox(hide) private class FloatMap<K:Float, V> implements IMap<K, V>
{
	@:noCompletion private var floatKeys:Array<K>;
	@:noCompletion private var values:Array<V>;

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
	@:noCompletion private function indexOf(key:K):Int
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
	@:noCompletion private function insertSorted(key:K, value:V):Void
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

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:dox(hide) private class UtilsObjectMap<K:Object, V> implements IMap<K, V>
{
	@:noCompletion private var map:ObjectMap<{}, V>;

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
#else
@SuppressWarnings("checkstyle:FieldDocComment")
abstract Dictionary<K, V>(Dynamic)
{
	public function new(weakKeys:Bool = false)
	{
		this = {};
	}

	public inline function exists(key:K):Bool
	{
		return Reflect.hasField(this, cast key);
	}

	@:arrayAccess public inline function get(key:K):V
	{
		return Reflect.field(this, cast key);
	}

	#if haxe4
	@:runtime public inline function keyValueIterator():KeyValueIterator<K, V>
	{
		return new haxe.iterators.MapKeyValueIterator(this);
	}
	#end

	public inline function remove(key:K):Bool
	{
		if (Reflect.hasField(this, cast key))
		{
			Reflect.deleteField(this, cast key);
			return true;
		}

		return false;
	}

	@:arrayAccess public inline function set(key:K, value:V):V
	{
		Reflect.setField(this, cast key, value);
		return value;
	}

	public inline function iterator():Iterator<K>
	{
		var fields = Reflect.fields(this);
		if (fields != null) return cast fields.iterator();
		return null;
	}

	public inline function each():Iterator<V>
	{
		var values = [];

		for (field in Reflect.fields(this))
		{
			values.push(Reflect.field(this, field));
		}

		return values.iterator();
	}
}
#end
#else
@SuppressWarnings("checkstyle:FieldDocComment")
abstract Dictionary<K, V>(flash.utils.Dictionary) from flash.utils.Dictionary to flash.utils.Dictionary
{
	public function new(weakKeys:Bool = false)
	{
		this = new flash.utils.Dictionary(weakKeys);
	}

	public inline function exists(key:K):Bool
	{
		return (untyped this[key] != untyped __global__["undefined"]);
	}

	@:arrayAccess public inline function get(key:K):V
	{
		return untyped this[key];
	}

	#if haxe4
	@:runtime public inline function keyValueIterator():KeyValueIterator<K, V>
	{
		return new haxe.iterators.MapKeyValueIterator(untyped this);
	}
	#end

	public inline function remove(key:K):Bool
	{
		var exists = (this : Dictionary<K, V>).exists(key);
		untyped __delete__(this, key);
		return exists;
	}

	@:arrayAccess public inline function set(key:K, value:V):V
	{
		return untyped this[key] = value;
	}

	public inline function iterator():Iterator<K>
	{
		return untyped __keys__(this).iterator();
	}

	@:analyzer(ignore) public function each():Iterator<V>
	{
		return untyped {
			ref: this,
			it: iterator(),
			hasNext: function()
			{
				return __this__.it.hasNext();
			},
			next: function()
			{
				return get(__this__.it.next());
			}
		}
	}
}
#end
