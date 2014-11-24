package openfl._v2.gl; #if (!flash && !html5 && !openfl_next)


class GLFramebuffer extends GLObject {
	
	
	public function new (version:Int, id:Dynamic) {
		
		super (version, id);
		
	}
	
	
	override function getType ():String {
		
		return "Framebuffer";
		
	}
	
	
}


#end