package openfl.system; #if !flash


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class SecurityDomain {
	
	
	public static var currentDomain (default, null) = new SecurityDomain ();
	
	// @:noCompletion @:dox(hide) @:require(flash11_3) public var domainID (default, null):String;
	
	
	@:noCompletion private function new () {
		
		
		
	}
	
	
}


#else
typedef SecurityDomain = flash.system.SecurityDomain;
#end