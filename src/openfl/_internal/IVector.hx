package openfl._internal;

interface IVector<T>
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
}
