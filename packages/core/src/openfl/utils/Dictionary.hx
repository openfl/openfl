package openfl.utils;

#if (!flash || display)
import haxe.ds.StringMap;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import haxe.ds.EnumValueMap;
import haxe.Constraints.IMap;
import openfl.utils._internal.ClassMap;
import openfl.utils._internal.FloatMap;
import openfl.utils._internal.UtilsObjectMap;

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
