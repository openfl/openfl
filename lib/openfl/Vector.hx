package openfl;


@:jsRequire("openfl/Vector", "default")

extern class Vector<T> implements ArrayAccess<T> {
	
	
	public var fixed:Bool;
	public var length:Int;
	
	public function new (?length:Int, ?fixed:Bool, ?array:Array<T>):Void;
	
	public function concat (?a:Vector<T>):Vector<T>;
	public function copy ():Vector<T>;
	public function get (index:Int):T;
	public function indexOf (x:T, ?from:Int = 0):Int;
	public function insertAt (index:Int, element:T):Void;
	public function join (sep:String = ","):String;
	public function lastIndexOf (x:T, ?from:Int = 0):Int;
	public function pop ():Null<T>;
	public function push (x:T):Int;
	public function removeAt (index:Int):T;
	public function reverse ():Vector<T>;
	public function set (index:Int, value:T):T;
	public function shift ():Null<T>;
	public function slice (?pos:Int, ?end:Int):Vector<T>;
	public function sort (f:T->T->Int):Void;
	public function splice (pos:Int, len:Int):Vector<T>;
	public function unshift (x:T):Void;
	public static function ofArray<T> (a:Array<T>):Vector<T>;
	
	@:noCompletion public function iterator ():Iterator<T>;
	
	
}