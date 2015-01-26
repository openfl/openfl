package openfl._v2.gl; #if lime_legacy


class GLFramebuffer extends GLObject {
	
	
	public function new (version:Int, id:Dynamic) {
		
		super (version, id);
		
	}
	
	
	override function getType ():String {
		
		return "Framebuffer";
		
	}
	
	
}


#end