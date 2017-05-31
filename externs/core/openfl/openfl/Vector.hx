package openfl; #if (!flash || display)


import haxe.Constraints.Function;
import openfl.utils.ByteArray;

@:multiType(T)


abstract Vector<T>(IVector<T>) {
	
	
	public var fixed (get, set):Bool;
	public var length (get, set):Int;
	
	
	public function new (?length:Int, ?fixed:Bool /*, ?array:Array<Dynamic>*/):Void;
	
	
	public inline function concat (?a:Vector<T>):Vector<T> {
		
		return cast this.concat (cast a);
		
	}
	
	
	public inline function copy ():Vector<T> {
		
		return cast this.copy ();
		
	}
	
	
	@:arrayAccess public inline function get (index:Int):T {
		
		return this.get (index);
		
	}
	
	
	public inline function indexOf (x:T, ?from:Int = 0):Int {
		
		return this.indexOf (x, from);
		
	}
	
	
	public inline function insertAt (index:Int, element:T):Void {
		
		this.insertAt (index, element);
		
	}
	
	
	public inline function iterator<T> ():Iterator<T> {
		
		return this.iterator ();
		
	}
	
	
	public inline function join (sep:String):String {
		
		return this.join (sep);
		
	}
	
	
	public inline function lastIndexOf (x:T, ?from:Int = 0):Int {
		
		return this.lastIndexOf (x, from);
		
	}
	
	
	public inline function pop ():Null<T> {
		
		return this.pop ();
		
	}
	
	
	public inline function push (x:T):Int {
		
		return this.push (x);
		
	}
	
	
	public inline function reverse ():Vector<T> {
		
		return cast this.reverse ();
		
	}
	
	
	@:arrayAccess public inline function set (index:Int, value:T):T {
		
		return this.set (index, value);
		
	}
	
	
	public inline function shift ():Null<T> {
		
		return this.shift ();
		
	}
	
	
	public inline function slice (?pos:Int, ?end:Int):Vector<T> {
		
		return cast this.slice (pos, end);
		
	}
	
	
	public inline function sort (f:T->T->Int):Void {
		
		this.sort (f);
		
	}
	
	
	public inline function splice (pos:Int, len:Int):Vector<T> {
		
		return cast this.splice (pos, len);
		
	}
	
	
	public inline function toString ():String {
		
		return this != null ? this.toString () : null;
		
	}
	
	
	public inline function unshift (x:T):Void {
		
		this.unshift (x);
		
	}
	
	
	public inline static function ofArray<T> (a:Array<T>):Vector<T> {
		
		var vector = new Vector<T> ();
		
		for (i in 0...a.length) {
			
			vector[i] = cast a[i];
			
		}
		
		return vector;
		
	}
	
	
	public inline static function convert<T,U> (v:IVector<T>):IVector<U> {
		
		return cast v;
		
	}
	
	
	@:to static #if (!js && !flash) inline #end function toBoolVector<T:Bool> (t:IVector<T>, length:Int, fixed:Bool /*, array:Array<Dynamic>*/):BoolVector {
		
		return new BoolVector (length, fixed /*, cast array*/);
		
	}
	
	
	@:to static #if (!js && !flash) inline #end function toIntVector<T:Int> (t:IVector<T>, length:Int, fixed:Bool /*, array:Array<Dynamic>*/):IntVector {
		
		return new IntVector (length, fixed /*, cast array*/);
		
	}
	
	
	@:to static #if (!js && !flash) inline #end function toFloatVector<T:Float> (t:IVector<T>, length:Int, fixed:Bool /*, array:Array<Dynamic>*/):FloatVector {
		
		return new FloatVector (length, fixed /*, cast array*/);
		
	}
	
	
	#if !cs
	@:to static #if (!js && !flash) inline #end function toFunctionVector<T:Function> (t:IVector<T>, length:Int, fixed:Bool /*, array:Array<Dynamic>*/):FunctionVector {
		
		return new FunctionVector (length, fixed /*, cast array*/);
		
	}
	#end
	
	
	@:to static #if (!js && !flash) inline #end function toObjectVector<T> (t:IVector<T>, length:Int, fixed:Bool /*, array:Array<Dynamic>*/):ObjectVector<T> {
		
		return new ObjectVector<T> (length, fixed /*, cast array*/);
		
	}
	
	
	@:from static inline function fromBoolVector<T> (vector:BoolVector):Vector<T> {
		
		return cast vector;
		
	}
	
	
	@:from static inline function fromIntVector<T> (vector:IntVector):Vector<T> {
		
		return cast vector;
		
	}
	
	
	@:from static inline function fromFloatVector<T> (vector:FloatVector):Vector<T> {
		
		return cast vector;
		
	}
	
	
	#if !cs
	@:from static inline function fromFunctionVector<T> (vector:FunctionVector):Vector<T> {
		
		return cast vector;
		
	}
	#end
	
	
	@:from static inline function fromObjectVector<T> (vector:ObjectVector<T>):Vector<T> {
		
		return cast vector;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private inline function get_fixed ():Bool {
		
		return this.fixed;
		
	}
	
	
	@:noCompletion private inline function set_fixed (value:Bool):Bool {
		
		return this.fixed = value;
		
	}
	
	
	@:noCompletion private inline function get_length ():Int {
		
		return this.length;
		
	}
	
	
	@:noCompletion private inline function set_length (value:Int):Int {
		
		return this.length = value;
		
	}
	
	
}




