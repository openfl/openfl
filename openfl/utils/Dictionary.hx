package openfl.utils; #if !flash


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
	
	
	@:arrayAccess public inline function get (key:K):V {
		
		return this.get (key);
		
	}
	
	
	@:arrayAccess public inline function set (key:K, value:V):V {
		
		this.set (key, value);
		return value;
		
	}
	
	
	public inline function iterator ():Iterator<K> {
		
		return this.keys ();
		
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
	
	
	@:from static inline function fromStringMap<V> (map:StringMap<V>):Map<String, V> {
		
		return cast map;
		
	}
	
	
	@:from static inline function fromIntMap<V> (map:IntMap<V>):Map<Int, V> {
		
		return cast map;
		
	}
	
	
	@:from static inline function fromObjectMap<K:{}, V> (map:ObjectMap<K, V>):Map<K, V> {
		
		return cast map;
		
	}
	
	
}


#else


abstract Dictionary <K, V> (flash.utils.Dictionary) from flash.utils.Dictionary to flash.utils.Dictionary {
	
	
	public function new (weakKeys:Bool = false) {
		
		this = new flash.utils.Dictionary (weakKeys);
		
	}
	
	
	@:arrayAccess public inline function get (key:K):V {
		
		return untyped this[key];
		
	}
	
	
	@:arrayAccess public inline function set (key:K, value:V):V {
		
		return untyped this[key] = value;
		
	}
	
	
	public inline function iterator ():Iterator<K> {
		
		return untyped __keys__ (this).iterator ();
		
	}
	
	
}


#end