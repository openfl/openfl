declare namespace openfl
{
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
		declared with the Vector.<number> data type. The base types must match exactly. For
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
	export class Vector<T> extends Array<T>
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
		public fixed: boolean;

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
		public length: number;

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
			var v:Vector.<number> = new <number>[0,1,2,];
			```

			The following information applies to this syntax:

			* It is supported in Flash Professional CS5 and later, Flash Builder 4 and later,
			and Flex 4 and later.
			* The trailing comma is optional.
			* Empty items in the array are not supported; a statement such as
			`var v:Vector.<number> = new <number>[0,,2,]` throws a compiler error.
			* You can't specify a default length for the Vector instance. Instead, the length
			is the same as the number of elements in the initialization list.
			* You can't specify whether the Vector instance has a fixed length. Instead, use
			the fixed property.
			* Data loss or errors can occur if items passed as values don't match the
			specified type. For example:

			```as3
			var v:Vector.<number> = new <number>[4.2]; // compiler error when running in strict mode
			trace(v[0]); //returns 4 when not running in strict mode
			```

			@param	length	The initial length (number of elements) of the Vector. If this
			parameter is greater than zero, the specified number of Vector elements are
			created and populated with the default value appropriate to the base type
			(`null` for reference types).
			@param	fixed	Whether the Vector's length is fixed (`true`) or can be changed
			(`false`). This value can also be set using the fixed property.
		**/
		public constructor(length?: number, fixed?: boolean);

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
		public concat(vec?: Vector<T>): Vector<T>;

		/**
			Creates a new shallow clone of the current Vector object
			@return	A new Vector object
		**/
		public copy(): Vector<T>;

		/**
			Executes a test function on each item in the Vector and returns a new Vector
			containing all items that return true for the specified function. If an item
			returns false, it is not included in the result Vector. The base type of the return
			Vector matches the base type of the Vector on which the method is called.
			@param	callback	The function to run on each item in the Vector.
		**/
		public filter(callback): Vector<T>;

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
		public indexOf(searchElement: T, fromIndex?: number): number;

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
		public insertAt(index: number, element: T): void;

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
		public join(sep?: string): string;

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
		public lastIndexOf(searchElement: T, fromIndex?: null | number): number;

		/**
			Removes the last element from the Vector and returns that element. The `length`
			property of the Vector is decreased by one when this function is called.
			@return	The value of the last element in the specified Vector.
			@throws	RangeError	If this method is called while `fixed` is `true`.
		**/
		public pop(): null | T;

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
		public push(value: T): number;

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
		public removeAt(index: number): T;

		/**
			Reverses the order of the elements in the Vector. This method alters the Vector
			on which it is called.

			@return	The Vector with the elements in reverse order.
		**/
		public reverse(): Vector<T>;

		/**
			Removes the first element from the Vector and returns that element. The
			remaining Vector elements are moved from their original position, i, to i - 1.

			@return	The first element in the Vector.
			@throws	RangeError	If `fixed` is `true`.
		**/
		public shift(): null | T;

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
		public slice(startIndex?: number, endIndex?: null | number): Vector<T>;

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
		public sort(sortBehavior: (a: T, b: T) => number): this;

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
		public splice(startIndex: number, deleteCount: number): Vector<T>;

		/**
			Returns a string that represents the elements in the Vector. Every element in the
			Vector, starting with index 0 and ending with the highest index, is converted to
			a concatenated string and separated by commas. To specify a custom separator,
			use the `Vector.join()` method.

			@return	A string of Vector elements.
		**/
		public toString(): string;

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
		public unshift(...values: T[]): number;

		/**
			Creates a new Vector object using the values from an Array object
			@param	array	An Array object
			@return	A new Vector object
		**/
		public static ofArray<T>(array: Array<T>): Vector<T>;
	}
}

export default openfl.Vector;
