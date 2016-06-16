package openfl.external;


import openfl.Lib;

@:access(openfl.display.Stage)
@:access(lime.ui.Window)


@:final class ExternalInterface {
	
	
	public static var available (default, null) = true;
	public static var marshallExceptions = false;
	public static var objectID (default, null):String;
	
	
	public static function addCallback (functionName:String, closure:Dynamic):Void {
		
		#if (js && html5)
		if (Lib.application.window.backend.element != null) {
			
			untyped Lib.application.window.backend.element[functionName] = closure;
			
		}
		#end
		
	}
	
	
	public static function call (functionName:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Dynamic {
		
		#if (js && html5)
		var callResponse:Dynamic = null;
		
		var thisArg = functionName.split('.').slice(0, -1).join('.');
		if (thisArg.length > 0) {
			functionName += '.bind(${thisArg})';
		}
		
		if (p1 == null) {
			
			callResponse = js.Lib.eval (functionName) ();
			
		} else if (p2 == null) {
			
			callResponse = js.Lib.eval (functionName) (p1);
			
		} else if (p3 == null) {
			
			callResponse = js.Lib.eval (functionName) (p1, p2);
			
		} else if (p4 == null) {
			
			callResponse = js.Lib.eval (functionName) (p1, p2, p3);
			
		} else if (p5 == null) {
			
			callResponse = js.Lib.eval (functionName) (p1, p2, p3, p4);
			
		} else {
			
			callResponse = js.Lib.eval (functionName) (p1, p2, p3, p4, p5);
			
		}
		
		return callResponse;
		#else
		return null;
		#end
		
	}
	
	
}