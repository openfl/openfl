package openfl.utils;


@:forward() abstract Object(ObjectType) from ObjectType {
	
	
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
	
	
	@:noCompletion @:dox(hide) public function iterator ():Iterator<String> {
		
		var fields = Reflect.fields (this);
		if (fields == null) fields = [];
		return fields.iterator ();
		
	}
	
	
	public inline function propertyIsEnumerable (name:String):Bool {
		
		return (this != null && Reflect.hasField (this, name) && Std.is (Reflect.field (this, name), Iterable_));
		
	}
	
	
	public inline function toLocaleString ():String {
		
		return Std.string (this);
		
	}
	
	
	@:to public inline function toString ():String {
		
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


#if (!cs || haxe_ver > "3.3.0")

@:keep @:native('haxe.lang.Iterator') private interface Iterator_<T> {
	
	public function hasNext ():Bool;
	public function next ():T;
	
}


@:keep @:native('haxe.lang.Iterable') private interface Iterable_<T> {
	
	public function iterator ():Iterator_<T>;
	
}

#else
typedef Iterator_<T> = cs.internal.Iterator<T>;
typedef Iterable_<T> = cs.internal.Iterator.Iterable<T>;
#end


#if !flash
typedef ObjectType = Dynamic;
#else
typedef ObjectType = flash.utils.Object;
#end