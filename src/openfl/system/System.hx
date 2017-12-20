package openfl.system;


import lime.system.Clipboard;
import lime.system.System in LimeSystem;

#if neko
import neko.vm.Gc;
#elseif cpp
import cpp.vm.Gc;
#end


@:final class System {
	
	
	public static var totalMemory (get, never):Int;
	public static var useCodePage:Bool = false;
	public static var vmVersion (get, never):String;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (System, {
			"totalMemory": { get: function () { return System.get_totalMemory (); } },
			"vmVersion": { get: function () { return System.get_vmVersion (); } },
		});
		
	}
	#end
	
	
	public static function exit (code:Int):Void {
		
		LimeSystem.exit (code);
		
	}
	
	
	public static function gc ():Void {
		
		#if (cpp || neko)
		return Gc.run (true);
		#end
		
	}
	
	
	public static function pause ():Void {
		
		openfl._internal.Lib.notImplemented ();
		
	}
	
	
	public static function resume ():Void {
		
		openfl._internal.Lib.notImplemented ();
		
	}
	
	
	public static function setClipboard (string:String):Void {
		
		Clipboard.text = string;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private static function get_totalMemory ():Int {
		
		#if neko
		return Gc.stats ().heap;
		#elseif cpp
		return untyped __global__.__hxcpp_gc_used_bytes ();
		#elseif (js && html5)
		return untyped __js__ ("(window.performance && window.performance.memory) ? window.performance.memory.usedJSHeapSize : 0");
		#else
		return 0;
		#end
		
	}
	
	
	private static function get_vmVersion ():String {
		
		return "1.0.0";
		
	}
	
	
}