package openfl.system; #if !flash


class SecurityDomain {
	
	
	public static var currentDomain (default, null) = new SecurityDomain ();
	
	
	private function new () {
		
		
		
	}
	
	
}


#else
typedef SecurityDomain = flash.system.SecurityDomain;
#end