package openfl._internal;


class HardwareRenderer {
	
	
	public static var current:HardwareRenderer;
	public static var textureContextVersion = 0;
	
	
	public function new () {
		
		
		
	}
	
	
	public function onContextLost ():Void {
		
		
		
	}
	
	
	public static function resetHardwareContext ():Void {
		
		textureContextVersion++;
		
		if (current != null) {
			
			current.onContextLost ();
			
		}
		
	}
	
	
}