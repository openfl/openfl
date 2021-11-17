package openfl.utils;
#if cpp
import haxe.ds.WeakMap;
#elseif js
typedef JSWeakRef = js.lib.WeakRef;
#end
/**
 * ...
 * @author Christopher Speciale
 */
class WeakRef
{
	#if cpp
	private var weakMap: WeakMap<Dynamic, Int>; 
	#elseif js
	private var weakRef: JSWeakRef;
	#end
	public var object(get, set):Dynamic;
	
	private function set_object(value:Dynamic):Dynamic{
		#if cpp
		weakMap.set(value, 0);
		#elseif js
		weakRef = new JSWeakRef(value);
		#end
		return value;
	}
	
	private function get_object():Dynamic{
		#if cpp
		var iterator = weakMap.keys();
		if (iterator.hasNext()) return iterator.next();		
		return null;
		#elseif js
		return weakRef.deref();
		#end
	}

	public function new(?object:Dynamic)
	{
		#if cpp
		weakMap = new WeakMap();
		if (object != null) weakMap.set(object, 0);	
		#elseif js
		if (object != null) weakRef = new JSWeakRef(object);
		#end
	}

}
