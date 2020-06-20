package openfl.external;

#if !flash
import openfl._internal.Lib;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Stage)
@:access(lime.ui.Window)
@:final class ExternalInterface
{
	public static var available(default, null) = #if (js && html5) true #else false #end;
	public static var marshallExceptions:Bool = false;
	public static var objectID(get, null):String;

	public static function addCallback(functionName:String, closure:Dynamic):Void
	{
		#if (js && html5)
		if (Lib.application.window.element != null)
		{
			untyped Lib.application.window.element[functionName] = closure;
		}
		#end
	}

	public static function call(functionName:String, p1:Dynamic = null, p2:Dynamic = null, p3:Dynamic = null, p4:Dynamic = null, p5:Dynamic = null):Dynamic
	{
		#if (js && html5)
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
		#else
		return null;
		#end
	}

	private static function get_objectID():String
	{
		#if (js && html5)
		if (Lib.application != null && Lib.application.window != null && Lib.application.window.element != null)
		{
			return Lib.application.window.element.id;
		}
		#end

		return null;
	}
}
#else
typedef ExternalInterface = flash.external.ExternalInterface;
#end
