package openfl;


abstract Vector<T>(VectorData<T>) {
	
	
	public var length (get, set):Int;
	public var fixed (get, set):Bool;
	
	
	public inline function new (?length:Int, ?fixed:Bool):Void {
		
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
	
	
	public inline function indexOf (x:T, ?from:Int):Int {
		
		return this.indexOf (x, from);
		
	}
	
	
	public inline function lastIndexOf (x:T, ?from:Int):Int {
		
		return this.lastIndexOf (x, from);
		
	}
	
	
	public inline static function ofArray<T> (a:Array<Dynamic>):Vector<T> {
		
		return VectorData.ofArray (a);
		
	}
	
	
	public inline static function convert<T,U> (v:Vector<T>):Vector<U> {
		
		return cast VectorData.convert (v);
		
	}
	
	
	@:arrayAccess public inline function get (index:Int):Null<T> {
		
		return this[index];
		
	}
	
	
	@:arrayAccess public inline function set (index:Int, value:T):T {
		
		return this[index] = value;
		
	}
	
	
	@:from static public inline function fromArray<T> (value:Array<T>):Vector<T> {
		
		return VectorData.ofArray (value);
		
	}
	
	
	@:to public inline function toArray<T> ():Array<T> {
		
		var array = new Array<T> ();
		
		for (value in this) {
			
			array.push (value);
			
		}
		
		return array;
		
	}
	
	
	@:from static public inline function fromHaxeVector<T> (value:haxe.ds.Vector<T>):Vector<T> {
		
		return cast value;
		
	}
	
	
	@:to public inline function toHaxeVector<T> ():haxe.ds.Vector<T> {
		
		return cast this;
		
	}
	
	
	@:from static public inline function fromVectorData<T> (value:VectorData<T>):Vector<T> {
		
		return cast value;
		
	}
	
	
	@:to public inline function toVectorData<T> ():VectorData<T> {
		
		return cast this;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private inline function get_length ():Int {
		
		return this.length;
		
	}
	
	
	private inline function set_length (value:Int):Int {
		
		return this.length = value;
		
	}
	
	
	private inline function get_fixed ():Bool {
		
		return this.fixed;
		
	}
	
	
	private inline function set_fixed (value:Bool):Bool {
		
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