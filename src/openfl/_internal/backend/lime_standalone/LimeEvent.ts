namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
#if!macro
@: genericBuild(openfl._internal.backend.lime_standalone.LimeEventMacro.build())
#end
class LimeEvent<T>
{
	public canceled(default , null): boolean;

	/** @hidden */ public __listeners: Array<T>;
	/** @hidden */ public __repeat: Array<Bool>;

	protected __priorities: Array<Int>;

	public constructor()
	{
		#if!macro
		canceled = false;
		__listeners = new Array();
		__priorities = new Array<Int>();
		__repeat = new Array<Bool>();
		#end
	}

	public add(listener: T, once: boolean = false, priority: number = 0): void
	{
		#if!macro
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

	public cancel(): void
	{
		canceled = true;
	}

	public dispatch: Dynamic;

	// macro public dispatch (ethis:Expr, args:Array<Expr>):Void {
	//
	// return macro {
	//
	// listeners = $ethis.listeners;
	// repeat = $ethis.repeat;
	// i = 0;
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

	public has(listener: T): boolean
	{
		#if!macro
		for (l in __listeners)
		{
			if (Reflect.compareMethods(l, listener)) return true;
		}
		#end

		return false;
	}

	public remove(listener: T): void
	{
		#if!macro
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
