package openfl._legacy.gl; #if openfl_legacy


class GLFramebuffer extends GLObject {
	
	
	public function new (version:Int, id:Dynamic) {
		
		super (version, id);
		
	}
	
	
	override function getType ():String {
		
		return "Framebuffer";
		
	}
	
	
}


#end