package openfl; #if (!flash || display)


// Haxe abstracts resolve to Dynamic types, which are slower on C++
// ...by using Array directly, instead of haxe.ds.Vector, we can eliminate
// some of this performance overhead, but not completely. Should probably
// switch to the haxe.ds.Vector type for every target when this is resolved

#if java

@:arrayAccess abstract Vector<T>(Array<T>) from Array<T> to Array<T> {
	
	
	public var length (get, set):Int;
	public var fixed (get, set):Bool;
	
	
	public function new (?length:Int, ?fixed:Bool):Void {
		
		this = new Array<T> ();
		
	}
	
	
	public function concat (?a:Array<T>):Vector<T> {
		
		return this.concat (a);
		
	}
	
	
	public function copy ():Vector<T> {
		
		return this.copy ();
		
	}
	
	
	public function iterator<T> ():Iterator<T> {
		
		return this.iterator ();
		
	}
	
	
	public function join (sep:String):String {
		
		return this.join (sep);
		
	}
	
	
	public inline function pop ():Null<T> {
		
		return this.pop ();
		
	}
	
	
	public inline function push (x:T):Int {
		
		return this.push (x);
		
	}
	
	
	public function reverse ():Void {
		
		this.reverse ();
		
	}
	
	
	public inline function shift ():Null<T> {
		
		return this.shift ();
		
	}
	
	
	public inline function unshift (x:T):Void {
		
		this.unshift (x);
		
	}
	
	
	public function slice (?pos:Int, ?end:Int):Vector<T> {
		
		return this.slice (pos, end);
		
	}
	
	
	public function sort (f:T -> T -> Int):Void {
		
		this.sort (f);
		
	}
	
	
	public function splice (pos:Int, len:Int):Vector<T> {
		
		return this.splice (pos, len);
		
	}
	
	
	public function toString ():String {
		
		return this.toString ();
		
	}
	
	
	public function indexOf (x:T, ?from:Int = 0):Int {
		
		for (i in from...this.length) {
			
			if (this[i] == x) {
				
				return i;
				
			}
			
		}
		
		return -1;
		
	}
	
	
	public function lastIndexOf (x:T, ?from:Int = 0):Int {
		
		var i = this.length - 1;
		
		while (i >= from) {
			
			if (this[i] == x) return i;
			i--;
			
		}
		
		return -1;
		
	}
	
	
	public inline static function ofArray<T> (a:Array<Dynamic>):Vector<T> {
		
		return new Vector<T> ().concat (cast a);
		
	}
	
	
	public inline static function convert<T,U> (v:Array<T>):Vector<U> {
		
		return cast v;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private inline function get_length ():Int {
		
		return this.length;
		
	}
	
	
	@:noCompletion private inline function set_length (value:Int):Int {
		
		return value;
		
	}
	
	
	@:noCompletion private inline function get_fixed ():Bool {
		
		return false;
		
	}
	
	
	@:noCompletion private inline function set_fixed (value:Bool):Bool {
		
		return value;
		
	}
	
	
}


typedef VectorData<T> = Array<T>;
typedef VectorDataIterator<T> = Iterator<T>;


#elseif (!cpp || display)


abstract Vector<T>(VectorData<T>) {
	
	
	public var length (get, set):Int;
	public var fixed (get, set):Bool;
	
	
	public inline function new (?length:Int = 0, ?fixed:Bool = false):Void {
		
		this = new VectorData<T> ();
		#if cpp
		this.data = new Array<T> ()
		untyped this.data.__SetSizeExact (length);
		#else
		this.data = new haxe.ds.Vector<T> (length);
		#end
		this.length = length;
		this.fixed = fixed;
		
	}
	
	
	public inline function concat (?a:VectorData<T>):Vector<T> {
		
		var vectorData = new VectorData<T> ();
		vectorData.length = (a != null) ? this.length + a.length : this.length;
		vectorData.fixed = false;
		
		#if cpp
		vectorData.data = this.data.slice (0, this.length).concat (a.data);
		#else
		vectorData.data = new haxe.ds.Vector<T> (vectorData.length);
		haxe.ds.Vector.blit (this.data, 0, vectorData.data, 0, this.length);
		if (a != null) {
			haxe.ds.Vector.blit (a.data, 0, vectorData.data, this.length, a.length);
		}
		#end
		
		return cast vectorData;
		
	}
	
	
	public inline function copy ():Vector<T> {
		
		var vectorData = new VectorData<T> ();
		vectorData.length = length;
		vectorData.fixed = fixed;
		#if cpp
		vectorData.data = this.data.copy ();
		#else
		vectorData.data = new haxe.ds.Vector<T> (length);
		haxe.ds.Vector.blit (this.data, 0, vectorData.data, 0, this.length);
		#end
		return cast vectorData;
		
	}
	
	
	public inline function iterator<T> ():Iterator<T> {
		
		return new VectorDataIterator<T> (this);
		
	}
	
	
	public inline function join (sep:String):String {
		
		var output = "";
		
		for (i in 0...this.length) {
			
			if (i > 0) output += sep;
			output += this.data[i];
			
		}
		
		return output;
		
	}
	
	
	public inline function pop ():Null<T> {
		
		var value = null;
		
		if (!this.fixed) {
			
			if (this.length > 0) {
				
				this.length--;
				value = this.data[this.length];
				
			}
			
		}
		
		return value;
		
	}
	
	
	public inline function push (x:T):Int {
		
		if (!this.fixed) {
			
			this.length++;
			
			if (this.data.length < this.length) {
				
				#if cpp
				untyped (this.data).__SetSizeExact (this.data.length + 10);
				#else
				var data = new haxe.ds.Vector<T> (this.data.length + 10);
				haxe.ds.Vector.blit (this.data, 0, data, 0, this.data.length);
				this.data = data;
				#end
				
			}
			
			this.data[this.length - 1] = x;
			
		}
		
		return this.length;
		
	}
	
	
	public inline function reverse ():Void {
		
		#if cpp
		untyped (this.data).__SetSizeExact (this.length);
		this.data.reverse ();
		#else
		var data = new haxe.ds.Vector<T> (this.length);
		for (i in 0...this.length) {
			data[this.length - 1 - i] = this.data[i];
		}
		this.data = data;
		#end

	}
	
	
	public inline function shift ():Null<T> {
		
		if (!this.fixed && this.length > 0) {
			
			this.length--;
			
			#if cpp
			return this.data.shift ();
			#else
			var value = this.data[0];
			haxe.ds.Vector.blit (this.data, 1, this.data, 0, this.length);
			return value;
			#end
			
		}
		
		return null;
		
	}
	
	
	public inline function unshift (x:T):Void {
		
		if (!this.fixed) {
			
			this.length++;
			
			if (this.data.length < this.length) {
				
				#if cpp
				untyped (this.data).__SetSizeExact (this.length + 10);
				#else
				var data = new haxe.ds.Vector<T> (this.length + 10);
				haxe.ds.Vector.blit (this.data, 0, data, 1, this.data.length);
				this.data = data;
				#end
				
			} else {
				
				#if !cpp
				haxe.ds.Vector.blit (this.data, 0, this.data, 1, this.length - 1);
				#end
				
			}
			
			#if cpp
			this.data.unshift (x);
			#else
			this.data[0] = x;
			#end
			
		}
		
	}
	
	
	public inline function slice (?pos:Int = 0, ?end:Int = 0):Vector<T> {
		
		if (pos < 0) pos += this.length;
		if (end <= 0) end += this.length;
		if (end > this.length) end = this.length;
		var length = end - pos;
		if (length <= 0 || length > this.length) length = this.length;
		
		var vectorData = new VectorData<T> ();
		vectorData.length = end - pos;
		vectorData.fixed = true;
		#if cpp
		vectorData.data = this.data.slice (pos, end);
		#else
		vectorData.data = new haxe.ds.Vector<T> (length);
		haxe.ds.Vector.blit (this.data, pos, vectorData.data, 0, length);
		#end
		return cast vectorData;
		
	}
	
	
	public inline function sort (f:T -> T -> Int):Void {
		
		#if cpp
		this.data.sort (f);
		#else
		var array = this.data.toArray ();
		array.sort (f);
		this.data = haxe.ds.Vector.fromArrayCopy (array);
		#end
		
	}
	
	
	public inline function splice (pos:Int, len:Int):Vector<T> {
		
		if (pos < 0) pos += this.length;
		if (pos + len > this.length) len = this.length - pos;
		if (len < 0) len = 0;
		
		var vectorData = new VectorData<T> ();
		vectorData.length = len;
		vectorData.fixed = false;
		
		#if cpp
		vectorData.data = this.data.splice (pos, len);
		#else
		vectorData.data = new haxe.ds.Vector<T> (len);
		haxe.ds.Vector.blit (this.data, pos, vectorData.data, 0, len);
		#end
		
		if (len > 0) {
			
			this.length -= len;
			#if !cpp
			haxe.ds.Vector.blit (this.data, pos + len, this.data, pos, this.length - pos);
			#end
			
		}
		
		return cast vectorData;
		//return this.splice (pos, len);
		
	}
	
	
	public inline function toString ():String {
		
		#if cpp
		return this.data.toString ();
		#else
		return this.data.toArray ().toString ();
		#end
		
	}
	
	
	public inline function indexOf (x:T, ?from:Int = 0):Int {
		
		var value = -1;
		
		for (i in from...this.length) {
			
			if (this.data[i] == x) {
				
				value = i;
				break;
				
			}
			
		}
		
		return value;
		
	}
	
	
	public inline function lastIndexOf (x:T, ?from:Int = 0):Int {
		
		var value = -1;
		var i = this.length - 1;
		
		while (i >= from) {
			
			if (this.data[i] == x) {
				
				value = i;
				break;
				
			}
			
			i--;
			
		}
		
		return value;
		
	}
	
	
	public inline static function ofArray<T> (a:Array<Dynamic>):Vector<T> {
		
		var vectorData = new VectorData<T> ();
		vectorData.length = a.length;
		vectorData.fixed = true;
		#if cpp
		vectorData.data = cast a.copy ();
		#else
		vectorData.data = haxe.ds.Vector.fromArrayCopy (a);
		#end
		return cast vectorData;
		
	}
	
	
	public inline static function convert<T,U> (v:Vector<T>):Vector<U> {
		
		return cast v;
		
	}
	
	
	@:noCompletion @:dox(hide) @:arrayAccess public inline function get (index:Int):Null<T> {
		
		return this.data[index];
		
	}
	
	
	@:noCompletion @:dox(hide) @:arrayAccess public inline function set (key:Int, value:T):T {
		
		if (!this.fixed) {
			
			if (key >= this.length) {
				this.length = key + 1;
			}
			
			if (this.data.length < this.length) {
				
				var data = new haxe.ds.Vector<T> (this.data.length + 10);
				haxe.ds.Vector.blit (cast this.data, 0, data, 0, this.data.length);
				this.data = cast data;
				
			}
			
		}
		
		return this.data[key] = value;
		
	}
	
	
	@:noCompletion @:dox(hide) @:from public static inline function fromArray<T> (value:Array<T>):Vector<T> {
		
		var vectorData = new VectorData<T> ();
		vectorData.length = value.length;
		vectorData.fixed = true;
		#if cpp
		vectorData.data = value.copy ();
		#else
		vectorData.data = haxe.ds.Vector.fromArrayCopy (value);
		#end
		return cast vectorData;
		
	}
	
	
	@:noCompletion @:dox(hide) @:to public inline function toArray<T> ():Array<T> {
		
		#if cpp
		return cast this.data;
		#else
		var value = new Array ();
		for (i in 0...this.data.length) {
			value.push (this.data[i]);
		}
		return value;
		#end
		
	}
	
	
	@:noCompletion @:dox(hide) @:from public static inline function fromHaxeVector<T> (value:haxe.ds.Vector<T>):Vector<T> {
		
		var vectorData = new VectorData<T> ();
		vectorData.length = value.length;
		vectorData.fixed = true;
		#if cpp
		vectorData.data = new Array ();
		untyped (vectorData.data).__SetSize (value.length);
		for (i in 0...value.length) {
			vectorData.data[i] = value[i];
		}
		#else
		vectorData.data = value;
		#end
		return cast vectorData;
		
	}
	
	
	@:noCompletion @:dox(hide) @:to public inline function toHaxeVector<T> ():haxe.ds.Vector<T> {
		
		#if cpp
		return haxe.ds.Vector.fromArrayCopy (this.data);
		#else
		return this.data;
		#end
		
	}
	
	
	@:noCompletion @:dox(hide) @:from public static inline function fromVectorData<T> (value:VectorData<T>):Vector<T> {
		
		return cast value;
		
	}
	
	
	@:noCompletion @:dox(hide) @:to public inline function toVectorData<T> ():VectorData<T> {
		
		return cast this;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private inline function get_length ():Int {
		
		return this.length;
		
	}
	
	
	@:noCompletion private inline function set_length (value:Int):Int {
		
		if (!fixed) {
			
			if (value > this.length) {
				
				#if cpp
				untyped (this.data).__SetSizeExact (value);
				#else
				var data = new haxe.ds.Vector<T> (value);
				haxe.ds.Vector.blit (this.data, 0, data, 0, Std.int (Math.min (this.data.length, value)));
				this.data = data;
				#end
				
			}
			
			this.length = value;
			
		}
		
		return value;
		
	}
	
	
	@:noCompletion private inline function get_fixed ():Bool {
		
		return this.fixed;
		
	}
	
	
	@:noCompletion private inline function set_fixed (value:Bool):Bool {
		
		return this.fixed = value;
		
	}
	
	
}


@:dox(hide) class VectorData<T> {
	
	
	#if cpp
	public var data:Array<T>;
	#else
	public var data:haxe.ds.Vector<T>;
	#end
	public var fixed:Bool;
	public var length:Int;
	
	
	public function new () {
		
		length = 0;
		
	}
	
	
}


@:dox(hide) class VectorDataIterator<T> {
	
	
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
		
		return vectorData.data[index++];
		
	}
	
	
}


#else


#if (haxe_ver > 3.101)
using cpp.NativeArray;
#end


@:arrayAccess abstract Vector<T>(Array<T>) from Array<T> to Array<T> {
	
	
	public var length (get, set):Int;
	public var fixed (get, set):Bool;
	
	
	public inline function new (?length:Int, ?fixed:Bool):Void {
		
		this = new Array<T> ();
		untyped this.__SetSizeExact (length);
		
	}
	
	
	public inline function concat (?a:Array<T>):Vector<T> {
		
		return this.concat (a);
		
	}
	
	
	public inline function copy ():Vector<T> {
		
		return this.copy ();
		
	}
	
	
	public inline function iterator<T> ():Iterator<T> {
		
		return this.iterator ();
		
	}
	
	
	public inline function join (sep:String):String {
		
		return this.join (sep);
		
	}
	
	
	public inline function pop ():Null<T> {
		
		return this.pop ();
		
	}
	
	
	public inline function push (x:T):Int {
		
		return this.push (x);
		
	}
	
	
	public inline function reverse ():Void {
		
		this.reverse ();
		
	}
	
	
	public inline function shift ():Null<T> {
		
		return this.shift ();
		
	}
	
	
	public inline function unshift (x:T):Void {
		
		this.unshift (x);
		
	}
	
	
	public inline function slice (?pos:Int, ?end:Int):Vector<T> {
		
		return this.slice (pos, end);
		
	}
	
	
	public inline function sort (f:T -> T -> Int):Void {
		
		this.sort (f);
		
	}
	
	
	public inline function splice (pos:Int, len:Int):Vector<T> {
		
		return this.splice (pos, len);
		
	}
	
	
	public inline function toString ():String {
		
		return this.toString ();
		
	}
	
	
	public inline function indexOf (x:T, ?from:Int = 0):Int {
		
		return this.indexOf (x, from);
		
	}
	
	
	public inline function lastIndexOf (x:T, ?from:Int):Int {
		
		return this.lastIndexOf (x, from);
		
	}
	
	
	@:noCompletion @:dox(hide) @:arrayAccess public inline function get (index:Int):Null<T> {
		
		//#if (haxe_ver > 3.100)
		//return this.unsafeGet (index);
		//#else
		return this[index];
		//#end
		
	}
	
	
	@:noCompletion @:dox(hide) @:arrayAccess public inline function set (index:Int, value:T):T {
		
		//#if (haxe_ver > 3.100)
		//return this.unsafeSet (index, value);
		//#else
		return this[index] = value;
		//#end
		
	}
	
	
	public inline static function ofArray<T> (a:Array<Dynamic>):Vector<T> {
		
		return new Vector<T> ().concat (cast a);
		
	}
	
	
	public inline static function convert<T,U> (v:Array<T>):Vector<U> {
		
		return cast v;
		
	}
	
	
	@:noCompletion @:dox(hide) @:from public static inline function fromHaxeVector<T> (value:haxe.ds.Vector<T>):Vector<T> {
		
		return cast value;
		
	}
	
	
	@:noCompletion @:dox(hide) @:to public inline function toHaxeVector<T> ():haxe.ds.Vector<T> {
		
		return cast this;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private inline function get_length ():Int {
		
		return this.length;
		
	}
	
	
	@:noCompletion private inline function set_length (value:Int):Int {
		
		untyped (this).__SetSizeExact (value);
		return value;
		
	}
	
	
	@:noCompletion private inline function get_fixed ():Bool {
		
		return false;
		
	}
	
	
	@:noCompletion private inline function set_fixed (value:Bool):Bool {
		
		return value;
		
	}
	
	
}


typedef VectorData<T> = Array<T>;
typedef VectorDataIterator<T> = Iterator<T>;


#end
#else


abstract Vector<T>(VectorData<T>) {
	
	
	public var length (get, set):Int;
	public var fixed (get, set):Bool;
	
	
	public inline function new (length:Int = 0, fixed:Bool = false):Void {
		
		this = new VectorData<T> (length, fixed);
		
		
	}
	
	
	public inline function concat (?a:VectorData<T>):Vector<T> {
		
		return this.concat (a);
		
	}
	
	
	public inline function copy ():Vector<T> {
		
		var vec = new VectorData<T> (this.length, this.fixed);
		
		for (i in 0...this.length) {
			
			vec[i] = this[i];
			
		}
		
		return vec;
		
	}
	
	
	public inline function iterator<T> ():Iterator<T> {
		
		return new VectorDataIterator<T> (this);
		
	}
	
	
	public inline function join (sep:String):String {
		
		return this.join (sep);
		
	}
	
	
	public inline function pop ():Null<T> {
		
		return this.pop ();
		
	}
	
	
	public inline function push (x:T):Int {
		
		return this.push (x);
		
	}
	
	
	public inline function reverse ():Void {
		
		this.reverse ();
		
	}
	
	
	public inline function shift ():Null<T> {
		
		return this.shift ();
		
	}
	
	
	public inline function unshift (x:T):Void {
		
		this.unshift (x);
		
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
		
		return this.toString ();
		
	}
	
	
	public inline function indexOf (x:T, from:Int = 0):Int {
		
		return this.indexOf (x, from);
		
	}
	
	
	public inline function lastIndexOf (x:T, from:Int = 0x7fffffff):Int {
		
		return this.lastIndexOf (x, from);
		
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
	
	
	@:noCompletion @:dox(hide) @:from public static inline function fromArray<T> (value:Array<T>):Vector<T> {
		
		return VectorData.ofArray (value);
		
	}
	
	
	@:noCompletion @:dox(hide) @:to public inline function toArray<T> ():Array<T> {
		
		var array = new Array<T> ();
		
		for (value in this) {
			
			array.push (value);
			
		}
		
		return array;
		
	}
	
	
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
	
	
	
	
	@:noCompletion private inline function get_length ():Int {
		
		return this.length;
		
	}
	
	
	@:noCompletion private inline function set_length (value:Int):Int {
		
		return this.length = value;
		
	}
	
	
	@:noCompletion private inline function get_fixed ():Bool {
		
		return this.fixed;
		
	}
	
	
	@:noCompletion private inline function set_fixed (value:Bool):Bool {
		
		return this.fixed = value;
		
	}
	
	
}


private class VectorDataIterator<T> {
	
	
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