#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:dox(hide) private class BoolVector implements IVector<Bool> {
	
	
	public var fixed:Bool;
	public var length (get, set):Int;
	
	private var __array:Array<Bool>;
	
	
	public function new (?length:Int, ?fixed:Bool, ?array:Array<Bool>):Void {
		
		if (array == null) {
			
			array = new Array<Bool> ();
			
		}
		
		__array = array;
		
		if (length != null) {
			
			this.length = length;
			
		}
		
		this.fixed = (fixed == true);
		
	}
	
	
	public function concat (?a:IVector<Bool>):IVector<Bool> {
		
		if (a == null) {
			
			return new BoolVector (__array.copy ());
			
		} else {
			
			return new BoolVector (__array.concat (cast (a, BoolVector).__array));
			
		}
		
	}
	
	
	public function copy ():IVector<Bool> {
		
		return new BoolVector (fixed, __array.copy ());
		
	}
	
	
	public function get (index:Int):Bool {
		
		if (index >= __array.length) {
			
			return false;
			
		} else {
			
			return __array[index];
			
		}
		
	}
	
	
	public function indexOf (x:Bool, ?from:Int = 0):Int {
		
		for (i in from...__array.length) {
			
			if (__array[i] == x) {
				
				return i;
				
			}
			
		}
		
		return -1;
		
	}
	
	
	public function insertAt (index:Int, element:Bool):Void {
		
		if (!fixed || index < __array.length) {
			
			__array.insert (index, element);
			
		}
		
	}
	
	
	public function iterator<Bool> ():Iterator<Bool> {
		
		return cast __array.iterator ();
		
	}
	
	
	public function join (sep:String):String {
		
		return __array.join (sep);
		
	}
	
	
	public function lastIndexOf (x:Bool, ?from:Int = 0):Int {
		
		var i = __array.length - 1;
		
		while (i >= from) {
			
			if (__array[i] == x) return i;
			i--;
			
		}
		
		return -1;
		
	}
	
	
	public function pop ():Null<Bool> {
		
		if (!fixed) {
			
			return __array.pop ();
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public function push (x:Bool):Int {
		
		if (!fixed) {
			
			return __array.push (x);
			
		} else {
			
			return __array.length;
			
		}
		
	}
	
	
	public function reverse ():IVector<Bool> {
		
		__array.reverse ();
		return this;
		
	}
	
	
	public function set (index:Int, value:Bool):Bool {
		
		if (!fixed || index < __array.length) {
			
			return __array[index] = value;
			
		} else {
			
			return value;
			
		}
		
	}
	
	
	public function shift ():Null<Bool> {
		
		if (!fixed) {
			
			return __array.shift ();
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public function slice (?startIndex:Int = 0, ?endIndex:Int = 16777215):IVector<Bool> {
		
		return new BoolVector (__array.slice (startIndex, endIndex));
		
	}
	
	
	public function sort (f:Bool->Bool->Int):Void {
		
		__array.sort (f);
		
	}
	
	
	public function splice (pos:Int, len:Int):IVector<Bool> {
		
		return new BoolVector (__array.splice (pos, len));
		
	}
	
	
	public function toString ():String {
		
		return __array != null ? __array.toString () : null;
		
	}
	
	
	public function unshift (x:Bool):Void {
		
		if (!fixed) {
			
			__array.unshift (x);
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_length ():Int {
		
		return __array.length;
		
	}
	
	
	@:noCompletion private function set_length (value:Int):Int {
		
		if (!fixed) {
			
			#if cpp
			
			cpp.NativeArray.setSize (__array, value);
			
			#else
			
			var currentLength = __array.length;
			if (value < 0) value = 0;
			
			if (value > currentLength) {
				
				for (i in currentLength...value) {
					
					__array[i] = false;
					
				}
				
			} else {
				
				while (__array.length > value) {
					
					__array.pop ();
					
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


@:dox(hide) private class FloatVector implements IVector<Float> {
	
	
	public var fixed:Bool;
	public var length (get, set):Int;
	
	private var __array:Array<Float>;
	
	
	public function new (?length:Int, ?fixed:Bool, ?array:Array<Float>):Void {
		
		if (array == null) {
			
			array = new Array<Float> ();
			
		}
		
		__array = array;
		
		if (length != null) {
			
			this.length = length;
			
		}
		
		this.fixed = (fixed == true);
		
	}
	
	
	public function concat (?a:IVector<Float>):IVector<Float> {
		
		if (a == null) {
			
			return new FloatVector (__array.copy ());
			
		} else {
			
			return new FloatVector (__array.concat (cast (a, FloatVector).__array));
			
		}
		
	}
	
	
	public function copy ():IVector<Float> {
		
		return new FloatVector (fixed, __array.copy ());
		
	}
	
	
	public function get (index:Int):Float {
		
		return __array[index];
		
	}
	
	
	public function indexOf (x:Float, ?from:Int = 0):Int {
		
		for (i in from...__array.length) {
			
			if (__array[i] == x) {
				
				return i;
				
			}
			
		}
		
		return -1;
		
	}
	
	
	public function insertAt (index:Int, element:Float):Void {
		
		if (!fixed || index < __array.length) {
			
			__array.insert (index, element);
			
		}
		
	}
	
	
	public function iterator<Float> ():Iterator<Float> {
		
		return cast __array.iterator ();
		
	}
	
	
	public function join (sep:String):String {
		
		return __array.join (sep);
		
	}
	
	
	public function lastIndexOf (x:Float, ?from:Int = 0):Int {
		
		var i = __array.length - 1;
		
		while (i >= from) {
			
			if (__array[i] == x) return i;
			i--;
			
		}
		
		return -1;
		
	}
	
	
	public function pop ():Null<Float> {
		
		if (!fixed) {
			
			return __array.pop ();
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public function push (x:Float):Int {
		
		if (!fixed) {
			
			return __array.push (x);
			
		} else {
			
			return __array.length;
			
		}
		
	}
	
	
	public function reverse ():IVector<Float> {
		
		__array.reverse ();
		return this;
		
	}
	
	
	public function set (index:Int, value:Float):Float {
		
		if (!fixed || index < __array.length) {
			
			return __array[index] = value;
			
		} else {
			
			return value;
			
		}
		
	}
	
	
	public function shift ():Null<Float> {
		
		if (!fixed) {
			
			return __array.shift ();
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public function slice (?startIndex:Int = 0, ?endIndex:Int = 16777215):IVector<Float> {
		
		return new FloatVector (__array.slice (startIndex, endIndex));
		
	}
	
	
	public function sort (f:Float->Float->Int):Void {
		
		__array.sort (f);
		
	}
	
	
	public function splice (pos:Int, len:Int):IVector<Float> {
		
		return new FloatVector (__array.splice (pos, len));
		
	}
	
	
	public function toString ():String {
		
		return __array != null ? __array.toString () : null;
		
	}
	
	
	public function unshift (x:Float):Void {
		
		if (!fixed) {
			
			__array.unshift (x);
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_length ():Int {
		
		return __array.length;
		
	}
	
	
	@:noCompletion private function set_length (value:Int):Int {
		
		if (!fixed) {
			
			#if cpp
			
			cpp.NativeArray.setSize (__array, value);
			
			#else
			
			var currentLength = __array.length;
			if (value < 0) value = 0;
			
			if (value > currentLength) {
				
				for (i in currentLength...value) {
					
					__array[i] = 0;
					
				}
				
			} else {
				
				while (__array.length > value) {
					
					__array.pop ();
					
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


@:dox(hide) private class FunctionVector implements IVector<Function> {
	
	
	public var fixed:Bool;
	public var length (get, set):Int;
	
	private var __array:Array<Function>;
	
	
	public function new (?length:Int, ?fixed:Bool, ?array:Array<Function>):Void {
		
		if (array == null) {
			
			array = new Array<Function> ();
			
		}
		
		__array = array;
		
		if (length != null) {
			
			this.length = length;
			
		}
		
		this.fixed = (fixed == true);
		
	}
	
	
	public function concat (?a:IVector<Function>):IVector<Function> {
		
		if (a == null) {
			
			return new FunctionVector (__array.copy ());
			
		} else {
			
			return new FunctionVector (__array.concat (cast (a, FunctionVector).__array));
			
		}
		
	}
	
	
	public function copy ():IVector<Function> {
		
		return new FunctionVector (fixed, __array.copy ());
		
	}
	
	
	public function get (index:Int):Function {
		
		if (index >= __array.length) {
			
			return null;
			
		} else {
			
			return __array[index];
			
		}
		
	}
	
	
	public function indexOf (x:Function, ?from:Int = 0):Int {
		
		for (i in from...__array.length) {
			
			if (Reflect.compareMethods (__array[i], x)) {
				
				return i;
				
			}
			
		}
		
		return -1;
		
	}
	
	
	public function insertAt (index:Int, element:Function):Void {
		
		if (!fixed || index < __array.length) {
			
			__array.insert (index, element);
			
		}
		
	}
	
	
	public function iterator<Function> ():Iterator<Function> {
		
		return cast __array.iterator ();
		
	}
	
	
	public function join (sep:String):String {
		
		return __array.join (sep);
		
	}
	
	
	public function lastIndexOf (x:Function, ?from:Int = 0):Int {
		
		var i = __array.length - 1;
		
		while (i >= from) {
			
			if (Reflect.compareMethods (__array[i], x)) return i;
			i--;
			
		}
		
		return -1;
		
	}
	
	
	public function pop ():Function {
		
		if (!fixed) {
			
			return __array.pop ();
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public function push (x:Function):Int {
		
		if (!fixed) {
			
			return __array.push (x);
			
		} else {
			
			return __array.length;
			
		}
		
	}
	
	
	public function reverse ():IVector<Function> {
		
		__array.reverse ();
		return this;
		
	}
	
	
	public function set (index:Int, value:Function):Function {
		
		if (!fixed || index < __array.length) {
			
			return __array[index] = value;
			
		} else {
			
			return value;
			
		}
		
	}
	
	
	public function shift ():Function {
		
		if (!fixed) {
			
			return __array.shift ();
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public function slice (?startIndex:Int = 0, ?endIndex:Int = 16777215):IVector<Function> {
		
		return new FunctionVector (__array.slice (startIndex, endIndex));
		
	}
	
	
	public function sort (f:Function->Function->Int):Void {
		
		__array.sort (f);
		
	}
	
	
	public function splice (pos:Int, len:Int):IVector<Function> {
		
		return new FunctionVector (__array.splice (pos, len));
		
	}
	
	
	public function toString ():String {
		
		return __array != null ? __array.toString () : null;
		
	}
	
	
	public function unshift (x:Function):Void {
		
		if (!fixed) {
			
			__array.unshift (x);
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_length ():Int {
		
		return __array.length;
		
	}
	
	
	@:noCompletion private function set_length (value:Int):Int {
		
		if (!fixed) {
			
			#if cpp
			
			cpp.NativeArray.setSize (__array, value);
			
			#else
			
			var currentLength = __array.length;
			if (value < 0) value = 0;
			
			if (value > currentLength) {
				
				for (i in currentLength...value) {
					
					__array[i] = null;
					
				}
				
			} else {
				
				while (__array.length > value) {
					
					__array.pop ();
					
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


@:dox(hide) private class IntVector implements IVector<Int> {
	
	
	public var fixed:Bool;
	public var length (get, set):Int;
	
	private var __array:Array<Int>;
	
	
	public function new (?length:Int, ?fixed:Bool, ?array:Array<Int>):Void {
		
		if (array == null) {
			
			array = new Array<Int> ();
			
		}
		
		__array = array;
		
		if (length != null) {
			
			this.length = length;
			
		}
		
		this.fixed = (fixed == true);
		
	}
	
	
	public function concat (?a:IVector<Int>):IVector<Int> {
		
		if (a == null) {
			
			return new IntVector (__array.copy ());
			
		} else {
			
			return new IntVector (__array.concat (cast (a, IntVector).__array));
			
		}
		
	}
	
	
	public function copy ():IVector<Int> {
		
		return new IntVector (fixed, __array.copy ());
		
	}
	
	
	public function get (index:Int):Int {
		
		return __array[index];
		
	}
	
	
	public function indexOf (x:Int, ?from:Int = 0):Int {
		
		for (i in from...__array.length) {
			
			if (__array[i] == x) {
				
				return i;
				
			}
			
		}
		
		return -1;
		
	}
	
	
	public function insertAt (index:Int, element:Int):Void {
		
		if (!fixed || index < __array.length) {
			
			__array.insert (index, element);
			
		}
		
	}
	
	
	public function iterator<Int> ():Iterator<Int> {
		
		return cast __array.iterator ();
		
	}
	
	
	public function join (sep:String):String {
		
		return __array.join (sep);
		
	}
	
	
	public function lastIndexOf (x:Int, ?from:Int = 0):Int {
		
		var i = __array.length - 1;
		
		while (i >= from) {
			
			if (__array[i] == x) return i;
			i--;
			
		}
		
		return -1;
		
	}
	
	
	public function pop ():Null<Int> {
		
		if (!fixed) {
			
			return __array.pop ();
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public function push (x:Int):Int {
		
		if (!fixed) {
			
			return __array.push (x);
			
		} else {
			
			return __array.length;
			
		}
		
	}
	
	
	public function reverse ():IVector<Int> {
		
		__array.reverse ();
		return this;
		
	}
	
	
	public function set (index:Int, value:Int):Int {
		
		if (!fixed || index < __array.length) {
			
			return __array[index] = value;
			
		} else {
			
			return value;
			
		}
		
	}
	
	
	public function shift ():Null<Int> {
		
		if (!fixed) {
			
			return __array.shift ();
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public function slice (?startIndex:Int = 0, ?endIndex:Int = 16777215):IVector<Int> {
		
		return new IntVector (__array.slice (startIndex, endIndex));
		
	}
	
	
	public function sort (f:Int->Int->Int):Void {
		
		__array.sort (f);
		
	}
	
	
	public function splice (pos:Int, len:Int):IVector<Int> {
		
		return new IntVector (__array.splice (pos, len));
		
	}
	
	
	public function toString ():String {
		
		return __array != null ? __array.toString () : null;
		
	}
	
	
	public function unshift (x:Int):Void {
		
		if (!fixed) {
			
			__array.unshift (x);
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_length ():Int {
		
		return __array.length;
		
	}
	
	
	@:noCompletion private function set_length (value:Int):Int {
		
		if (!fixed) {
			
			#if cpp
			
			cpp.NativeArray.setSize (__array, value);
			
			#else
			
			var currentLength = __array.length;
			if (value < 0) value = 0;
			
			if (value > currentLength) {
				
				for (i in currentLength...value) {
					
					__array[i] = 0;
					
				}
				
			} else {
				
				while (__array.length > value) {
					
					__array.pop ();
					
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


@:dox(hide) private class ObjectVector<T> implements IVector<T> {
	
	
	public var fixed:Bool;
	public var length (get, set):Int;
	
	private var __array:Array<T>;
	
	
	public function new (?length:Int, ?fixed:Bool, ?array:Array<T>):Void {
		
		if (array == null) {
			
			array = new Array<T> ();
			
		}
		
		__array = array;
		
		if (length != null) {
			
			this.length = length;
			
		}
		
		this.fixed = (fixed == true);
		
	}
	
	
	public function concat (?a:IVector<T>):IVector<T> {
		
		if (a == null) {
			
			return new ObjectVector (__array.copy ());
			
		} else {
			
			return new ObjectVector (__array.concat (cast (cast (a, ObjectVector<Dynamic>).__array)));
			
		}
		
	}
	
	
	public function copy ():IVector<T> {
		
		return new ObjectVector (__array.copy ());
		
	}
	
	
	public function get (index:Int):T {
		
		return __array[index];
		
	}
	
	
	public function indexOf (x:T, ?from:Int = 0):Int {
		
		for (i in from...__array.length) {
			
			if (__array[i] == x) {
				
				return i;
				
			}
			
		}
		
		return -1;
		
	}
	
	
	public function insertAt (index:Int, element:T):Void {
		
		if (!fixed || index < __array.length) {
			
			__array.insert (index, element);
			
		}
		
	}
	
	
	public function iterator<T> ():Iterator<T> {
		
		return cast __array.iterator ();
		
	}
	
	
	public function join (sep:String):String {
		
		return __array.join (sep);
		
	}
	
	
	public function lastIndexOf (x:T, ?from:Int = 0):Int {
		
		var i = __array.length - 1;
		
		while (i >= from) {
			
			if (__array[i] == x) return i;
			i--;
			
		}
		
		return -1;
		
	}
	
	
	public function pop ():T {
		
		if (!fixed) {
			
			return __array.pop ();
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public function push (x:T):Int {
		
		if (!fixed) {
			
			return __array.push (x);
			
		} else {
			
			return __array.length;
			
		}
		
	}
	
	
	public function reverse ():IVector<T> {
		
		__array.reverse ();
		return this;
		
	}
	
	
	public function set (index:Int, value:T):T {
		
		if (!fixed || index < __array.length) {
			
			return __array[index] = value;
			
		} else {
			
			return value;
			
		}
		
	}
	
	
	public function shift ():T {
		
		if (!fixed) {
			
			return __array.shift ();
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public function slice (?startIndex:Int = 0, ?endIndex:Int = 16777215):IVector<T> {
		
		return new ObjectVector (__array.slice (startIndex, endIndex));
		
	}
	
	
	public function sort (f:T->T->Int):Void {
		
		__array.sort (f);
		
	}
	
	
	public function splice (pos:Int, len:Int):IVector<T> {
		
		return new ObjectVector (__array.splice (pos, len));
		
	}
	
	
	public function toString ():String {
		
		return __array != null ? __array.toString () : null;
		
	}
	
	
	public function unshift (x:T):Void {
		
		if (!fixed) {
			
			__array.unshift (x);
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_length ():Int {
		
		return __array.length;
		
	}
	
	
	@:noCompletion private function set_length (value:Int):Int {
		
		if (!fixed) {
			
			#if cpp
			
			cpp.NativeArray.setSize (__array, value);
			
			#else
			
			var currentLength = __array.length;
			if (value < 0) value = 0;
			
			if (value > currentLength) {
				
				for (i in currentLength...value) {
					
					__array.push (null);
					
				}
				
			} else {
				
				while (__array.length > value) {
					
					__array.pop ();
					
				}
				
			}
			
			#end
			
		}
		
		return __array.length;
		
	}
	
	
}




@:dox(hide) private interface IVector<T> {
	
	public var fixed:Bool;
	public var length (get, set):Int;
	
	public function concat (?a:IVector<T>):IVector<T>;
	public function copy ():IVector<T>;
	public function get (index:Int):T;
	public function indexOf (x:T, ?from:Int = 0):Int;
	public function insertAt (index:Int, element:T):Void;
	public function iterator<T> ():Iterator<T>;
	public function join (sep:String):String;
	public function lastIndexOf (x:T, ?from:Int = 0):Int;
	public function pop ():Null<T>;
	public function push (x:T):Int;
	public function reverse ():IVector<T>;
	public function set (index:Int, value:T):T;
	public function shift ():Null<T>;
	public function slice (?pos:Int, ?end:Int):IVector<T>;
	public function sort (f:T -> T -> Int):Void;
	public function splice (pos:Int, len:Int):IVector<T>;
	public function toString ():String;
	public function unshift (x:T):Void;
	
}




#else




abstract Vector<T>(VectorData<T>) {
	
	
	public var fixed (get, set):Bool;
	public var length (get, set):Int;
	
	
	public inline function new (?length:Int, ?fixed:Bool, ?array:Array<T>):Void {
		
		if (array != null) {
			
			this = VectorData.ofArray (array);
			
		} else {
			
			this = new VectorData<T> (length, fixed);
			
		}
		
		
	}
	
	
	public inline function concat (?a:VectorData<T>):Vector<T> {
		
		if (a == null) {
			
			return this.concat ();
			
		} else {
			
			return this.concat (a);
			
		}
		
	}
	
	
	public inline function copy ():Vector<T> {
		
		var vec = new VectorData<T> (this.length, this.fixed);
		
		for (i in 0...this.length) {
			
			vec[i] = this[i];
			
		}
		
		return vec;
		
	}
	
	
	public inline function indexOf (x:T, from:Int = 0):Int {
		
		return this.indexOf (x, from);
		
	}
	
	
	public function insertAt (index:Int, element:T):Void {
		
		Reflect.callMethod (this.splice, this.splice, [ index, 0, element ]);
		//this.splice (index, 0, element);
		//this.insertAt (index, element);
		
	}
	
	
	public inline function iterator<T> ():Iterator<T> {
		
		return new VectorDataIterator<T> (this);
		
	}
	
	
	public inline function join (sep:String):String {
		
		return this.join (sep);
		
	}
	
	
	public inline function lastIndexOf (x:T, from:Int = 0x7fffffff):Int {
		
		return this.lastIndexOf (x, from);
		
	}
	
	
	public inline function pop ():Null<T> {
		
		return this.pop ();
		
	}
	
	
	public inline function push (x:T):Int {
		
		return this.push (x);
		
	}
	
	
	public inline function reverse ():Vector<T> {
		
		return this.reverse ();
		
	}
	
	
	public inline function shift ():Null<T> {
		
		return this.shift ();
		
	}
	
	
	public inline function slice (pos:Int = 0, end:Int = 16777215):Vector<T> {
		
		return this.slice (pos, end);
		
	}
	
	
	public inline function sort (f:T -> T -> Int):Void {
		
		this.sort (f);
		
	}
	
	
	public inline function splice (pos:Int, len:Int):Vector<T> {
		
		return this.splice (pos, len);
		
	}
	
	
	public inline function toString ():String {
		
		return this != null ? "[" + this.toString () + "]" : null;
		
	}
	
	
	public inline function unshift (x:T):Void {
		
		this.unshift (x);
		
	}
	
	
	public inline static function ofArray<T> (a:Array<Dynamic>):Vector<T> {
		
		return VectorData.ofArray (a);
		
	}
	
	
	public inline static function convert<T,U> (v:Vector<T>):Vector<U> {
		
		return cast VectorData.convert (v);
		
	}
	
	
	@:noCompletion @:dox(hide) @:arrayAccess public inline function get (index:Int):Null<T> {
		
		return this[index];
		
	}
	
	
	@:noCompletion @:dox(hide) @:arrayAccess public inline function set (index:Int, value:T):T {
		
		return this[index] = value;
		
	}
	
	
	/*@:noCompletion @:dox(hide) @:from public static inline function fromArray<T> (value:Array<T>):Vector<T> {
		
		return VectorData.ofArray (value);
		
	}
	
	
	@:noCompletion @:dox(hide) @:to public inline function toArray<T> ():Array<T> {
		
		var array = new Array<T> ();
		
		for (value in this) {
			
			array.push (value);
			
		}
		
		return array;
		
	}*/
	
	
	@:noCompletion @:dox(hide) @:from public static inline function fromHaxeVector<T> (value:haxe.ds.Vector<T>):Vector<T> {
		
		return cast value;
		
	}
	
	
	@:noCompletion @:dox(hide) @:to public inline function toHaxeVector<T> ():haxe.ds.Vector<T> {
		
		return cast this;
		
	}
	
	
	@:noCompletion @:dox(hide) @:from public static inline function fromVectorData<T> (value:VectorData<T>):Vector<T> {
		
		return cast value;
		
	}
	
	
	@:noCompletion @:dox(hide) @:to public inline function toVectorData<T> ():VectorData<T> {
		
		return cast this;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private inline function get_fixed ():Bool {
		
		return this.fixed;
		
	}
	
	
	@:noCompletion private inline function set_fixed (value:Bool):Bool {
		
		return this.fixed = value;
		
	}
	
	
	@:noCompletion private inline function get_length ():Int {
		
		return this.length;
		
	}
	
	
	@:noCompletion private inline function set_length (value:Int):Int {
		
		return this.length = value;
		
	}
	
	
}


@:dox(hide) private class VectorDataIterator<T> {
	
	
	private var index:Int;
	private var vectorData:VectorData<T>;
	
	
	public function new (data:VectorData<T>) {
		
		index = 0;
		vectorData = data;
		
	}
	
	
	public function hasNext ():Bool {
		
		return index < vectorData.length;
		
	}
	
	
	public function next ():T {
		
		return vectorData[index++];
		
	}
	
	
}


private typedef VectorData<T> = flash.Vector<T>;


#end