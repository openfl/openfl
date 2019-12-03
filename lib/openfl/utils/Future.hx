package openfl.utils;

extern class Future<T>
{
	public var error(default, null):Dynamic;
	public var isComplete(default, null):Bool;
	public var isError(default, null):Bool;
	public var value(default, null):T;
	public function onComplete(listener:(value:T) -> Void):Future<T>;
	public function onError(listener:(error:Dynamic) -> Void):Future<T>;
	public function onProgress(listener:(loaded:Int, total:Int) -> Void):Future<T>;
	public function ready(waitTime:Int = -1):Future<T>;
	public function result(waitTime:Int = -1):Null<T>;
	public function then<U>(next:(value:T) -> Future<U>):Future<U>;
	public static function withError(error:Dynamic):Future<Dynamic>;
	public static function withValue<T>(value:T):Future<T>;
}
