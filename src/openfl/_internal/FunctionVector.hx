package openfl._internal;

import haxe.Constraints.Function;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FunctionVector implements IVector<Function>
{
	public var fixed:Bool;
	public var length(get, set):Int;

	public var __array:Array<Function>;

	public function new(length:Int = 0, fixed:Bool = false, array:Array<Function> = null):Void
	{
		if (array == null) array = new Array();
		__array = array;

		if (length > 0)
		{
			this.length = length;
		}

		this.fixed = fixed;
	}

	public function concat(a:IVector<Function> = null):IVector<Function>
	{
		if (a == null)
		{
			return new FunctionVector(0, false, __array.copy());
		}
		else
		{
			var other:FunctionVector = cast a;

			if (other.__array.length > 0)
			{
				return new FunctionVector(0, false, __array.concat(other.__array));
			}
			else
			{
				return new FunctionVector(0, false, __array.copy());
			}
		}
	}

	public function copy():IVector<Function>
	{
		return new FunctionVector(0, fixed, __array.copy());
	}

	public function filter(callback:Function->Bool):IVector<Function>
	{
		return new FunctionVector(0, fixed, __array.filter(callback));
	}

	public function get(index:Int):Function
	{
		if (index >= __array.length)
		{
			return null;
		}
		else
		{
			return __array[index];
		}
	}

	public function indexOf(x:Function, from:Int = 0):Int
	{
		for (i in from...__array.length)
		{
			if (Reflect.compareMethods(__array[i], x))
			{
				return i;
			}
		}

		return -1;
	}

	public function insertAt(index:Int, element:Function):Void
	{
		if (!fixed || index < __array.length)
		{
			__array.insert(index, element);
		}
	}

	public function iterator():Iterator<Function>
	{
		return cast __array.iterator();
	}

	public function join(sep:String = ","):String
	{
		return __array.join(sep);
	}

	public function lastIndexOf(x:Function, from:Null<Int> = null):Int
	{
		var i = (from == null || from >= __array.length) ? __array.length - 1 : from;

		while (i >= 0)
		{
			if (Reflect.compareMethods(__array[i], x)) return i;
			i--;
		}

		return -1;
	}

	public function pop():Function
	{
		if (!fixed)
		{
			return __array.pop();
		}
		else
		{
			return null;
		}
	}

	public function push(x:Function):Int
	{
		if (!fixed)
		{
			return __array.push(x);
		}
		else
		{
			return __array.length;
		}
	}

	public function removeAt(index:Int):Function
	{
		if (!fixed || index < __array.length)
		{
			return __array.splice(index, 1)[0];
		}

		return null;
	}

	public function reverse():IVector<Function>
	{
		__array.reverse();
		return this;
	}

	public function set(index:Int, value:Function):Function
	{
		if (!fixed || index < __array.length)
		{
			return __array[index] = value;
		}
		else
		{
			return value;
		}
	}

	public function shift():Function
	{
		if (!fixed)
		{
			return __array.shift();
		}
		else
		{
			return null;
		}
	}

	public function slice(startIndex:Int = 0, endIndex:Null<Int> = null):IVector<Function>
	{
		if (endIndex == null) endIndex = 16777215;
		return new FunctionVector(0, false, __array.slice(startIndex, endIndex));
	}

	public function sort(f:Function->Function->Int):Void
	{
		__array.sort(f);
	}

	public function splice(pos:Int, len:Int):IVector<Function>
	{
		return new FunctionVector(0, false, __array.splice(pos, len));
	}

	@:keep public function toJSON():Dynamic
	{
		return __array;
	}

	public function toString():String
	{
		return __array != null ? __array.toString() : null;
	}

	public function unshift(x:Function):Void
	{
		if (!fixed)
		{
			__array.unshift(x);
		}
	}

	// Getters & Setters
	private function get_length():Int
	{
		return __array.length;
	}

	private function set_length(value:Int):Int
	{
		if (!fixed)
		{
			#if cpp
			cpp.NativeArray.setSize(__array, value);
			#else
			var currentLength = __array.length;
			if (value < 0) value = 0;

			if (value > currentLength)
			{
				for (i in currentLength...value)
				{
					__array[i] = null;
				}
			}
			else
			{
				while (__array.length > value)
				{
					__array.pop();
				}
			}
			#end
		}

		return __array.length;
	}
}
