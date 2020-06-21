package openfl._internal;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class BoolVector implements IVector<Bool>
{
	public var fixed:Bool;
	public var length(get, set):Int;

	public var __array:Array<Bool>;

	public function new(length:Int = 0, fixed:Bool = false, array:Array<Bool> = null):Void
	{
		if (array == null) array = new Array();
		__array = array;

		if (length > 0)
		{
			this.length = length;
		}

		this.fixed = fixed;
	}

	public function concat(a:IVector<Bool> = null):IVector<Bool>
	{
		if (a == null)
		{
			return new BoolVector(0, false, __array.copy());
		}
		else
		{
			var other:BoolVector = cast a;

			if (other.__array.length > 0)
			{
				return new BoolVector(0, false, __array.concat(other.__array));
			}
			else
			{
				return new BoolVector(0, false, __array.copy());
			}
		}
	}

	public function copy():IVector<Bool>
	{
		return new BoolVector(0, fixed, __array.copy());
	}

	public function filter(callback:Bool->Bool):IVector<Bool>
	{
		return new BoolVector(0, fixed, __array.filter(callback));
	}

	public function get(index:Int):Bool
	{
		if (index >= __array.length)
		{
			return false;
		}
		else
		{
			return __array[index];
		}
	}

	public function indexOf(x:Bool, from:Int = 0):Int
	{
		for (i in from...__array.length)
		{
			if (__array[i] == x)
			{
				return i;
			}
		}

		return -1;
	}

	public function insertAt(index:Int, element:Bool):Void
	{
		if (!fixed || index < __array.length)
		{
			__array.insert(index, element);
		}
	}

	public function iterator():Iterator<Bool>
	{
		return cast __array.iterator();
	}

	public function join(sep:String = ","):String
	{
		return __array.join(sep);
	}

	public function lastIndexOf(x:Bool, from:Null<Int> = null):Int
	{
		var i = (from == null || from >= __array.length) ? __array.length - 1 : from;

		while (i >= 0)
		{
			if (__array[i] == x) return i;
			i--;
		}

		return -1;
	}

	public function pop():Null<Bool>
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

	public function push(x:Bool):Int
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

	public function removeAt(index:Int):Bool
	{
		if (!fixed || index < __array.length)
		{
			return __array.splice(index, 1)[0];
		}

		return false;
	}

	public function reverse():IVector<Bool>
	{
		__array.reverse();
		return this;
	}

	public function set(index:Int, value:Bool):Bool
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

	public function shift():Null<Bool>
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

	public function slice(startIndex:Int = 0, endIndex:Null<Int> = null):IVector<Bool>
	{
		if (endIndex == null) endIndex = 16777215;
		return new BoolVector(0, false, __array.slice(startIndex, endIndex));
	}

	public function sort(f:Bool->Bool->Int):Void
	{
		__array.sort(f);
	}

	public function splice(pos:Int, len:Int):IVector<Bool>
	{
		return new BoolVector(0, false, __array.splice(pos, len));
	}

	@:keep public function toJSON():Dynamic
	{
		return __array;
	}

	public function toString():String
	{
		return __array != null ? __array.toString() : null;
	}

	public function unshift(x:Bool):Void
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
					__array[i] = false;
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
