package openfl._internal.backend.lime_standalone;

#if openfl_html5
#if !macro
@:genericBuild(openfl._internal.backend.lime_standalone.LimeEventMacro.build())
#end
class LimeEvent<T>
{
	public var canceled(default, null):Bool;

	@:noCompletion @:dox(hide) public var __listeners:Array<T>;
	@:noCompletion @:dox(hide) public var __repeat:Array<Bool>;

	@:noCompletion private var __priorities:Array<Int>;

	public function new()
	{
		#if !macro
		canceled = false;
		__listeners = new Array();
		__priorities = new Array<Int>();
		__repeat = new Array<Bool>();
		#end
	}

	public function add(listener:T, once:Bool = false, priority:Int = 0):Void
	{
		#if !macro
		for (i in 0...__priorities.length)
		{
			if (priority > __priorities[i])
			{
				__listeners.insert(i, cast listener);
				__priorities.insert(i, priority);
				__repeat.insert(i, !once);
				return;
			}
		}

		__listeners.push(cast listener);
		__priorities.push(priority);
		__repeat.push(!once);
		#end
	}

	public function cancel():Void
	{
		canceled = true;
	}

	public var dispatch:Dynamic;

	// macro public function dispatch (ethis:Expr, args:Array<Expr>):Void {
	//
	// return macro {
	//
	// var listeners = $ethis.listeners;
	// var repeat = $ethis.repeat;
	// var i = 0;
	//
	// while (i < listeners.length) {
	//
	// listeners[i] ($a{args});
	//
	// if (!repeat[i]) {
	//
	// $ethis.remove (listeners[i]);
	//
	// } else {
	//
	// i++;
	//
	// }
	//
	// }
	//
	// }
	//
	// }

	public function has(listener:T):Bool
	{
		#if !macro
		for (l in __listeners)
		{
			if (Reflect.compareMethods(l, listener)) return true;
		}
		#end

		return false;
	}

	public function remove(listener:T):Void
	{
		#if !macro
		var i = __listeners.length;

		while (--i >= 0)
		{
			if (Reflect.compareMethods(__listeners[i], listener))
			{
				__listeners.splice(i, 1);
				__priorities.splice(i, 1);
				__repeat.splice(i, 1);
			}
		}
		#end
	}
}
#end
