/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl;
#if display


class Lib {

	public static var current : openfl.display.MovieClip;

	public inline static function getTimer() : Int {
		return 0;
	}

	public static function eval( path : String ) : Dynamic {
		return null;
	}

	public static function getURL( url : openfl.net.URLRequest, ?target : String ) {
		
	}

	public static function fscommand( cmd : String, ?param : String ) {
		
	}

	public static function trace( arg : Dynamic ) {
		haxe.Log.trace (arg);
	}

	public static function attach( name : String ) : openfl.display.MovieClip {
		return null;
	}

	public inline static function as<T>( v : Dynamic, c : Class<T> ) : Null<T> {
		return cast v;
	}
	
	public static function redirectTraces() {
		
	}

	static function traceToConsole(v : Dynamic, ?inf : haxe.PosInfos ) {
		
	}
}


#elseif macro


import haxe.macro.Compiler;
import haxe.macro.Context;
import sys.FileSystem;


class Lib {
	
	
	public static function includeBackend (type:String) {
		
		Compiler.define ("openfl");
		Compiler.define ("openfl_" + type);
		
		var paths = Context.getClassPath();
		
		for (path in paths) {
			
			if (FileSystem.exists (path + "/backends/" + type)) {
				
				Compiler.addClassPath (path + "/backends/" + type);
				
			}
			
		}
		
	}
	
	
}


#end