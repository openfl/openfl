package openfl;

#if (!flash || display)
#if (!openfljs || !js)
import haxe.Constraints.Function;

/**
	The Vector class lets you access and manipulate a vector — an array whose elements
	all have the same data type. The data type of a Vector's elements is known as the
	Vector's base type. The base type can be any class, including built in classes and
	custom classes. The base type is specified when declaring a Vector variable as well
	as when creating an instance by calling the class constructor.

	As with an Array, you can use the array access operator (`[]`) to set or retrieve the
	value of a Vector element. Several Vector methods also provide mechanisms for
	setting and retrieving element values. These include `push()`, `pop()`, `shift()`,
	`unshift()`, and others. The properties and methods of a Vector object are
	similar — in most cases identical — to the properties and methods of an Array. In
	most cases where you would use an Array in which all the elements have the same
	data type, a Vector instance is preferable. However, Vector instances are dense
	arrays, meaning it must have a value (or `null`) in each index. Array instances
	don't have this same restriction.

	The Vector's base type is specified using postfix type parameter syntax. Type
	parameter syntax is a sequence consisting of a dot (`.`), left angle bracket (`<`),
	class name, then a right angle bracket (`>`), as shown in this example:

	In the first line of the example, the variable `v` is declared as a
	Vector.<String> instance. In other words, it represents a Vector (an array) that
	can only hold String instances and from which only String instances can be
	retrieved. The second line constructs an instance of the same Vector type (that is,
	a Vector whose elements are all String objects) and assigns it to `v`.

	```as3
	var v:Vector.<String>;
	v = new Vector.<String>();
	```

	A variable declared with the Vector.<T> data type can only store a Vector instance
	that is constructed with the same base type T. For example, a Vector that's
	constructed by calling `new Vector.<String>()` can't be assigned to a variable that's
	declared with the Vector.<int> data type. The base types must match exactly. For
	example, the following code doesn't compile because the object's base type isn't
	the same as the variable's declared base type (even though Sprite is a subclass of
	DisplayObject):

	```haxe
	// This code doesn't compile even though Sprite is a DisplayObject subclass
	var v:Vector.<DisplayObject> = new Vector.<Sprite>();
	```

	To convert a Vector with base type T to a Vector of a superclass of T, use the
	`Vector()` global function.

	In addition to the data type restriction, the Vector class has other restrictions
	that distinguish it from the Array class:

	* A Vector is a dense array. Unlike an Array, which may have values in indices 0 and 7
	even if there are no values in positions 1 through 6, a Vector must have a value
	(or null) in each index.
	* A Vector can optionally be fixed-length, meaning the number of elements it contains
	can't change.
	* Access to a Vector's elements is bounds-checked. You can never read a value from an
	index greater than the final element (length - 1). You can never set a value with an
	index more than one beyond the current final index (in other words, you can only set
	a value at an existing index or at index [length]).

	As a result of its restrictions, a Vector has three primary benefits over an Array
	instance whose elements are all instances of a single class:

	* Performance: array element access and iteration are much faster when using a
	Vector instance than they are when using an Array.
	* Type safety: in strict mode the compiler can identify data type errors. Examples
	of data type errors include assigning a value of the incorrect data type to a
	Vector or expecting the wrong data type when reading a value from a Vector. Note,
	however, that when using the push() method or unshift() method to add values to a
	Vector, the arguments' data types are not checked at compile time. Instead, they are
	checked at run time.
	* Reliability: runtime range checking (or fixed-length checking) increases
	reliability significantly over Arrays.
**/
#if !flash
@:multiType(T)
#end
abstract Vector<T>(IVector<T>)
{
	/**
		Indicates whether the `length` property of the Vector can be changed. If the
		value is `true`, the `length` property can't be changed. This means the
		following operations are not allowed when `fixed` is `true`:

		* setting the `length` property directly
		* assigning a value to index position length
		* calling a method that changes the `length` property, including:
			* `pop()`
			* `push()`
			* `shift()`
			* `unshift()`
			* `splice()` (if the `splice()` call changes the length of the Vector).
	**/
	public var fixed(get, set):Bool;

	/**
		The range of valid indices available in the Vector. A Vector instance has index
		positions up to but not including the length value.

		Every Vector element always has a value that is either an instance of the base
		type or `null`. When the `length` property is set to a value that's larger than
		its previous value, additional elements are created and populated with the
		default value appropriate to the base type (`null` for reference types).

		When the `length` property is set to a value that's smaller than its previous
		value, all the elements at index positions greater than or equal to the new
		length value are removed from the Vector.
	**/
	public var length(get, set):Int;

	/**
		Creates a Vector with the specified base type.

		When calling the `Vector.<T>()` constructor, specify the base type using
		type parameter syntax. Type parameter syntax is a sequence consisting of a
		dot (`.`), left angle bracket (`<`), class name, then a right angle bracket (`>`),
		as shown in this example:

		```as3
		var v:Vector.<String> = new Vector.<String>();
		```

		To create a Vector instance from an Array or another Vector (such as one with a
		different base type), use the `Vector()` global function.

		To create a pre-populated Vector instance, use the following syntax instead of
		using the parameters specified below:

		```as3
		// var v:Vector.<T> = new <T>[E0, ..., En-1 ,];
		// For example:
		var v:Vector.<int> = new <int>[0,1,2,];
		```

		The following information applies to this syntax:

		* It is supported in Flash Professional CS5 and later, Flash Builder 4 and later,
		and Flex 4 and later.
		* The trailing comma is optional.
		* Empty items in the array are not supported; a statement such as
		`var v:Vector.<int> = new <int>[0,,2,]` throws a compiler error.
		* You can't specify a default length for the Vector instance. Instead, the length
		is the same as the number of elements in the initialization list.
		* You can't specify whether the Vector instance has a fixed length. Instead, use
		the fixed property.
		* Data loss or errors can occur if items passed as values don't match the
		specified type. For example:

		```as3
		var v:Vector.<int> = new <int>[4.2]; // compiler error when running in strict mode
		trace(v[0]); //returns 4 when not running in strict mode
		```

		@param	length	The initial length (number of elements) of the Vector. If this
		parameter is greater than zero, the specified number of Vector elements are
		created and populated with the default value appropriate to the base type
		(`null` for reference types).
		@param	fixed	Whether the Vector's length is fixed (`true`) or can be changed
		(`false`). This value can also be set using the fixed property.
	**/
	#if !flash
	public function new(length:Null<Int> = 0, fixed:Null<Bool> = false, array:Array<T> = null):Void;
	#else
	public function new(length:Null<Int> = 0, fixed:Null<Bool> = false, array:Array<T> = null):Void
	{
		this = null;
	}
	#end

	/**
		Concatenates the Vectors specified in the parameters list with the elements in
		this Vector and creates a new Vector. The Vectors in the parameters list must
		have the same base type, or subtype, as this Vector. If you do not pass any
		parameters, the returned Vector is a duplicate (shallow clone) of the original
		Vector.

		@param	vec	A Vector of the base type, or subtype, of this Vector.
		@return	A Vector with the same base type as this Vector that contains the
		elements from this Vector followed by elements from the Vector in the
		parameter list.
		@throws	TypeError	If any argument is not a Vector of the base type, or cannot
		be converted to a Vector of the base type.
	**/
	public inline function concat(vec:Vector<T> = null):Vector<T>
	{
		return cast this.concat(cast vec);
	}

	/**
		Creates a new shallow clone of the current Vector object
		@return	A new Vector object
	**/
	public inline function copy():Vector<T>
	{
		return cast this.copy();
	}

	/**
		Executes a test function on each item in the Vector until an item is reached
		that returns false for the specified function. You use this method to determine
		whether all items in a Vector meet a criterion, such as having values less than
		a particular number.

		For this method, the second parameter, thisObject, must be null if the first
		parameter, callback, is a method closure. That is the most common way of using
		this method.

		@param	callback The function to run on each item in the Vector. This function
		is invoked with three arguments: the current item from the Vector, the index of
		the item, and the Vector object:

			 	```hx
			 	function callback(item:T, index:Int, vector:Vector<T>):Bool {
			 		// your code here
		}
		```
		The callback function should return a Boolean value.

		@param	thisObject The object that the identifer this in the callback function
		refers to when the function is called. ***Ignored on targets other than neko and
		js.
		@return A Boolean value of true if the specified function returns true when called
		on all items in the Vector; otherwise, false.
	 */
	public inline function every(callback:Function, ?thisObject:Dynamic):Bool
	{
		for (i in 0...this.length)
		{
			@:privateAccess this.__tempIndex = i;

			if (thisObject != null)
			{
				if (Reflect.callMethod(thisObject, callback, [cast this.get(i), i, cast this]) == false) break;
			}
			else if (callback(cast this.get(i), i, cast this) == false) break;
		}
		return (@:privateAccess this.__tempIndex == this.length - 1);
	}

	/**
		Executes a test function on each item in the Vector and returns a new Vector
		containing all items that return true for the specified function. If an item
		returns false, it is not included in the result Vector. The base type of the return
		Vector matches the base type of the Vector on which the method is called.
		@param	callback	The function to run on each item in the Vector.
	**/
	#if (openfl < "9.0.0") @:dox(hide) #end public inline function filter(callback:T->Bool):Vector<T>
	{
		return cast this.filter(cast callback);
	}

	/**
		Array access
	**/
	@:noCompletion @:dox(hide) @:arrayAccess public inline function get(index:Int):T
	{
		return this.get(index);
	}

	/**
		Searches for an item in the Vector and returns the index position of the item.
		The item is compared to the Vector elements using strict equality (`===`).
		@param	searchElement	The item to find in the Vector.
		@param	fromIndex	The location in the Vector from which to start searching for
		the item. If this parameter is negative, it is treated as `length + fromIndex`,
		meaning the search starts -fromIndex items from the end and searches from that
		position forward to the end of the Vector.
		@return	A zero-based index position of the item in the Vector. If the
		`searchElement` argument is not found, the return value is -1.
	**/
	public inline function indexOf(searchElement:T, fromIndex:Int = 0):Int
	{
		return this.indexOf(searchElement, fromIndex);
	}

	/**
		Insert a single element into the Vector. This method modifies the Vector without
		making a copy.

		@param	index	An integer that specifies the position in the Vector where the
		element is to be inserted. You can use a negative integer to specify a position
		relative to the end of the Vector (for example, -1 for the last element of the
		Vector).
		@param	element	The value to insert
		@throws	RangeError	If this method is called while `fixed` is `true`.
	**/
	public inline function insertAt(index:Int, element:T):Void
	{
		this.insertAt(index, element);
	}

	/**
		Iterator
	**/
	@:noCompletion @:dox(hide) public inline function iterator():Iterator<T>
	{
		return this.iterator();
	}

	/**
		Converts the elements in the Vector to strings, inserts the specified separator
		between the elements, concatenates them, and returns the resulting string. A
		nested Vector is always separated by a comma (`,`), not by the separator passed
		to the `join()` method.

		@param	sep	A character or string that separates Vector elements in the returned
		string. If you omit this parameter, a comma is used as the default separator.
		@return	A string consisting of the elements of the Vector converted to strings
		and separated by the specified string.
	**/
	public inline function join(sep:String = ","):String
	{
		return this.join(sep);
	}

	/**
		Searches for an item in the Vector, working backward from the specified index
		position, and returns the index position of the matching item. The item is
		compared to the Vector elements using strict equality (`===`).

		@param	searchElement	The item to find in the Vector.
		@param	fromIndex	The location in the Vector from which to start searching for
		the item. The default is the maximum allowable index value, meaning that the
		search starts at the last item in the Vector.

		If this parameter is negative, it is treated as `length + fromIndex`, meaning the
		search starts -fromIndex items from the end and searches from that position
		backward to index 0.
		@return	A zero-based index position of the item in the Vector. If the
		`searchElement` argument is not found, the return value is -1.
	**/
	public inline function lastIndexOf(searchElement:T, fromIndex:Null<Int> = null):Int
	{
		return this.lastIndexOf(searchElement, fromIndex);
	}

	/**
		Removes the last element from the Vector and returns that element. The `length`
		property of the Vector is decreased by one when this function is called.
		@return	The value of the last element in the specified Vector.
		@throws	RangeError	If this method is called while `fixed` is `true`.
	**/
	public inline function pop():Null<T>
	{
		return this.pop();
	}

	/**
		Adds one or more elements to the end of the Vector and returns the new length of
		the Vector.

		Because this function can accept multiple arguments, the data type of the
		arguments is not checked at compile time even in strict mode. However, if an
		argument is passed that is not an instance of the base type, an exception
		occurs at run time.

		@param	value	A value to append to the Vector.
		@return	The length of the Vector after the new elements are added.
		@throws	TypeError	If any argument is not an instance of the base type T of
		the Vector.
		@throws	RangeError	If this method is called while `fixed` is `true`.
	**/
	public inline function push(value:T):Int
	{
		return this.push(value);
	}

	/**
		Remove a single element from the Vector. This method modifies the Vector without
		making a copy.

		@param	index	An integer that specifies the index of the element in the Vector
		that is to be deleted. You can use a negative integer to specify a position
		relative to the end of the Vector (for example, -1 for the last element of the
		Vector).
		@return	The element that was removed from the original Vector.
		@throws	RangeError	If the index argument specifies an index to be deleted that's
		outside the Vector's bounds.
		@throws	RangeError	If this method is called while `fixed` is `true`.
	**/
	public inline function removeAt(index:Int):T
	{
		return this.removeAt(index);
	}

	/**
		Reverses the order of the elements in the Vector. This method alters the Vector
		on which it is called.

		@return	The Vector with the elements in reverse order.
	**/
	public inline function reverse():Vector<T>
	{
		return cast this.reverse();
	}

	/**
		Array access
	**/
	@:noCompletion @:dox(hide) @:arrayAccess public inline function set(index:Int, value:T):T
	{
		return this.set(index, value);
	}

	/**
		Removes the first element from the Vector and returns that element. The
		remaining Vector elements are moved from their original position, i, to i - 1.

		@return	The first element in the Vector.
		@throws	RangeError	If `fixed` is `true`.
	**/
	public inline function shift():Null<T>
	{
		return this.shift();
	}

	/**
		Returns a new Vector that consists of a range of elements from the original
		Vector, without modifying the original Vector. The returned Vector includes the
		`startIndex` element and all elements up to, but not including, the
		`endIndex` element.

		If you don't pass any parameters, the new Vector is a duplicate (shallow clone) of
		the original Vector. If you pass a value of 0 for both parameters, a new, empty
		Vector is created of the same type as the original Vector.

		@param	startIndex	A number specifying the index of the starting point for the
		slice. If startIndex is a negative number, the starting point begins at the end
		of the Vector, where -1 is the last element.
		@param	endIndex	A number specifying the index of the ending point for the
		slice. If you omit this parameter, the slice includes all elements from the
		starting point to the end of the Vector. If endIndex is a negative number, the
		ending point is specified from the end of the Vector, where -1 is the last element.
		@return	A Vector that consists of a range of elements from the original Vector.
	**/
	public inline function slice(startIndex:Int = 0, endIndex:Null<Int> = null):Vector<T>
	{
		return cast this.slice(startIndex, endIndex);
	}

	/**

		@param	callback  The function to run on each item in the Vector. This function is
		invoked with three arguments: the current item from the Vector, the index of the item,
		and the Vector object:

		```hx
		function callback(item:T, index:Int, vector:Vector<T>):Bool
		```

		The callback function should return a Boolean value.
		@param	thisObject The object that the identifer this in the callback function refers
		to when the function is called. ***Ignored on targets other than neko and js.
		@return 	A Boolean value of true if any items in the Vector return true for the specified
		function; otherwise, false.
	 */
	public inline function some(callback:Function, ?thisObject:Dynamic):Bool
	{
		for (i in 0...this.length)
		{
			@:privateAccess this.__tempIndex = i;

			if (thisObject != null)
			{
				if (Reflect.callMethod(thisObject, callback, [cast this.get(i), i, cast this]) == true) break;
			}
			else if (callback(cast this.get(i), i, cast this)) break;

			if (i == this.length - 1) @:privateAccess this.__tempIndex++;
		}
		return (@:privateAccess this.__tempIndex < this.length - 1);
	}

	/**
		Sorts the elements in the Vector object, and also returns a sorted Vector object.
		This method sorts according to the parameter sortBehavior, which is either a
		function that compares two values, or a set of sorting options.

		The method takes one parameter. The parameter is one of the following:

		* a function that takes two arguments of the base type (T) of the Vector and
		returns a Number:

			```as3
			function compare(x:T, y:T):Number {}
			```

			The logic of the function is that, given two elements `x` and `y`, the function
			returns one of the following three values:

			* a negative number, if `x` should appear before `y` in the sorted sequence
			* 0, if `x` equals `y`
			* a positive number, if `x` should appear after `y` in the sorted sequence

		* a number which is a bitwise OR of the following values:
			* 1 or `Array.CASEINSENSITIVE`
			* 2 or `Array.DESCENDING`
			* 4 or `Array.UNIQUESORT`
			* 8 or `Array.RETURNINDEXEDARRAY`
			* 16 or `Array.NUMERIC`

			If the value is 0, the sort works in the following way:

			* Sorting is case-sensitive (Z precedes a).
			* Sorting is ascending (a precedes b).
			* The array is modified to reflect the sort order; multiple elements that
			have identical sort fields are placed consecutively in the sorted array in
			no particular order.
			* All elements, regardless of data type, are sorted as if they were strings,
			so 100 precedes 99, because "1" is a lower string value than "9".

		@param	sortBehavior	A Function or a Number value that determines the
		behavior of the sort. A Function parameter specifies a comparison method. A
		Number value specifies the sorting options.
		@return	A Vector object, with elements in the new order.
	**/
	public inline function sort(sortBehavior:T->T->Int):Void
	{
		this.sort(sortBehavior);
	}

	/**
		Adds elements to and removes elements from the Vector. This method modifies the
		Vector without making a copy.

		**Note:** To override this method in a subclass of Vector, use ...args for the
		parameters, as this example shows:

		```as3
		public override function splice(...args) {
		// your statements here
		}
		```

		@param	startIndex:int — An integer that specifies the index of the element in the Vector where the insertion or deletion begins. You can use a negative integer to specify a position relative to the end of the Vector (for example, -1 for the last element of the Vector).
		@param	deleteCount:uint (default = 4294967295) — An integer that specifies the number of elements to be deleted. This number includes the element specified in the startIndex parameter. If the value is 0, no elements are deleted.
		@param	... items — An optional list of one or more comma-separated values to insert into the Vector at the position specified in the startIndex parameter.
		@return	a Vector containing the elements that were removed from the original Vector.
		@throws	RangeError	If the startIndex and deleteCount arguments specify an index to be deleted that's outside the Vector's bounds.
		@throws	RangeError	If this method is called while fixed is true and the splice() operation changes the length of the Vector.
	**/
	public inline function splice(startIndex:Int, deleteCount:Int #if (haxe_ver >= 4.2), ...items #end):Vector<T>
	{
		#if (haxe_ver >= 4.2)
		@:privateAccess this.__tempIndex = startIndex;

		for (item in items)
		{
			this.insertAt(@:privateAccess this.__tempIndex, cast item);
			@:privateAccess this.__tempIndex++;
		}
		return cast this.splice(@:privateAccess this.__tempIndex, deleteCount);
		#else
		return cast this.splice(startIndex, deleteCount);
		#end
	}

	/**
		Returns a string that represents the elements in the Vector. Every element in the
		Vector, starting with index 0 and ending with the highest index, is converted to
		a concatenated string and separated by commas. To specify a custom separator,
		use the `Vector.join()` method.

		@return	A string of Vector elements.
	**/
	public inline function toString():String
	{
		return this != null ? this.toString() : null;
	}

	/**
		Adds one or more elements to the beginning of the Vector and returns the new
		length of the Vector. The other elements in the Vector are moved from their
		original position, i, to i + the number of new elements.

		Because this function can accept multiple arguments, the data type of the
		arguments is not checked at compile time even in strict mode. However, if an
		argument is passed that is not an instance of the base type, an exception occurs
		at run time.

		@param	value	An instance of the base type of the Vector to be inserted at the
		beginning of the Vector.
		@return	An integer representing the new length of the Vector.
		@throws	TypeError	If any argument is not an instance of the base type T of the
		Vector.
		@throws	RangeError	If this method is called while fixed is true.
	**/
	public inline function unshift(value:T):Void
	{
		this.unshift(value);
	}

	/**
		Creates a new Vector object using the values from an Array object
		@param	array	An Array object
		@return	A new Vector object
	**/
	@:generic public inline static function ofArray<T>(array:Array<T>):Vector<T>
	{
		var vector:Vector<T> = new Vector<T>();

		for (i in 0...array.length)
		{
			vector[i] = cast array[i];
		}

		return vector;
	}

	/**
		Attempts to cast a Vector to another Vector object of a similar type
		@param	vec	A Vector object to cast
		@return	The casted Vector object
	**/
	public inline static function convert<T, U>(vec:IVector<T>):IVector<U>
	{
		return cast vec;
	}

	#if !flash
	@:to #if (!js && !flash) inline #end private static function toBoolVector<T:Bool>(t:IVector<T>, length:Int, fixed:Bool, array:Array<T>):BoolVector
	{
		return new BoolVector(length, fixed, cast array);
	}

	@:to #if (!js && !flash) inline #end private static function toIntVector<T:Int>(t:IVector<T>, length:Int, fixed:Bool, array:Array<T>):IntVector
	{
		return new IntVector(length, fixed, cast array);
	}

	@:to #if (!js && !flash) inline #end private static function toFloatVector<T:Float>(t:IVector<T>, length:Int, fixed:Bool, array:Array<T>):FloatVector
	{
		return new FloatVector(length, fixed, cast array, true);
	}

	#if !cs
	@:to #if (!js && !flash) inline #end private static function toFunctionVector<T:Function>(t:IVector<T>, length:Int, fixed:Bool,
			array:Array<T>):FunctionVector
	{
		return new FunctionVector(length, fixed, cast array);
	}
	#end

	@:to #if (!js && !flash) inline #end private static function toObjectVector<T:{}>(t:IVector<T>, length:Int, fixed:Bool, array:Array<T>):ObjectVector<T>
	{
		return new ObjectVector<T>(length, fixed, cast array, true);
	}

	@SuppressWarnings("checkstyle:Dynamic") @:to #if (!js && !flash) inline #end private static function toNullVector<T:Null<Dynamic>>(t:IVector<T>,
			length:Int, fixed:Bool, array:Array<T>):ObjectVector<T>
	{
		return new ObjectVector<T>(length, fixed, cast array, true);
	}

	@:from private static inline function fromBoolVector<T>(vector:BoolVector):Vector<T>
	{
		return cast vector;
	}

	@:from private static inline function fromIntVector<T>(vector:IntVector):Vector<T>
	{
		return cast vector;
	}

	@:from private static inline function fromFloatVector<T>(vector:FloatVector):Vector<T>
	{
		return cast vector;
	}

	#if !cs
	@:from private static inline function fromFunctionVector<T:Function>(vector:FunctionVector):Vector<T>
	{
		return cast vector;
	}
	#end

	@:from private static inline function fromObjectVector<T>(vector:ObjectVector<T>):Vector<T>
	{
		return cast vector;
	}
	#end

	// Getters & Setters
	@:noCompletion private inline function get_fixed():Bool
	{
		return this.fixed;
	}

	@:noCompletion private inline function set_fixed(value:Bool):Bool
	{
		return this.fixed = value;
	}

	@:noCompletion private inline function get_length():Int
	{
		return this.length;
	}

	@:noCompletion private inline function set_length(value:Int):Int
	{
		return this.length = value;
	}
}

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:dox(hide) private class BoolVector implements IVector<Bool>
{
	public var fixed:Bool;
	public var length(get, set):Int;

	@:noCompletion private var __array:Array<Bool>;
	@:noCompletion private var __tempIndex:Int;

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

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion @:keep private function toJSON():Dynamic
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
	@:noCompletion private function get_length():Int
	{
		return __array.length;
	}

	@:noCompletion private function set_length(value:Int):Int
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

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:dox(hide) private class FloatVector implements IVector<Float>
{
	public var fixed:Bool;
	public var length(get, set):Int;

	@:noCompletion private var __array:Array<Float>;
	@:noCompletion private var __tempIndex:Int;

	@SuppressWarnings("checkstyle:Dynamic")
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

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion @:keep private function toJSON():Dynamic
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
	@:noCompletion private function get_length():Int
	{
		return __array.length;
	}

	@:noCompletion private function set_length(value:Int):Int
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

#if !cs
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:dox(hide) private class FunctionVector implements IVector<Function>
{
	public var fixed:Bool;
	public var length(get, set):Int;

	@:noCompletion private var __array:Array<Function>;
	@:noCompletion private var __tempIndex:Int;

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

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion @:keep private function toJSON():Dynamic
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
	@:noCompletion private function get_length():Int
	{
		return __array.length;
	}

	@:noCompletion private function set_length(value:Int):Int
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
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:dox(hide) private class IntVector implements IVector<Int>
{
	public var fixed:Bool;
	public var length(get, set):Int;

	@:noCompletion private var __array:Array<Int>;
	@:noCompletion private var __tempIndex:Int;

	public function new(length:Int = 0, fixed:Bool = false, array:Array<Int> = null):Void
	{
		if (array == null) array = new Array();
		__array = array;

		if (length > 0)
		{
			this.length = length;
		}

		this.fixed = fixed;
	}

	public function concat(a:IVector<Int> = null):IVector<Int>
	{
		if (a == null)
		{
			return new IntVector(0, false, __array.copy());
		}
		else
		{
			var other:IntVector = cast a;

			if (other.__array.length > 0)
			{
				return new IntVector(0, false, __array.concat(other.__array));
			}
			else
			{
				return new IntVector(0, false, __array.copy());
			}
		}
	}

	public function copy():IVector<Int>
	{
		return new IntVector(0, fixed, __array.copy());
	}

	public function filter(callback:Int->Bool):IVector<Int>
	{
		return new IntVector(0, fixed, __array.filter(callback));
	}

	public function get(index:Int):Int
	{
		return __array[index];
	}

	public function indexOf(x:Int, from:Int = 0):Int
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

	public function insertAt(index:Int, element:Int):Void
	{
		if (!fixed || index < __array.length)
		{
			__array.insert(index, element);
		}
	}

	public function iterator():Iterator<Int>
	{
		return cast __array.iterator();
	}

	public function join(sep:String = ","):String
	{
		return __array.join(sep);
	}

	public function lastIndexOf(x:Int, from:Null<Int> = null):Int
	{
		var i = (from == null || from >= __array.length) ? __array.length - 1 : from;

		while (i >= 0)
		{
			if (__array[i] == x) return i;
			i--;
		}

		return -1;
	}

	public function pop():Null<Int>
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

	public function push(x:Int):Int
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

	public function removeAt(index:Int):Int
	{
		if (!fixed || index < __array.length)
		{
			return __array.splice(index, 1)[0];
		}

		return 0;
	}

	public function reverse():IVector<Int>
	{
		__array.reverse();
		return this;
	}

	public function set(index:Int, value:Int):Int
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

	public function shift():Null<Int>
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

	public function slice(startIndex:Int = 0, endIndex:Null<Int> = null):IVector<Int>
	{
		if (endIndex == null) endIndex = 16777215;
		return new IntVector(0, false, __array.slice(startIndex, endIndex));
	}

	public function sort(f:Int->Int->Int):Void
	{
		__array.sort(f);
	}

	public function splice(pos:Int, len:Int):IVector<Int>
	{
		return new IntVector(0, false, __array.splice(pos, len));
	}

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion @:keep private function toJSON():Dynamic
	{
		return __array;
	}

	public function toString():String
	{
		return __array != null ? __array.toString() : null;
	}

	public function unshift(x:Int):Void
	{
		if (!fixed)
		{
			__array.unshift(x);
		}
	}

	// Getters & Setters
	@:noCompletion private function get_length():Int
	{
		return __array.length;
	}

	@:noCompletion private function set_length(value:Int):Int
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

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:dox(hide) private class ObjectVector<T> implements IVector<T>
{
	public var fixed:Bool;
	public var length(get, set):Int;

	@:noCompletion private var __array:Array<T>;
	@:noCompletion private var __tempIndex:Int;

	@SuppressWarnings("checkstyle:Dynamic")
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

	@SuppressWarnings("checkstyle:Dynamic")
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

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion @:keep private function toJSON():Dynamic
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
	@:noCompletion private function get_length():Int
	{
		return __array.length;
	}

	@:noCompletion private function set_length(value:Int):Int
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
#end

@SuppressWarnings("checkstyle:FieldDocComment")
@:noCompletion @:dox(hide) private interface IVector<T>
{
	public var fixed:Bool;
	public var length(get, set):Int;

	public function concat(vec:IVector<T> = null):IVector<T>;
	public function copy():IVector<T>;
	public function filter(callback:T->Bool):IVector<T>;
	public function get(index:Int):T;
	public function indexOf(x:T, from:Int = 0):Int;
	public function insertAt(index:Int, element:T):Void;
	public function iterator():Iterator<T>;
	public function join(sep:String = ","):String;
	public function lastIndexOf(x:T, from:Null<Int> = null):Int;
	public function pop():Null<T>;
	public function push(value:T):Int;
	public function removeAt(index:Int):T;
	public function reverse():IVector<T>;
	public function set(index:Int, value:T):T;
	public function shift():Null<T>;
	public function slice(startIndex:Int = 0, endIndex:Null<Int> = null):IVector<T>;
	public function sort(f:T->T->Int):Void;
	public function splice(pos:Int, len:Int):IVector<T>;
	public function toString():String;
	public function unshift(value:T):Void;

	@:noCompletion private var __tempIndex:Int;
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
abstract Vector<T>(VectorData<T>) from VectorData<T>
{
	public var fixed(get, set):Bool;
	public var length(get, set):Int;

	public function new(?length:Int, ?fixed:Bool, ?array:Array<T>):Void
	{
		if (array != null)
		{
			this = VectorData.ofArray(array);
		}
		else
		{
			this = new VectorData(length, fixed);
		}
	}

	public inline function concat(?a:Vector<T>):Vector<T>
	{
		// Duplicating behavior of VectorData in abstract, to allow
		// for Vector.<T> with ActionScript target -- it preserves
		// the correct behavior for Haxe libraries, even if only
		// a bare Array object is passed in

		// return cast this.concat (cast a);
		return VectorData.ofArray(untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.concat.call")(this, a));
	}

	public inline function copy():Vector<T>
	{
		// return cast this.copy ();
		return VectorData.ofArray(cast this);
	}

	public function filter(callback:T->Bool):Vector<T>
	{
		return VectorData.ofArray(untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.filter.call")(this, callback));
	}

	@:arrayAccess public inline function get(index:Int):T
	{
		// return this.get (index);
		return this[index];
	}

	public inline function indexOf(x:T, ?from:Int = 0):Int
	{
		// return this.indexOf (x, from);
		return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.indexOf.call")(this, x, from);
	}

	public function insertAt(index:Int, element:T):Void
	{
		// this.insertAt (index, element);
		if (!this.fixed || index < this.length)
		{
			untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.splice.call")(this, index, 0, element);
		}
	}

	public inline function iterator():Iterator<T>
	{
		// return this.iterator ();
		return new VectorIterator(this);
	}

	public inline function join(sep:String = ","):String
	{
		// return this.join (sep);
		return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.join.call")(this, sep);
	}

	public function lastIndexOf(x:T, ?from:Int):Int
	{
		// return this.lastIndexOf (x, from);
		if (from == null)
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.lastIndexOf.call")(this, x);
		}
		else
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.lastIndexOf.call")(this, x, from);
		}
	}

	public function pop():Null<T>
	{
		// return this.pop ();
		if (!fixed)
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.pop.call")(this);
		}
		else
		{
			return null;
		}
	}

	public function push(x:T):Int
	{
		// return this.push (x);
		if (!fixed)
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.push.call")(this, x);
		}
		else
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("this").length;
		}
	}

	public function removeAt(index:Int):T
	{
		// return this.removeAt (index);
		if (!this.fixed || index < this.length)
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.splice.call")(this, index, 1)[0];
		}

		return null;
	}

	public inline function reverse():Vector<T>
	{
		// return cast this.reverse ();
		return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.reverse.call")(this);
	}

	@:arrayAccess public function set(index:Int, value:T):T
	{
		// return this.set (index, value);
		if (!this.fixed || index < this.length)
		{
			return this[index] = value;
		}
		else
		{
			return value;
		}
	}

	public function shift():Null<T>
	{
		// return this.shift ();
		if (!this.fixed)
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.shift.call")(this);
		}
		else
		{
			return null;
		}
	}

	public inline function slice(startIndex:Int = 0, endIndex:Null<Int> = 16777215):Vector<T>
	{
		// return cast this.slice (pos, end);
		return VectorData.ofArray(untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.slice.call")(this, startIndex, endIndex));
	}

	public inline function sort(f:T->T->Int):Void
	{
		// this.sort (f);
		untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.sort.call")(this, f);
	}

	public inline function splice(pos:Int, len:Int):Vector<T>
	{
		// return cast this.splice (pos, len);
		return VectorData.ofArray(untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.splice.call")(this, pos, len));
	}

	public inline function toString():String
	{
		return (this != null) ? Std.string(this) : null;
	}

	public function unshift(x:T):Void
	{
		// this.unshift (x);
		if (!this.fixed)
		{
			untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.unshift.call")(this, x);
		}
	}

	public inline static function ofArray<T>(a:Array<T>):Vector<T>
	{
		return cast VectorData.ofArray(a);
	}

	public inline static function convert<T, U>(v:VectorData<T>):VectorData<U>
	{
		return cast v;
	}

	// Getters & Setters
	@:noCompletion private inline function get_fixed():Bool
	{
		return this.fixed;
	}

	@:noCompletion private inline function set_fixed(value:Bool):Bool
	{
		return this.fixed = value;
	}

	@:noCompletion private inline function get_length():Int
	{
		return this.length;
	}

	@:noCompletion private inline function set_length(value:Int):Int
	{
		return this.length = value;
	}
}

@SuppressWarnings("checkstyle:FieldDocComment")
@:keep class VectorData<T> implements ArrayAccess<T>
{
	public var fixed:Bool;
	public var length(get, set):Int;

	@:noCompletion private var __tempIndex:Int;

	@:noCompletion private static function __init__()
	{
		untyped #if haxe4 js.Syntax.code #else __js__ #end ("var prefix = (typeof openfl_VectorData !== 'undefined');
		var ref = (prefix ? openfl_VectorData : VectorData);
		var p = ref.prototype;
		var construct = p.construct;
		var _VectorDataDescriptor = {
			constructor: { value: null },
			concat: { value: p.concat },
			copy: { value: p.copy },
			filter: { value: p.filter },
			get: { value: p.get },
			insertAt: { value: p.insertAt },
			iterator: { value: p.iterator },
			lastIndexOf: { value: p.lastIndexOf },
			pop: { value: p.pop },
			push: { value: p.push },
			removeAt: { value: p.removeAt },
			set: { value: p.set },
			shift: { value: p.shift },
			slice: { value: p.slice },
			splice: { value: p.splice },
			unshift: { value: p.unshift },
			get_length: { value: p.get_length },
			set_length: { value: p.set_length },
		}
		var _VectorData = function (length, fixed, array) {
			if (array == null) array = [];
			return Object.defineProperties (construct (array, length, fixed), _VectorDataDescriptor);
		}
		_VectorDataDescriptor.constructor.value = _VectorData;
		_VectorData.__name__ = ref.__name__;
		_VectorData.ofArray = ref.ofArray;
		$hxClasses['openfl.VectorData'] = _VectorData;
		_VectorData.prototype = Array.prototype
		if (prefix) openfl_VectorData = _VectorData; else VectorData = _VectorData;
		");
	}

	public function new(?length:Int, ?fixed:Bool, ?array:VectorData<T>)
	{
		construct(this, length, fixed);
	}

	@:noCompletion private function construct(instance:Dynamic, ?length:Int, ?fixed:Bool)
	{
		if (length != null)
		{
			// for (i in 0...length) {

			// 	untyped #if haxe4 js.Syntax.code #else __js__ #end ("this")[i] = untyped #if haxe4 js.Syntax.code #else __js__ #end ("null");

			// }

			instance.length = length;
		}

		instance.fixed = (fixed == true);

		return instance;
	};

	public function concat(?a:Vector<T>):VectorData<T>
	{
		return VectorData.ofArray(untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.concat.call (this, a)"));
	}

	public function copy():VectorData<T>
	{
		return VectorData.ofArray(cast this);
	}

	public function filter(callback:T->Bool):Vector<T>
	{
		return VectorData.ofArray(untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.filter.call (this, callback)"));
	}

	public function get(index:Int):T
	{
		return untyped #if haxe4 js.Syntax.code #else __js__ #end ("this")[index];
	}

	public function indexOf(x:T, ?from:Int = 0):Int
	{
		return -1;
	}

	public function insertAt(index:Int, element:T):Void
	{
		if (!fixed || index < untyped #if haxe4 js.Syntax.code #else __js__ #end ("this").length)
		{
			untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.splice.call (this, index, 0, element)");
		}
	}

	public function iterator():Iterator<T>
	{
		return new VectorIterator(this);
	}

	public function join(sep:String = ","):String
	{
		return null;
	}

	public function lastIndexOf(x:T, ?from:Int):Int
	{
		if (from == null)
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.lastIndexOf.call (this, x)");
		}
		else
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.lastIndexOf.call (this, x, from)");
		}
	}

	public static function ofArray<T>(a:Array<Dynamic>):VectorData<T>
	{
		if (a == null) return null;

		var data = new VectorData<T>();
		for (i in 0...a.length)
		{
			// data[i] = untyped #if haxe4 js.Syntax.code #else __js__ #end ("a[i] === a[i] ? a[i] : null");
			data[i] = a[i];
		}
		return data;
	}

	public function pop():T
	{
		if (!fixed)
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.pop.call (this)");
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
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.push.call (this, x)");
		}
		else
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("this").length;
		}
	}

	public function removeAt(index:Int):T
	{
		if (!fixed || index < untyped #if haxe4 js.Syntax.code #else __js__ #end ("this").length)
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.splice.call (this, index, 1)")[0];
		}

		return null;
	}

	public function reverse():VectorData<T>
	{
		return this;
	}

	public function set(index:Int, value:T):T
	{
		if (!fixed || index < untyped #if haxe4 js.Syntax.code #else __js__ #end ("this").length)
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("this")[index] = value;
		}
		else
		{
			return value;
		}
	}

	public function shift():Null<T>
	{
		if (!fixed)
		{
			return untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.shift.call (this)");
		}
		else
		{
			return null;
		}
	}

	public function slice(startIndex:Int = 0, endIndex:Null<Int> = null):VectorData<T>
	{
		if (endIndex == null) endIndex = 16777215;
		return VectorData.ofArray(untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.slice.call (this, startIndex, endIndex)"));
	}

	public function sort(f:T->T->Int):Void {}

	public function splice(pos:Int, len:Int):VectorData<T>
	{
		return VectorData.ofArray(untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.splice.call (this, pos, len)"));
	}

	public function toString():String
	{
		return null;
	}

	public function unshift(x:T):Void
	{
		if (!fixed)
		{
			untyped #if haxe4 js.Syntax.code #else __js__ #end ("Array.prototype.unshift.call (this, x)");
		}
	}

	// Getters & Setters
	@:noCompletion private function get_length():Int
	{
		return untyped #if haxe4 js.Syntax.code #else __js__ #end ("this").length;
	}

	@:noCompletion private function set_length(value:Int):Int
	{
		if (!fixed)
		{
			untyped #if haxe4 js.Syntax.code #else __js__ #end ("this").length = value;

			// var current = untyped #if haxe4 js.Syntax.code #else __js__ #end ("this").length;

			// if (value < current) {

			// 	untyped #if haxe4 js.Syntax.code #else __js__ #end ("this.length = value");

			// } else {

			// 	for (i in current...value) {

			// 		untyped #if haxe4 js.Syntax.code #else __js__ #end ("this")[i] = untyped #if haxe4 js.Syntax.code #else __js__ #end ("null");

			// 	}

			// }
		}

		return value;
	}
}

// @:native("Array")
// extern class VectorData<T> implements ArrayAccess<T> {
// 	@:native("length") private var __length:Int;
// 	public function new ();
// 	// private static function __from (arrayLike:Dynamic, ?mapFn:Dynamic, ?thisArg:Dynamic):VectorData<Dynamic>;
// 	// private static function __isArray (obj:Dynamic):Bool;
// 	// private static function __of (?element0:Dynamic, ?element1:Dynamic, ?element2:Dynamic, ?element3:Dynamic):VectorData<Dynamic>;
// 	@:native("concat") private function __concat (?value0:Dynamic, ?value1:Dynamic, ?value2:Dynamic, ?value3:Dynamic):VectorData<Dynamic>;
// 	// private function __copyWithin (target:Int, ?start:Int, ?end:Int):VectorData<Dynamic>;
// 	// private function __entries ():Iterator<Dynamic>;
// 	// private function __every (callback:Dynamic, ?thisArg:Dynamic):Bool;
// 	// private function __fill (value:T, ?start:Int, ?end:Int):VectorData<Dynamic>;
// 	// private function __filter (callback:Dynamic, ?thisArg:Dynamic):VectorData<Dynamic>;
// 	// private function __find (callback:Dynamic, ?thisArg:Dynamic):Null<T>;
// 	// private function __findIndex (callback:Dynamic, ?thisArg:Dynamic):Int;
// 	// private function __forEach (callback:Dynamic, ?thisArg:Dynamic):Void;
// 	// private function __includes (searchElement:T, ?fromIndex:Int):Bool;
// 	public function indexOf (searchElement:T, ?fromIndex:Int):Int;
// 	public function join (?seperator:String):String;
// 	// @:native("keys") private function __keys ():Iterator<Dynamic>;
// 	public function lastIndexOf (searchElement:T, ?fromIndex:Int):Int;
// 	// private function __map (callback:Dynamic, ?thisArg:Dynamic):VectorData<Dynamic>;
// 	public function pop ():Null<T>;
// 	//@:native("push") private function __push (element0:T, ?element1:T, ?element2:T, ?element3:T):Int;
// 	public function push (x:T):Int;
// 	// private function __reduce (callback:Dynamic, ?initialValue:Dynamic):Dynamic;
// 	// private function __reduceRight (callback:Dynamic, ?initialValue:Dynamic):Dynamic;
// 	// @:native("reverse") private function __reverse ():VectorData<Dynamic>;
// 	public function shift ():Null<T>;
// 	// @:native("slice") private function __slice (?begin:Int, ?end:Int):VectorData<Dynamic>;
// 	// private function __some (callback:Dynamic, ?thisArg:Dynamic):Bool;
// 	// @:native("sort") private function __sort (compareFunction:Dynamic):VectorData<Dynamic>;
// 	@:native("splice") private function __splice (start:Int, ?deleteCount:Int, ?item0:T, ?item1:T, ?item2:T, ?item3:T):VectorData<Dynamic>;
// 	// private function __toLocaleString (?locales:String, ?options:Dynamic):String;
// 	public function toString ():String;
// 	// @:native("unshift") private function __unshift (element0:T, ?element1:T, ?element2:T, ?element3:T):Int;
// 	public function unshift (x:T):Void;
// 	@:native("values") private function __values ():Iterator<T>;
// }

@SuppressWarnings("checkstyle:FieldDocComment")
@:dox(hide) private class VectorIterator<T>
{
	@:noCompletion private var index:Int;
	@:noCompletion private var vector:Vector<T>;

	public function new(vector:Vector<T>)
	{
		this.vector = vector;
		index = -1;
	}

	public function hasNext():Bool
	{
		return index < vector.length - 1;
	}

	public function next():T
	{
		index++;
		return vector[index];
	}
}
#end
#else
@SuppressWarnings("checkstyle:FieldDocComment")
abstract Vector<T>(VectorData<T>)
{
	public var fixed(get, set):Bool;
	public var length(get, set):Int;

	public inline function new(?length:Int, ?fixed:Bool, ?array:Array<T>):Void
	{
		if (array != null)
		{
			this = VectorData.ofArray(array);
		}
		else
		{
			if (length == null)
			{
				length = 0;
			}
			if (fixed == null)
			{
				fixed = false;
			}
			this = new VectorData<T>(length, fixed);
		}
	}

	public inline function concat(?a:VectorData<T>):Vector<T>
	{
		if (a == null)
		{
			return this.concat();
		}
		else
		{
			return this.concat(a);
		}
	}

	public inline function copy():Vector<T>
	{
		var vec = new VectorData<T>(this.length, this.fixed);

		for (i in 0...this.length)
		{
			vec[i] = this[i];
		}

		return vec;
	}

	public inline function filter(callback:T->Bool):Vector<T>
	{
		var vec = new VectorData<T>();

		for (i in 0...this.length)
		{
			if (callback(this[i]))
			{
				vec.push(this[i]);
			}
		}

		return vec;
	}

	public inline function indexOf(x:T, from:Int = 0):Int
	{
		return this.indexOf(x, from);
	}

	public function insertAt(index:Int, element:T):Void
	{
		#if flash19
		this.insertAt(index, element);
		#else
		Reflect.callMethod(this.splice, this.splice, [index, 0, element]);
		#end
	}

	public inline function iterator():Iterator<T>
	{
		return new VectorDataIterator<T>(this);
	}

	public inline function join(sep:String = ","):String
	{
		return this.join(sep);
	}

	public inline function lastIndexOf(x:T, from:Int = 0x7fffffff):Int
	{
		return this.lastIndexOf(x, from);
	}

	public inline function pop():Null<T>
	{
		return this.pop();
	}

	public inline function push(x:T):Int
	{
		return this.push(x);
	}

	public function removeAt(index:Int):T
	{
		#if flash19
		return this.removeAt(index);
		#else
		return Reflect.callMethod(this.splice, this.splice, [index, 1])[0];
		#end
	}

	public inline function reverse():Vector<T>
	{
		return this.reverse();
	}

	public inline function shift():Null<T>
	{
		return this.shift();
	}

	public inline function slice(pos:Int = 0, end:Null<Int> = 16777215):Vector<T>
	{
		return this.slice(pos, end);
	}

	public inline function sort(f:T->T->Int):Void
	{
		this.sort(f);
	}

	public inline function splice(pos:Int, len:Int):Vector<T>
	{
		return this.splice(pos, len);
	}

	public inline function toString():String
	{
		return this != null ? "[" + this.toString() + "]" : null;
	}

	public inline function unshift(x:T):Void
	{
		this.unshift(x);
	}

	public inline static function ofArray<T>(a:Array<Dynamic>):Vector<T>
	{
		return VectorData.ofArray(a);
	}

	public inline static function convert<T, U>(v:Vector<T>):Vector<U>
	{
		return cast VectorData.convert(v);
	}

	@:noCompletion @:dox(hide) @:arrayAccess public inline function get(index:Int):Null<T>
	{
		return this[index];
	}

	@:noCompletion @:dox(hide) @:arrayAccess public inline function set(index:Int, value:T):T
	{
		return this[index] = value;
	}

	@:noCompletion @:dox(hide) @:from public static inline function fromHaxeVector<T>(value:haxe.ds.Vector<T>):Vector<T>
	{
		return cast value;
	}

	@:noCompletion @:dox(hide) @:to public inline function toHaxeVector<T>():haxe.ds.Vector<T>
	{
		return cast this;
	}

	@:noCompletion @:dox(hide) @:from public static inline function fromVectorData<T>(value:VectorData<T>):Vector<T>
	{
		return cast value;
	}

	@:noCompletion @:dox(hide) @:to public inline function toVectorData<T>():VectorData<T>
	{
		return cast this;
	}

	// Getters & Setters
	@:noCompletion private inline function get_fixed():Bool
	{
		return this.fixed;
	}

	@:noCompletion private inline function set_fixed(value:Bool):Bool
	{
		return this.fixed = value;
	}

	@:noCompletion private inline function get_length():Int
	{
		return this.length;
	}

	@:noCompletion private inline function set_length(value:Int):Int
	{
		return this.length = value;
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:dox(hide) private class VectorDataIterator<T>
{
	@:noCompletion private var index:Int;
	@:noCompletion private var vectorData:VectorData<T>;

	public function new(data:VectorData<T>)
	{
		index = 0;
		vectorData = data;
	}

	public function hasNext():Bool
	{
		return index < vectorData.length;
	}

	public function next():T
	{
		return vectorData[index++];
	}
}

private typedef VectorData<T> = flash.Vector<T>;
#end
