package openfl._internal.utils; #if macro


import haxe.macro.Compiler;
import haxe.macro.Context;


class ExtraParams {
	
	
	public static function include ():Void {
		
		if (!Context.defined ("tools")) {
			
			if (Context.defined ("display")) {
				
				includeExterns ();
				
			}
			
			if (!Context.defined ("flash")) {
				
				Compiler.allowPackage ("flash");
				Compiler.define ("swf-version", "22.0");
				
			}
			
		}
		
	}
	
	
	public static function includeExterns ():Void {
		
		var childPath = Context.resolvePath ("externs/core");
		
		var parts = StringTools.replace (childPath, "\\", "/").split ("/");
		parts.pop ();
		
		var externsPath = parts.join ("/");
		
		Compiler.addClassPath (externsPath + "/core/openfl");
		Compiler.addClassPath (externsPath + "/core/flash");
		Compiler.addClassPath (externsPath + "/extras");
		
	}
	
	
}


#end