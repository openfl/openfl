package openfl.system; #if (!display && !flash)


class SecurityDomain {
	
	
	public static var currentDomain (default, null) = new SecurityDomain ();
	
	
	private function new () {
		
		
		
	}
	
	
}


#else


#if flash
@:native("flash.system.SecurityDomain")
#end


extern class SecurityDomain {
	
	
	public static var currentDomain (default, null):SecurityDomain;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public var domainID (default, null):String;
	#end
	
	
	private function new () {
		
		
		
	}
	
	
}


#end