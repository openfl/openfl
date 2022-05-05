package openfl.utils;

import haxe.Constraints.Function;
import openfl.display.DisplayObjectContainer;

@:transitive
@:callable
#if !haxe4
@:forward
#end
abstract Object(ObjectType) from ObjectType from Dynamic to Dynamic
{
	public inline function new()
	{
		this = {};
	}

	public inline function hasOwnProperty(name:String):Bool
	{
		return (this != null && Reflect.hasField(this, name));
	}

	public function isPrototypeOf(theClass:Class<Dynamic>):Bool
	{
		if (this != null)
		{
			var c = Type.getClass(this);

			while (c != null)
			{
				if (c == theClass) return true;
				c = Type.getSuperClass(c);
			}
		}

		return false;
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:noCompletion @:dox(hide) public function iterator():Iterator<String>
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Array))
		{
			var arr:Array<Dynamic> = cast this;
			return arr.iterator();
		}
		else
		{
			var fields = Reflect.fields(this);
			if (fields == null) fields = [];
			if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, DisplayObjectContainer))
			{
				var container:DisplayObjectContainer = cast this;
				for (i in 0...container.numChildren)
				{
					var child = container.getChildAt(i);
					var name = child.name;
					if (name != null && fields.indexOf(name) == -1)
					{
						fields.push(name);
					}
				}
			}
			return fields.iterator();
		}
	}

	public inline function propertyIsEnumerable(name:String):Bool
	{
		return (this != null
			&& Reflect.hasField(this, name)
			&& #if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (Reflect.field(this, name), Iterable_));
	}

	public inline function toLocaleString():String
	{
		return (this == null ? null : Std.string(this));
	}

	@:to public inline function toString():String
	{
		return (this == null ? null : Std.string(this));
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
	private inline function __fieldWrite(name:String, value:Object):Object
	{
		return __set(name, value);
	}
	#end

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:arrayAccess @:noCompletion @:dox(hide) public /*inline*/ function __get(key:String):Object
	{
		if (this == null || key == null) return null;

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
	@:arrayAccess @:noCompletion @:dox(hide) public inline function __set(key:String, value:Object):Object
	{
		if (this != null)
		{
			Reflect.setProperty(this, key, value);
		}

		return value;
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:arrayAccess @:noCompletion @:dox(hide) public function __getArray(index:Int):Object
	{
		if (this == null) return null;
		var arr = cast(this, Array<Dynamic>);
		return arr[index];
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:arrayAccess @:noCompletion @:dox(hide) public function __setArray(index:Int, value:Object):Object
	{
		if (this == null) return value;
		var arr = cast(this, Array<Dynamic>);
		return arr[index] = value;
	}

	@:to private function toFunction():Function
	{
		return cast this;
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

	@:to private function toInt():Int
	{
		return cast this;
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

	#if haxe4
	@:op(-A) private inline function __negate():Dynamic
	{
		var float:Float = cast this;
		return -float;
	}

	@:op(++A) private inline function __preIncrement():Dynamic
	{
		var float:Float = cast this;
		return ++float;
	}

	@:op(A++) private inline function __postIncrement():Dynamic
	{
		var float:Float = cast this;
		return float++;
	}

	@:op(--A) private inline function __preDecrement():Dynamic
	{
		var float:Float = cast this;
		return --float;
	}

	@:op(A--) private inline function __postDecrement():Dynamic
	{
		var float:Float = cast this;
		return float--;
	}

	@:op(A + B) private static inline function __add(a:Object, b:Object):Dynamic
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (a, String)
			|| #if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (b, String))
		{
			return Std.string(a) + Std.string(b);
		}
		else
		{
			var floatA:Float = cast a;
			var floatB:Float = cast b;
			return floatA + floatB;
		}
	}

	@:op(A + B) @:commutative private static inline function __addString(a:Object, b:String):String
	{
		var stringA:String = Std.string(a);
		return stringA + b;
	}

	@:op(A + B) @:commutative private static inline function __addInt(a:Object, b:Int):Dynamic
	{
		var floatA:Float = cast a;
		return floatA + b;
	}

	@:op(A + B) @:commutative private static function __addFloat(a:Object, b:Float):Float
	{
		var floatA:Float = cast a;
		return floatA + b;
	}

	@:op(A - B) private static inline function __sub(a:Object, b:Object):Dynamic
	{
		var floatA:Float = cast a;
		var floatB:Float = cast b;
		return floatA - floatB;
	}

	@:op(A - B) private static inline function __subInt(a:Object, b:Int):Dynamic
	{
		var floatA:Float = cast a;
		return floatA - b;
	}

	@:op(A - B) private static inline function __intSub(a:Int, b:Object):Dynamic
	{
		var floatB:Float = cast b;
		return a - floatB;
	}

	@:op(A - B) private static function __subFloat(a:Object, b:Float):Float
	{
		var floatA:Float = cast a;
		return floatA - b;
	}

	@:op(A - B) private static function __floatSub(a:Float, b:Object):Float
	{
		var floatB:Float = cast b;
		return a - floatB;
	}

	@:op(A * B) private static function __mul(a:Object, b:Object):Dynamic
	{
		var floatA:Float = cast a;
		var floatB:Float = cast b;
		return floatA * floatB;
	}

	@:op(A * B) @:commutative private static inline function __mulInt(a:Object, b:Int):Dynamic
	{
		var floatA:Float = cast a;
		return floatA * b;
	}

	@:op(A * B) @:commutative private static function __mulFloat(a:Object, b:Float):Float
	{
		var floatA:Float = cast a;
		return floatA * b;
	}

	@:op(A / B) private static function __div(a:Object, b:Object):Float
	{
		var floatA:Float = cast a;
		var floatB:Float = cast b;
		return floatA / floatB;
	}

	@:op(A / B) private static function __divInt(a:Object, b:Int):Float
	{
		var floatA:Float = cast a;
		return floatA / b;
	}

	@:op(A / B) private static function __intDiv(a:Int, b:Object):Float
	{
		var floatB:Float = cast b;
		return a / floatB;
	}

	@:op(A / B) private static function __divFloat(a:Object, b:Float):Float
	{
		var floatA:Float = cast a;
		return floatA / b;
	}

	@:op(A / B) private static function __floatDiv(a:Float, b:Object):Float
	{
		var floatB:Float = cast b;
		return a / floatB;
	}

	@:op(A % B) private static function __mod(a:Object, b:Object):Float
	{
		var floatA:Float = cast a;
		var floatB:Float = cast b;
		return floatA % floatB;
	}

	@:op(A % B) private static function __modInt(a:Object, b:Int):Float
	{
		var floatA:Float = cast a;
		return floatA % b;
	}

	@:op(A % B) private static function __intMod(a:Int, b:Object):Float
	{
		var floatB:Float = cast b;
		return a % floatB;
	}

	@:op(A % B) private static function __modFloat(a:Object, b:Float):Float
	{
		var floatA:Float = cast a;
		return floatA % b;
	}

	@:op(A % B) private static function __floatMod(a:Float, b:Object):Float
	{
		var floatB:Float = cast b;
		return a % floatB;
	}

	@:op(A == B) private static function __eq(a:Object, b:Object):Bool
	{
		var dynamicA:Dynamic = a;
		var dynamicB:Dynamic = b;
		return dynamicA == dynamicB;
	}

	@:op(A == B) @:commutative private static function __eqDynamic(a:Object, b:Dynamic):Bool
	{
		var dynamicA:Dynamic = a;
		return dynamicA == b;
	}

	@:op(A != B) private static function __neq(a:Object, b:Object):Bool
	{
		var dynamicA:Dynamic = a;
		var dynamicB:Dynamic = b;
		return dynamicA != dynamicB;
	}

	@:op(A != B) @:commutative private static function __neqDynamic(a:Object, b:Dynamic):Bool
	{
		var dynamicA:Dynamic = a;
		return dynamicA != b;
	}

	@:op(A < B) private static function __lt(a:Object, b:Object):Bool
	{
		var floatA:Float = cast a;
		var floatB:Float = cast b;
		return floatA < floatB;
	}

	@:op(A < B) private static function __ltInt(a:Object, b:Int):Bool
	{
		var floatA:Float = cast a;
		return floatA < b;
	}

	@:op(A < B) private static function __intLt(a:Int, b:Object):Bool
	{
		var floatB:Float = cast b;
		return a < floatB;
	}

	@:op(A < B) private static function __ltFloat(a:Object, b:Float):Bool
	{
		var floatA:Float = cast a;
		return floatA < b;
	}

	@:op(A < B) private static function __floatLt(a:Float, b:Object):Bool
	{
		var floatB:Float = cast b;
		return a < floatB;
	}

	@:op(A <= B) private static function __lte(a:Object, b:Object):Bool
	{
		var floatA:Float = cast a;
		var floatB:Float = cast b;
		return floatA <= floatB;
	}

	@:op(A <= B) private static function __lteInt(a:Object, b:Int):Bool
	{
		var floatB:Float = cast b;
		return a <= floatB;
	}

	@:op(A <= B) private static function __intLte(a:Int, b:Object):Bool
	{
		var floatA:Float = cast a;
		return floatA <= b;
	}

	@:op(A <= B) private static function __lteFloat(a:Object, b:Float):Bool
	{
		var floatB:Float = cast b;
		return a <= floatB;
	}

	@:op(A <= B) private static function __floatLte(a:Float, b:Object):Bool
	{
		var floatA:Float = cast a;
		return floatA <= b;
	}

	@:op(A > B) private static function __gt(a:Object, b:Object):Bool
	{
		var floatA:Float = cast a;
		var floatB:Float = cast b;
		return floatA > floatB;
	}

	@:op(A > B) private static function __gtInt(a:Object, b:Int):Bool
	{
		var floatB:Float = cast b;
		return a > floatB;
	}

	@:op(A > B) private static function __intGt(a:Int, b:Object):Bool
	{
		var floatB:Float = cast b;
		return a > floatB;
	}

	@:op(A > B) private static function __gtFloat(a:Object, b:Float):Bool
	{
		var floatB:Float = cast b;
		return a > floatB;
	}

	@:op(A > B) private static function __floatGt(a:Float, b:Object):Bool
	{
		var floatB:Float = cast b;
		return a > floatB;
	}

	@:op(A >= B) private static function __gte(a:Object, b:Object):Bool
	{
		var floatA:Float = cast a;
		var floatB:Float = cast b;
		return floatA >= floatB;
	}

	@:op(A >= B) private static function __gteInt(a:Object, b:Int):Bool
	{
		var floatB:Float = cast b;
		return a >= floatB;
	}

	@:op(A >= B) private static function __intGte(a:Int, b:Object):Bool
	{
		var floatB:Float = cast b;
		return a >= floatB;
	}

	@:op(A >= B) private static function __gteFloat(a:Object, b:Float):Bool
	{
		var floatB:Float = cast b;
		return a >= floatB;
	}

	@:op(A >= B) private static function __floatGte(a:Float, b:Object):Bool
	{
		var floatB:Float = cast b;
		return a >= floatB;
	}

	@:op(~A) private function __complement():Int
	{
		var int:Int = this;
		return ~int;
	}

	@:op(A & B) private static function __and(a:Object, b:Object):Int
	{
		var intA:Int = cast a;
		var intB:Int = cast b;
		return intA & intB;
	}

	@:op(A & B) @:commutative private static function __andInt(a:Object, b:Int):Int
	{
		var intA:Int = cast a;
		return intA & b;
	}

	@:op(A | B) private static function __or(a:Object, b:Object):Int
	{
		var intA:Int = cast a;
		var intB:Int = cast b;
		return intA | intB;
	}

	@:op(A | B) @:commutative private static function __orInt(a:Object, b:Int):Int
	{
		var intA:Int = cast a;
		return intA | b;
	}

	@:op(A ^ B) private static function __xor(a:Object, b:Object):Int
	{
		var intA:Int = cast a;
		var intB:Int = cast b;
		return intA ^ intB;
	}

	@:op(A ^ B) @:commutative private static function __xorInt(a:Object, b:Int):Int
	{
		var intA:Int = cast a;
		return intA ^ b;
	}

	@:op(A >> B) private static function __shr(a:Object, b:Object):Int
	{
		var intA:Int = cast a;
		var intB:Int = cast b;
		return intA >> intB;
	}

	@:op(A >> B) private static function __shrInt(a:Object, b:Int):Int
	{
		var intA:Int = cast a;
		return intA >> b;
	}

	@:op(A >> B) private static function __intShr(a:Int, b:Object):Int
	{
		var intB:Int = cast b;
		return a >> intB;
	}

	@:op(A >>> B) private static function __ushr(a:Object, b:Object):Int
	{
		var intA:Int = cast a;
		var intB:Int = cast b;
		return intA >>> intB;
	}

	@:op(A >>> B) private static function __ushrInt(a:Object, b:Int):Int
	{
		var intA:Int = cast a;
		return intA >>> b;
	}

	@:op(A >>> B) private static function __intUshr(a:Int, b:Object):Int
	{
		var intB:Int = cast b;
		return a >>> intB;
	}

	@:op(A << B) private static function __shl(a:Object, b:Object):Int
	{
		var intA:Int = cast a;
		var intB:Int = cast b;
		return intA << intB;
	}

	@:op(A << B) private static function __shlInt(a:Object, b:Int):Int
	{
		var intA:Int = cast a;
		return intA << b;
	}

	@:op(A << B) private static function __intShl(a:Int, b:Object):Int
	{
		var intB:Int = cast b;
		return a << intB;
	}
	#end
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
