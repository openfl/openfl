package openfl.utils;

import haxe.Constraints.Function;
import openfl.display.DisplayObjectContainer;

@:transitive
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

	@:to public inline function toString():String
	{
		return Std.string(this);
	}

	public inline function valueOf():Object
	{
		return this;
	}

	@:op(a.b)
	private inline function __fieldRead(name:String):ObjectValue
	{
		return __get(name);
	}

	#if haxe4
	@:op(a.b)
	private inline function __fieldWrite(name:String, value:ObjectValue):ObjectValue
	{
		return __set(name, value);
	}
	#end

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:arrayAccess @:noCompletion @:dox(hide) public inline function __get(key:String):ObjectValue
	{
		var _this:ObjectValue = this;
		return _this[key];
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:arrayAccess @:noCompletion @:dox(hide) public inline function __set(key:String, value:ObjectValue):ObjectValue
	{
		var _this:ObjectValue = this;
		return _this[key] = value;
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:arrayAccess @:noCompletion @:dox(hide) public inline function __getArray(index:Int):ObjectValue
	{
		var arr = cast(this, Array<Dynamic>);
		return arr[index];
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:arrayAccess @:noCompletion @:dox(hide) public inline function __setArray(index:Int, value:ObjectValue):ObjectValue
	{
		var arr = cast(this, Array<Dynamic>);
		return arr[index] = value;
	}
}

@SuppressWarnings("checkstyle:FieldDocComment")
@:transitive
@:callable private abstract ObjectValue(Dynamic) from Dynamic to Dynamic
{
	@:to private function toFunction():Function
	{
		return this;
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

	@:op(a.b)
	@:arrayAccess
	@:noCompletion @:dox(hide) public /*inline*/ function __get(key:String):ObjectValue
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

	@:op(a.b)
	@:arrayAccess
	@:noCompletion @:dox(hide) public inline function __set(key:String, value:ObjectValue):ObjectValue
	{
		Reflect.setProperty(this, key, value);
		return value;
	}

	@:arrayAccess @:noCompletion @:dox(hide) public inline function __getArray(index:Int):ObjectValue
	{
		var arr = cast(this, Array<Dynamic>);
		return arr[index];
	}

	@:op(-A) private inline function negate():ObjectValue
	{
		var float:Float = this;
		return -float;
	}

	@:op(++A) private inline function preIncrement():ObjectValue
	{
		var float:Float = this;
		return ++float;
	}

	@:op(A++) private inline function postIncrement():ObjectValue
	{
		var float:Float = this;
		return float++;
	}

	@:op(--A) private inline function preDecrement():ObjectValue
	{
		var float:Float = this;
		return --float;
	}

	@:op(A--) private inline function postDecrement():ObjectValue
	{
		var float:Float = this;
		return float--;
	}

	@:op(A + B) private static inline function add(a:ObjectValue, b:ObjectValue):ObjectValue
	{
		var floatA:Float = a;
		var floatB:Float = b;
		return floatA + floatB;
	}

	@:op(A + B) @:commutative private static inline function addInt(a:ObjectValue, b:Int):ObjectValue
	{
		var floatA:Float = a;
		return floatA + b;
	}

	@:op(A + B) @:commutative private static function addFloat(a:ObjectValue, b:Float):Float
	{
		var floatA:Float = a;
		return floatA + b;
	}

	@:op(A - B) private static inline function sub(a:ObjectValue, b:ObjectValue):ObjectValue
	{
		var floatA:Float = a;
		var floatB:Float = b;
		return floatA - floatB;
	}

	@:op(A - B) private static inline function subInt(a:ObjectValue, b:Int):ObjectValue
	{
		var floatA:Float = a;
		return floatA - b;
	}

	@:op(A - B) private static inline function intSub(a:Int, b:ObjectValue):ObjectValue
	{
		var floatB:Float = b;
		return a - floatB;
	}

	@:op(A - B) private static function subFloat(a:ObjectValue, b:Float):Float
	{
		var floatA:Float = a;
		return floatA - b;
	}

	@:op(A - B) private static function floatSub(a:Float, b:ObjectValue):Float
	{
		var floatB:Float = b;
		return a - floatB;
	}

	@:op(A * B) private static function mul(a:ObjectValue, b:ObjectValue):ObjectValue
	{
		var floatA:Float = a;
		var floatB:Float = b;
		return floatA * floatB;
	}

	@:op(A * B) @:commutative private static inline function mulInt(a:ObjectValue, b:Int):ObjectValue
	{
		var floatA:Float = a;
		return floatA * b;
	}

	@:op(A * B) @:commutative private static function mulFloat(a:ObjectValue, b:Float):Float
	{
		var floatA:Float = a;
		return floatA * b;
	}

	@:op(A / B) private static function div(a:ObjectValue, b:ObjectValue):Float
	{
		var floatA:Float = a;
		var floatB:Float = b;
		return floatA / floatB;
	}

	@:op(A / B) private static function divInt(a:ObjectValue, b:Int):Float
	{
		var floatA:Float = a;
		return floatA / b;
	}

	@:op(A / B) private static function intDiv(a:Int, b:ObjectValue):Float
	{
		var floatB:Float = b;
		return a / floatB;
	}

	@:op(A / B) private static function divFloat(a:ObjectValue, b:Float):Float
	{
		var floatA:Float = a;
		return floatA / b;
	}

	@:op(A / B) private static function floatDiv(a:Float, b:ObjectValue):Float
	{
		var floatB:Float = b;
		return a / floatB;
	}

	@:op(A % B) private static function mod(a:ObjectValue, b:ObjectValue):ObjectValue
	{
		var floatA:Float = a;
		var floatB:Float = b;
		return floatA % floatB;
	}

	@:op(A % B) private static function modInt(a:ObjectValue, b:Int):ObjectValue
	{
		var floatA:Float = a;
		return floatA % b;
	}

	@:op(A % B) private static function intMod(a:Int, b:ObjectValue):ObjectValue
	{
		var floatB:Float = b;
		return a % floatB;
	}

	@:op(A % B) private static function modFloat(a:ObjectValue, b:Float):Float
	{
		var floatA:Float = a;
		return floatA % b;
	}

	@:op(A % B) private static function floatMod(a:Float, b:ObjectValue):Float
	{
		var floatB:Float = b;
		return a % floatB;
	}

	@:op(A == B) private static function eq(a:ObjectValue, b:ObjectValue):Bool
	{
		var dynamicA:Dynamic = a;
		var dynamicB:Dynamic = b;
		return dynamicA == dynamicB;
	}

	@:op(A == B) @:commutative private static function eqDynamic(a:ObjectValue, b:Dynamic):Bool
	{
		var dynamicA:Dynamic = a;
		return dynamicA == b;
	}

	@:op(A != B) private static function neq(a:ObjectValue, b:ObjectValue):Bool
	{
		var dynamicA:Dynamic = a;
		var dynamicB:Dynamic = b;
		return dynamicA != dynamicB;
	}

	@:op(A != B) @:commutative private static function neqDynamic(a:ObjectValue, b:Dynamic):Bool
	{
		var dynamicA:Dynamic = a;
		return dynamicA != b;
	}

	@:op(A < B) private static function lt(a:ObjectValue, b:ObjectValue):Bool
	{
		var floatA:Float = a;
		var floatB:Float = b;
		return floatA < floatB;
	}

	@:op(A < B) private static function ltInt(a:ObjectValue, b:Int):Bool
	{
		var floatA:Float = a;
		return floatA < b;
	}

	@:op(A < B) private static function intLt(a:Int, b:ObjectValue):Bool
	{
		var floatB:Float = b;
		return a < floatB;
	}

	@:op(A < B) private static function ltFloat(a:ObjectValue, b:Float):Bool
	{
		var floatA:Float = a;
		return floatA < b;
	}

	@:op(A < B) private static function floatLt(a:Float, b:ObjectValue):Bool
	{
		var floatB:Float = b;
		return a < floatB;
	}

	@:op(A <= B) private static function lte(a:ObjectValue, b:ObjectValue):Bool
	{
		var floatA:Float = a;
		var floatB:Float = b;
		return floatA <= floatB;
	}

	@:op(A <= B) private static function lteInt(a:ObjectValue, b:Int):Bool
	{
		var floatB:Float = b;
		return a <= floatB;
	}

	@:op(A <= B) private static function intLte(a:Int, b:ObjectValue):Bool
	{
		var floatA:Float = a;
		return floatA <= b;
	}

	@:op(A <= B) private static function lteFloat(a:ObjectValue, b:Float):Bool
	{
		var floatB:Float = b;
		return a <= floatB;
	}

	@:op(A <= B) private static function floatLte(a:Float, b:ObjectValue):Bool
	{
		var floatA:Float = a;
		return floatA <= b;
	}

	@:op(A > B) private static function gt(a:ObjectValue, b:ObjectValue):Bool
	{
		var floatA:Float = a;
		var floatB:Float = b;
		return floatA > floatB;
	}

	@:op(A > B) private static function gtInt(a:ObjectValue, b:Int):Bool
	{
		var floatB:Float = b;
		return a > floatB;
	}

	@:op(A > B) private static function intGt(a:Int, b:ObjectValue):Bool
	{
		var floatB:Float = b;
		return a > floatB;
	}

	@:op(A > B) private static function gtFloat(a:ObjectValue, b:Float):Bool
	{
		var floatB:Float = b;
		return a > floatB;
	}

	@:op(A > B) private static function floatGt(a:Float, b:ObjectValue):Bool
	{
		var floatB:Float = b;
		return a > floatB;
	}

	@:op(A >= B) private static function gte(a:ObjectValue, b:ObjectValue):Bool
	{
		var floatA:Float = a;
		var floatB:Float = b;
		return floatA >= floatB;
	}

	@:op(A >= B) private static function gteInt(a:ObjectValue, b:Int):Bool
	{
		var floatB:Float = b;
		return a >= floatB;
	}

	@:op(A >= B) private static function intGte(a:Int, b:ObjectValue):Bool
	{
		var floatB:Float = b;
		return a >= floatB;
	}

	@:op(A >= B) private static function gteFloat(a:ObjectValue, b:Float):Bool
	{
		var floatB:Float = b;
		return a >= floatB;
	}

	@:op(A >= B) private static function floatGte(a:Float, b:ObjectValue):Bool
	{
		var floatB:Float = b;
		return a >= floatB;
	}

	@:op(~A) private function complement():ObjectValue
	{
		var int:Int = this;
		return ~int;
	}

	@:op(A & B) private static function and(a:ObjectValue, b:ObjectValue):ObjectValue
	{
		var intA:Int = a;
		var intB:Int = b;
		return intA & intB;
	}

	@:op(A & B) @:commutative private static function andInt(a:ObjectValue, b:Int):ObjectValue
	{
		var intA:Int = a;
		return intA & b;
	}

	@:op(A | B) private static function or(a:ObjectValue, b:ObjectValue):ObjectValue
	{
		var intA:Int = a;
		var intB:Int = b;
		return intA | intB;
	}

	@:op(A | B) @:commutative private static function orInt(a:ObjectValue, b:Int):ObjectValue
	{
		var intA:Int = a;
		return intA | b;
	}

	@:op(A ^ B) private static function xor(a:ObjectValue, b:ObjectValue):ObjectValue
	{
		var intA:Int = a;
		var intB:Int = b;
		return intA ^ intB;
	}

	@:op(A ^ B) @:commutative private static function xorInt(a:ObjectValue, b:Int):ObjectValue
	{
		var intA:Int = a;
		return intA ^ b;
	}

	@:op(A >> B) private static function shr(a:ObjectValue, b:ObjectValue):ObjectValue
	{
		var intA:Int = a;
		var intB:Int = b;
		return intA >> intB;
	}

	@:op(A >> B) private static function shrInt(a:ObjectValue, b:Int):ObjectValue
	{
		var intA:Int = a;
		return intA >> b;
	}

	@:op(A >> B) private static function intShr(a:Int, b:ObjectValue):ObjectValue
	{
		var intB:Int = b;
		return a >> intB;
	}

	@:op(A >>> B) private static function ushr(a:ObjectValue, b:ObjectValue):ObjectValue
	{
		var intA:Int = a;
		var intB:Int = b;
		return intA >>> intB;
	}

	@:op(A >>> B) private static function ushrInt(a:ObjectValue, b:Int):ObjectValue
	{
		var intA:Int = a;
		return intA >>> b;
	}

	@:op(A >>> B) private static function intUshr(a:Int, b:ObjectValue):ObjectValue
	{
		var intB:Int = b;
		return a >>> intB;
	}

	@:op(A << B) private static function shl(a:ObjectValue, b:ObjectValue):ObjectValue
	{
		var intA:Int = a;
		var intB:Int = b;
		return intA << intB;
	}

	@:op(A << B) private static function shlInt(a:ObjectValue, b:Int):ObjectValue
	{
		var intA:Int = a;
		return intA << b;
	}

	@:op(A << B) private static function intShl(a:Int, b:ObjectValue):ObjectValue
	{
		var intB:Int = b;
		return a << intB;
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
