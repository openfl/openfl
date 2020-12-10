package flash;

@:require(flash10) extern class Vector<T> implements ArrayAccess<T>
{
	public var length:Int;
	public var fixed:Bool;
	public function new(?length:UInt, ?fixed:Bool):Void;
	public function concat(?a:Vector<T>):Vector<T>;
	public function indexOf(x:T, ?from:Int):Int;
	@:require(flash19) public function insertAt(index:Int, element:T):Int;
	public function join(sep:String = ","):String;
	public function lastIndexOf(x:T, ?from:Int):Int;
	public function pop():Null<T>;
	public function push(x:T):Int;
	@:require(flash19) public function removeAt(index:Int):T;
	public function reverse():Vector<T>;
	public function shift():Null<T>;
	public function unshift(x:T):Void;
	public function slice(?pos:Int, ?end:Int):Vector<T>;
	public function sort(f:T->T->Int):Void;
	public function splice(pos:Int, len:Int):Vector<T>;
	public function toString():String;
	public inline static function ofArray<T>(v:Array<T>):Vector<T>
	{
		return untyped __vector__(v);
	}
	public inline static function convert<T, U>(v:Vector<T>):Vector<U>
	{
		return untyped __vector__(v);
	}
}
