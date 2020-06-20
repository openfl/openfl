package openfl.utils;

#if !lime
@SuppressWarnings("checkstyle:FieldDocComment")
class Future<T>
{
	public var error(default, null):Dynamic;
	public var isComplete(default, null):Bool;
	public var isError(default, null):Bool;
	public var value(default, null):T;

	private function new() {}

	public function onComplete(listener:T->Void):Future<T>
	{
		return this;
	}

	public function onError(listener:Dynamic->Void):Future<T>
	{
		return this;
	}

	public function onProgress(listener:Int->Int->Void):Future<T>
	{
		return this;
	}

	public function ready(waitTime:Int = -1):Future<T>
	{
		return this;
	}

	public function result(waitTime:Int = -1):Null<T>
	{
		return value;
	}

	public function then<U>(next:T->Future<U>):Future<U>
	{
		return new Future<U>();
	}

	public static function withError(error:Dynamic):Future<Dynamic>
	{
		var result = new Future<Dynamic>();
		result.error = error;
		result.isError = true;
		return result;
	}

	public static function withValue<T>(value:T):Future<T>
	{
		var result = new Future<T>();
		result.value = value;
		result.isComplete = true;
		return result;
	}
}
#else
typedef Future<T> = lime.app.Future<T>;
#end
