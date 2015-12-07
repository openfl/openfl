package openfl.utils; #if (!flash || display)


@:forward() abstract Object(Dynamic) from Dynamic to Dynamic {
	
	
	public inline function new () {
		
		this = { };
		
	}
	
	
	public inline function hasOwnProperty (name:String):Bool {
		
		return (this != null && Reflect.hasField (this, name));
		
	}
	
	
	public inline function isPrototypeOf (theClass:Class<Dynamic>):Bool {
		
		var c = Type.getClass (this);
		
		while (c != null) {
			
			if (c == theClass) return true;
			c = Type.getSuperClass (c);
			
		}
		
		return false;
		
	}
	
	
	public inline function propertyIsEnumerable (name:String):Bool {
		
		return (this != null && Reflect.hasField (this, name) && Std.is (Reflect.field (this, name), Iterable));
		
	}
	
	
	public inline function toLocaleString ():String {
		
		return Std.string (this);
		
	}
	
	
	public inline function toString ():String {
		
		return Std.string (this);
		
	}
	
	
	public inline function valueOf ():Object {
		
		return this;
		
	}
	
	
	@:arrayAccess @:noCompletion @:dox(hide) public inline function __get (key:String):Dynamic {
		
		return Reflect.field (this, key);
		
	}
	
	
	@:arrayAccess @:noCompletion @:dox(hide) public inline function __set (key:String, value:Dynamic):Dynamic {
		
		Reflect.setField (this, key, value);
		return value;
		
	}
	
	
}


@:keep @:native('haxe.lang.Iterator') private interface Iterator<T> {
	
	public function hasNext ():Bool;
	public function next ():T;
	
}


@:keep @:native('haxe.lang.Iterable') private interface Iterable<T> {
	
	public function iterator ():Iterator<T>;
	
}


#else
typedef Object = flash.utils.Object;
#end