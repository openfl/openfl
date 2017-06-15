package openfl.utils; #if (!flash || display)


import haxe.ds.StringMap;
import haxe.ds.IntMap;
import haxe.ds.HashMap;
import haxe.ds.ObjectMap;
import haxe.ds.WeakMap;
import haxe.ds.EnumValueMap;
import haxe.Constraints.IMap;

@:multiType(K)


abstract Dictionary<K, V> (IMap<K, V>) {
	
	
	public function new (weakKeys:Bool = false);
	
	
	public inline function exists (key:K):Bool {
		
		return this.exists (key);
		
	}
	
	
	@:arrayAccess public inline function get (key:K):V {
		
		return this.get (key);
		
	}
	
	
	public inline function remove (key:K):Bool {
		
		return this.remove (key);
		
	}
	
	
	@:arrayAccess public inline function set (key:K, value:V):V {
		
		this.set (key, value);
		return value;
		
	}
	
	
	public inline function iterator ():Iterator<K> {
		
		return this.keys ();
		
	}
	
	
	public inline function each ():Iterator<V> {
		
		return this.iterator ();
		
	}
	
	
	@:to static function toStringMap<K:String, V> (t:IMap<K, V>, weakKeys:Bool):StringMap<V> {
		
		return new StringMap<V> ();
		
	}
	
	
	@:to static function toIntMap<K:Int, V> (t:IMap<K, V>, weakKeys:Bool):IntMap<V> {
		
		return new IntMap<V> ();
		
	}
	
	
	@:to static function toFloatMap<K:Float,V> (t:IMap<K, V>, weakKeys:Bool):FloatMap<K, V> {
		
		return new FloatMap<K, V> ();
		
	}
	
	
	@:to static function toEnumValueMapMap<K:EnumValue, V> (t:IMap<K, V>, weakKeys:Bool):EnumValueMap<K, V> {
		
		return new EnumValueMap<K, V> ();
		
	}
	
	
	@:to static function toObjectMap<K:{},V> (t:IMap<K, V>, weakKeys:Bool):ObjectMap<K, V> {
		
		return new ObjectMap<K, V> ();
		
	}
	
	
	@:to static function toUtilsObjectMap<K:Object,V> (t:IMap<K, V>, weakKeys:Bool):UtilsObjectMap<K, V> {
		
		return new UtilsObjectMap<K, V> ();
		
	}
	
	
	@:to static function toClassMap<K:Class<Dynamic>,V> (t:IMap<K, V>, weakKeys:Bool):ClassMap<K, V> {
		
		return new ClassMap<K, V> ();
		
	}
	
	
	@:from static inline function fromStringMap<V> (map:StringMap<V>):Dictionary<String, V> {
		
		return cast map;
		
	}
	
	
	@:from static inline function fromIntMap<V> (map:IntMap<V>):Dictionary<Int, V> {
		
		return cast map;
		
	}
	
	
	@:from static inline function fromFloatMap<K:Float, V> (map:FloatMap<K, V>):Dictionary<K, V> {
		
		return cast map;
		
	}
	
	
	@:from static inline function fromObjectMap<K:{}, V> (map:ObjectMap<K, V>):Dictionary<K, V> {
		
		return cast map;
		
	}
	
	
	@:from static inline function fromUtilsObjectMap<K:Object, V> (map:UtilsObjectMap<K, V>):Dictionary<K, V> {
		
		return cast map;
		
	}
	
	
	@:from static inline function fromClassMap<K:Class<Dynamic>, V> (map:ClassMap<K, V>):Dictionary<K, V> {
		
		return cast map;
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:dox(hide) private class ClassMap<K:Class<Dynamic>, V> implements Map.IMap<K, V> {
	
	
	private var types:Map<String, K>;
	private var values:Map<String, V>;
	
	
	public function new ():Void {
		
		types = new Map ();
		values = new Map ();
		
	}
	
	
	#if (haxe_ver >= "4.0.0")
	public function copy ():ClassMap<K, V> {
		
		var copied = new ClassMap<K, V> ();
		for (key in keys ()) copied.set (key, get (key));
		return copied;
		
	}
	#end
	
	
	public function exists (key:K):Bool {
		
		return types.exists (Type.getClassName (key));
		
	}
	
	
	public function get (key:K):Null<V> {
		
		return values.get (Type.getClassName (key));
		
	}
	
	
	public function keys ():Iterator<K> {
		
		return types.iterator ();
		
	}
	
	
	public function iterator ():Iterator<V> {
		
		return values.iterator ();
		
	}
	
	
	public function remove (key:K):Bool {
		
		var name = Type.getClassName (key);
		return (types.remove (name) || values.remove (name));
		
	}
	
	
	public function set (key:K, value:V):Void {
		
		var name = Type.getClassName (key);
		
		types.set (name, key);
		values.set (name, value);
		
	}
	
	
	public function toString ():String {
		
		return values.toString ();
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:dox(hide) private class FloatMap<K:Float, V> implements Map.IMap<K, V> {
	
	
	private var floatKeys:Array<K>;
	private var values:Array<V>;
	
	
	public function new ():Void {
		
		floatKeys = new Array<K> ();
		values = new Array<V> ();
		
	}
	
	
	#if (haxe_ver >= "4.0.0")
	public function copy ():FloatMap<K, V> {
		
		var copied = new FloatMap<K, V> ();
		for (key in keys ()) copied.set (key, get (key));
		return copied;
		
	}
	#end
	
	
	public function exists (key:K):Bool {
		
		return indexOf (key) > -1;
		
	}
	
	
	public function get (key:K):Null<V> {
		
		var ind = indexOf(key);
		return ind > -1 ? values[ind] : null;
		
	}
	
	
	public function keys ():Iterator<K> {
		
		return floatKeys.copy().iterator ();
		
	}
	
	
	public function iterator ():Iterator<V> {
		
		return values.copy().iterator ();
		
	}
	
	
	public function remove (key:K):Bool {
		
		var ind = indexOf (key);
		
		if (ind > -1) {
			
			floatKeys.splice (ind, 1);
			values.splice (ind, 1);
			return true;
			
		}
		
		return false;
		
	}
	
	
	public function set (key:K, value:V): Void {
		
		insertSorted (key, value);
		
	}
	
	
	/**
	* Binary search through floatKeys array, which is sorted, to find an index of a given key. If the array
	* doesn't contain such key -1 is returned.
	*/
	private function indexOf (key:K):Int {
		
		var len:Int = floatKeys.length;
		var startIndex:Int = 0;
		var endIndex:Int = len - 1;
		
		if (len == 0) {
			
			return -1;
			
		}
		
		var midIndex:Int  = 0;
		
		while (startIndex < endIndex) {
			
			midIndex = Math.floor ((startIndex + endIndex) / 2);
			
			if (floatKeys[midIndex] == key) {
				
				return midIndex;
				
			} else if (floatKeys[midIndex] > key) {
				
				endIndex = midIndex - 1;
				
			} else {
				
				startIndex = midIndex + 1;
				
			}
			
		}
		
		if (floatKeys[startIndex] == key) {
			
			return startIndex;
			
		} else {
			
			return -1;
			
		}
		
	}
	

	/**
	*	Insert the key at a proper index in the array and return the index. The array must will remain sorted. 
	*   The keys are unique so if the key already existis in the array it isn't added but it's index is returned.
	*/
	private function insertSorted(key:K, value: V): Void {
		
		var len:Int = floatKeys.length;
		var startIndex:Int = 0;
		var endIndex:Int = len - 1;
		
		if (len == 0) {
			
			floatKeys.push (key);
			values.push(value);
			return;
			
		}
		
		var midIndex:Int = 0;
		while (startIndex < endIndex) {
			
			midIndex = Math.floor ((startIndex + endIndex) / 2);
			
			if (floatKeys[midIndex] == key) {
				
				values[midIndex] = value;
				return;
				
			} else if (floatKeys[midIndex] > key) {
				
				endIndex = midIndex - 1;
				
			} else {
				
				startIndex = midIndex + 1;
				
			}
			
		}
		
		if (floatKeys[startIndex] > key) {
			
			floatKeys.insert (startIndex, key);
			values.insert (startIndex, value);
			
		} else if (floatKeys[startIndex] < key) {
			
			floatKeys.insert (startIndex + 1, key);
			values.insert (startIndex + 1, value);
			
		} else {
			
			values[startIndex] = value;
			
		}
		
	}
	
	
	public function toString ():String {
		
		return values.toString ();
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:dox(hide) private class UtilsObjectMap<K:Object, V> implements Map.IMap<K, V> {
	
	
	private var map:ObjectMap<{}, V>;
	
	
	public function new ():Void {
		
		map = new ObjectMap<{}, V> ();
		
	}
	
	
	#if (haxe_ver >= "4.0.0")
	public function copy ():UtilsObjectMap<K, V> {
		
		var copied = new UtilsObjectMap<K, V> ();
		for (key in keys ()) copied.set (key, get (key));
		return copied;
		
	}
	#end
	
	
	public function exists (key:K):Bool {
		
		return map.exists (cast key);
		
	}
	
	
	public function get (key:K):Null<V> {
		
		return map.get (cast key);
		
	}
	
	
	public function keys ():Iterator<K> {
		
		return cast map.keys ();
		
	}
	
	
	public function iterator ():Iterator<V> {
		
		return cast map.iterator ();
		
	}
	
	
	public function remove (key:K):Bool {
		
		return map.remove (cast key);
		
	}
	
	
	public function set (key:K, value:V):Void {
		
		map.set (cast key, value);
		
	}
	
	
	public function toString ():String {
		
		return map.toString ();
		
	}
	
	
}


#else


abstract Dictionary <K, V> (flash.utils.Dictionary) from flash.utils.Dictionary to flash.utils.Dictionary {
	
	
	public function new (weakKeys:Bool = false) {
		
		this = new flash.utils.Dictionary (weakKeys);
		
	}
	
	
	public inline function exists (key:K):Bool {
		
		return (untyped this[key] != untyped __global__["undefined"]);
		
	}
	
	
	@:arrayAccess public inline function get (key:K):V {
		
		return untyped this[key];
		
	}
	
	
	public inline function remove (key:K):Bool {
		
		var exists = (this:Dictionary<K, V>).exists (key);
		untyped __delete__ (this, key);
		return exists;
		
	}
	
	
	@:arrayAccess public inline function set (key:K, value:V):V {
		
		return untyped this[key] = value;
		
	}
	
	
	public inline function iterator ():Iterator<K> {
		
		return untyped __keys__ (this).iterator ();
		
	}
	
	
	@:analyzer(ignore) public function each ():Iterator<V> {
		
		return untyped {
			
			ref: this,
			it: iterator (),
			hasNext: function () { return __this__.it.hasNext (); },
			next: function () { return __this__.ref[__this__.it.next ()]; }
			
		}
		
	}
	
	
}


#end