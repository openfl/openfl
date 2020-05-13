package openfl._internal;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ObjectVector<T> implements IVector<T>
{
	public var fixed:Bool;
	public var length(get, set):Int;

	public var __array:Array<T>;

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
			if (array == null) array = cast new Array<T>();
			__array = cast array;
		}

		if (length > 0)
		{
			this.length = length;
		}

		this.fixed = fixed;
	}

	public function concat(a:IVector<T> = null):IVector<T>
	{
		if (a == null)
		{
			return new ObjectVector(0, false, __array.copy());
		}
		else
		{
			var other:ObjectVector<Dynamic> = cast a;

			if (other.__array.length > 0)
			{
				return new ObjectVector(0, false, __array.concat(cast other.__array));
			}
			else
			{
				return new ObjectVector(0, false, __array.copy());
			}
		}
	}

	public function copy():IVector<T>
	{
		return new ObjectVector(0, fixed, __array.copy());
	}

	public function filter(callback:T->Bool):IVector<T>
	{
		return new ObjectVector(0, fixed, __array.filter(callback));
	}

	public function get(index:Int):T
	{
		return __array[index];
	}

	public function indexOf(x:T, from:Int = 0):Int
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

	public function insertAt(index:Int, element:T):Void
	{
		if (!fixed || index < __array.length)
		{
			__array.insert(index, element);
		}
	}

	public function iterator():Iterator<T>
	{
		return cast __array.iterator();
	}

	public function join(sep:String = ","):String
	{
		return __array.join(sep);
	}

	public function lastIndexOf(x:T, from:Null<Int> = null):Int
	{
		var i = (from == null || from >= __array.length) ? __array.length - 1 : from;

		while (i >= 0)
		{
			if (__array[i] == x) return i;
			i--;
		}

		return -1;
	}

	public function pop():T
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

	public function push(x:T):Int
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

	public function removeAt(index:Int):T
	{
		if (!fixed || index < __array.length)
		{
			return __array.splice(index, 1)[0];
		}

		return null;
	}

	public function reverse():IVector<T>
	{
		__array.reverse();
		return this;
	}

	public function set(index:Int, value:T):T
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

	public function shift():T
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

	public function slice(startIndex:Int = 0, endIndex:Null<Int> = null):IVector<T>
	{
		if (endIndex == null) endIndex = 16777215;
		return new ObjectVector(0, false, __array.slice(startIndex, endIndex));
	}

	public function sort(f:T->T->Int):Void
	{
		__array.sort(f);
	}

	public function splice(pos:Int, len:Int):IVector<T>
	{
		return new ObjectVector(0, false, __array.splice(pos, len));
	}

	@:keep public function toJSON():Dynamic
	{
		return __array;
	}

	public function toString():String
	{
		return __array != null ? __array.toString() : null;
	}

	public function unshift(x:T):Void
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
					__array.push(null);
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
