package openfl._v2.gl; #if (!flash && !html5 && !openfl_next)


class GLTexture extends GLObject {
	
	
	public function new (version:Int, id:Dynamic) {
		
		super (version, id);
		
	}
	
	
	override private function getType ():String {
		
		return "Texture";
		
	}
	
	
}


#end