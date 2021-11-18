package openfl.utils;

import openfl.display.DisplayObjectContainer;

@:forward() abstract Object(ObjectType) from ObjectType from Dynamic to Dynamic
{
	public inline function new()
	{
		this = {};
	}

	public inline function hasOwnProperty(name:String):Bool
	{
		return (this != null && Reflect.hasField(this, name));
	}

	public inline function isPrototypeOf(theClass:Class<Dynamic>):Bool
	{
		var c = Type.getClass(this);

		while (c != null)
		{
			if (c == theClass) return true;
			c = Type.getSuperClass(c);
		}

		return false;
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:noCompletion @:dox(hide) public function iterator():Iterator<String>
	{
		var fields = Reflect.fields(this);
		if (fields == null) fields = [];
		return fields.iterator();
	}

	public inline function propertyIsEnumerable(name:String):Bool
	{
		return (this != null
			&& Reflect.hasField(this, name)
			&& #if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (Reflect.field(this, name), Iterable_));
	}

	public inline function toLocaleString():String
	{
		return Std.string(this);
	}

	@:to private function toFloat():Float
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Float))
		{
			return cast this;
		}
		else
		{
			return Math.NaN;
		}
	}

	@:to private function toBool():Bool
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Bool))
		{
			return cast this;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Float))
		{
			return this != 0;
		}
		else
		{
			return this != null;
		}
	}

	@:to public inline function toString():String
	{
		return Std.string(this);
	}

	public inline function valueOf():Object
	{
		return this;
	}

	@:op(a.b)
	private inline function __fieldRead(name:String):Object
	{
		return __get(name);
	}

	#if haxe4
	@:op(a.b)
	private inline function __fieldWrite(name:String, value:Dynamic):Object
	{
		return __set(name, value);
	}
	#end

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:arrayAccess @:noCompletion @:dox(hide) public /*inline*/ function __get(key:String):Object
	{
		if (Reflect.hasField(this, key))
		{
			return Reflect.field(this, key);
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, DisplayObjectContainer))
		{
			var container:DisplayObjectContainer = cast this;
			var child = container.getChildByName(key);
			if (child != null) return child;
		}
		return Reflect.getProperty(this, key);
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:arrayAccess @:noCompletion @:dox(hide) public inline function __set(key:String, value:Dynamic):Dynamic
	{
		Reflect.setProperty(this, key, value);
		return value;
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:arrayAccess @:noCompletion @:dox(hide) public inline function __getArray(index:Int):Dynamic
	{
		var arr = cast(this, Array<Dynamic>);
		return arr[index];
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:arrayAccess @:noCompletion @:dox(hide) public inline function __setArray(index:Int, value:Dynamic):Dynamic
	{
		var arr = cast(this, Array<Dynamic>);
		return arr[index] = value;
	}
}

#if (!cs || haxe_ver > "3.3.0")
@SuppressWarnings("checkstyle:FieldDocComment")
@:keep @:native("haxe.lang.Iterator") private interface Iterator_<T>
{
	public function hasNext():Bool;
	public function next():T;
}

@SuppressWarnings("checkstyle:FieldDocComment")
@:keep @:native("haxe.lang.Iterable") private interface Iterable_<T>
{
	public function iterator():Iterator_<T>;
}
#else
typedef Iterator_<T> = cs.internal.Iterator<T>;
typedef Iterable_<T> = cs.internal.Iterator.Iterable<T>;
#end
#if !flash
@:dox(hide) @:noCompletion typedef ObjectType = Dynamic;
#else
@:dox(hide) typedef ObjectType = flash.utils.Object;
#end
