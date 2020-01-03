package openfl._internal.backend.html5;

#if openfl_html5
import openfl._internal.Lib;

@:access(openfl.display.Stage)
class HTML5ExternalInterfaceBackend
{
	public static function addCallback(functionName:String, closure:Dynamic):Void
	{
		// TODO without Lime
		// if (Lib.limeApplication.window.element != null)
		// {
		// 	untyped Lib.limeApplication.window.element[functionName] = closure;
		// }
	}

	public static function call(functionName:String, p1:Dynamic = null, p2:Dynamic = null, p3:Dynamic = null, p4:Dynamic = null, p5:Dynamic = null):Dynamic
	{
		var callResponse:Dynamic = null;

		if (!~/^\(.+\)$/.match(functionName))
		{
			var thisArg = functionName.split(".").slice(0, -1).join(".");
			if (thisArg.length > 0)
			{
				functionName += '.bind(${thisArg})';
			}
		}

		// Flash does not throw an error or attempt to execute
		// if the function does not exist.
		var fn:Dynamic;
		try
		{
			fn = js.Lib.eval(functionName);
		}
		catch (e:Dynamic)
		{
			return null;
		}

		if (Type.typeof(fn) != Type.ValueType.TFunction)
		{
			return null;
		}

		if (p1 == null)
		{
			callResponse = fn();
		}
		else if (p2 == null)
		{
			callResponse = fn(p1);
		}
		else if (p3 == null)
		{
			callResponse = fn(p1, p2);
		}
		else if (p4 == null)
		{
			callResponse = fn(p1, p2, p3);
		}
		else if (p5 == null)
		{
			callResponse = fn(p1, p2, p3, p4);
		}
		else
		{
			callResponse = fn(p1, p2, p3, p4, p5);
		}

		return callResponse;
	}

	public static function getObjectID():String
	{
		// if (Lib.limeApplication.window.element != null)
		// {
		// 	return Lib.limeApplication.window.element.id;
		// }

		return null;
	}
}
#end