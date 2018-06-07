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
			
			if (Context.defined ("js") && !Context.defined ("nodejs") && !Context.defined ("lime")) {
				
				var childPath = Context.resolvePath ("openfl/external");
				
				var parts = StringTools.replace (childPath, "\\", "/").split ("/");
				
				if (parts.length > 3) {
					
					parts.pop ();
					parts.pop ();
					parts.pop ();
					
					var openflPath = parts.join ("/");
					
					trace (openflPath);
					
					Compiler.addClassPath (openflPath + "/lib");
					
				}
				
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