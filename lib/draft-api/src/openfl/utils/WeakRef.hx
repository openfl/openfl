package openfl.utils;

#if cpp
import haxe.ds.WeakMap;
#elseif js
typedef JSWeakRef = js.lib.WeakRef<Dynamic>;
#end

abstract WeakRef(#if cpp WeakMap<Dynamic, Int> #elseif js JSWeakRef #end)
{
	public var object(get, set):Dynamic;

	inline function set_object(value:Dynamic):Dynamic
	{
		#if cpp
		this.set(value, 0);
		#elseif js
		this = new JSWeakRef(value);
		#end
		return value;
	}

	inline function get_object():Dynamic
	{
		#if cpp
		var iterator = this.keys();
		if (iterator.hasNext()) return iterator.next();
		return null;
		#elseif js
		return this.deref();
		#end
	}

	inline public function new(?object:Dynamic)
	{
		#if cpp
		this = new WeakMap();
		if (object != null) this.set(object, 0);
		#elseif js
		this = new JSWeakRef(object);
		#end
	}
}
