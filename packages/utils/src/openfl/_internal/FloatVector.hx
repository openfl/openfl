package openfl._internal;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FloatVector implements IVector<Float>
{
	public var fixed:Bool;
	public var length(get, set):Int;

	public var __array:Array<Float>;

	public function new(length:Int = 0, fixed:Bool = false, array:Array<Dynamic> = null, forceCopy:Bool = false):Void
	{
		if (forceCopy)
		{
			__array = new Array();
			if (array != null) for (i in 0...array.length)
				__array[i] = array[i];
		}
		else
		{
			if (array == null) array = new Array<Float>();
			__array = cast array;
		}

		if (length > 0)
		{
			this.length = length;
		}

		this.fixed = fixed;
	}

	public function concat(a:IVector<Float> = null):IVector<Float>
	{
		if (a == null)
		{
			return new FloatVector(0, false, __array.copy());
		}
		else
		{
			var other:FloatVector = cast a;

			if (other.__array.length > 0)
			{
				return new FloatVector(0, false, __array.concat(other.__array));
			}
			else
			{
				return new FloatVector(0, false, __array.copy());
			}
		}
	}

	public function copy():IVector<Float>
	{
		return new FloatVector(0, fixed, __array.copy());
	}

	public function filter(callback:Float->Bool):IVector<Float>
	{
		return new FloatVector(0, fixed, __array.filter(callback));
	}

	public function get(index:Int):Float
	{
		return __array[index];
	}

	public function indexOf(x:Float, from:Int = 0):Int
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

	public function insertAt(index:Int, element:Float):Void
	{
		if (!fixed || index < __array.length)
		{
			__array.insert(index, element);
		}
	}

	public function iterator():Iterator<Float>
	{
		return cast __array.iterator();
	}

	public function join(sep:String = ","):String
	{
		return __array.join(sep);
	}

	public function lastIndexOf(x:Float, from:Null<Int> = null):Int
	{
		var i = (from == null || from >= __array.length) ? __array.length - 1 : from;

		while (i >= 0)
		{
			if (__array[i] == x) return i;
			i--;
		}

		return -1;
	}

	public function pop():Null<Float>
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

	public function push(x:Float):Int
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

	public function removeAt(index:Int):Float
	{
		if (!fixed || index < __array.length)
		{
			return __array.splice(index, 1)[0];
		}

		return 0;
	}

	public function reverse():IVector<Float>
	{
		__array.reverse();
		return this;
	}

	public function set(index:Int, value:Float):Float
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

	public function shift():Null<Float>
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

	public function slice(startIndex:Int = 0, endIndex:Null<Int> = null):IVector<Float>
	{
		if (endIndex == null) endIndex = 16777215;
		return new FloatVector(0, false, __array.slice(startIndex, endIndex));
	}

	public function sort(f:Float->Float->Int):Void
	{
		__array.sort(f);
	}

	public function splice(pos:Int, len:Int):IVector<Float>
	{
		return new FloatVector(0, false, __array.splice(pos, len));
	}

	@:keep public function toJSON():Dynamic
	{
		return __array;
	}

	public function toString():String
	{
		return __array != null ? __array.toString() : null;
	}

	public function unshift(x:Float):Void
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
		if (value != __array.length && !fixed)
		{
			#if cpp
			if (value > __array.length)
			{
				cpp.NativeArray.setSize(__array, value);
			}
			else
			{
				__array.splice(value, __array.length);
			}
			#else
			var currentLength = __array.length;
			if (value < 0) value = 0;

			if (value > currentLength)
			{
				for (i in currentLength...value)
				{
					__array[i] = 0;
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
