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
	
	
	@:to static inline function toStringMap<K:String, V> (t:IMap<K, V>, weakKeys:Bool):StringMap<V> {
		
		return new StringMap<V> ();
		
	}
	
	
	@:to static inline function toIntMap<K:Int, V> (t:IMap<K, V>, weakKeys:Bool):IntMap<V> {
		
		return new IntMap<V> ();
		
	}
	
	
	@:to static inline function toEnumValueMapMap<K:EnumValue, V> (t:IMap<K, V>, weakKeys:Bool):EnumValueMap<K, V> {
		
		return new EnumValueMap<K, V> ();
		
	}
	
	
	@:to static inline function toObjectMap<K:{},V> (t:IMap<K, V>, weakKeys:Bool):ObjectMap<K, V> {
		
		return new ObjectMap<K, V> ();
		
	}
	
	
	@:to static inline function toUtilsObjectMap<K:Object,V> (t:IMap<K, V>, weakKeys:Bool):UtilsObjectMap<K, V> {
		
		return new UtilsObjectMap<K, V> ();
		
	}
	
	
	@:to static inline function toClassMap<K:Class<Dynamic>,V> (t:IMap<K, V>, weakKeys:Bool):ClassMap<K, V> {
		
		return new ClassMap<K, V> ();
		
	}
	
	
	@:from static inline function fromStringMap<V> (map:StringMap<V>):Dictionary<String, V> {
		
		return cast map;
		
	}
	
	
	@:from static inline function fromIntMap<V> (map:IntMap<V>):Dictionary<Int, V> {
		
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


@:dox(hide) private class UtilsObjectMap<K:Object, V> implements Map.IMap<K, V> {
	
	
	private var map:ObjectMap<{}, V>;
	
	
	public function new ():Void {
		
		map = new ObjectMap<{}, V> ();
		
	}
	
	
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