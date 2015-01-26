package openfl._v2.gl; #if lime_legacy


class GLRenderbuffer extends GLObject {
	
	
	public function new (version:Int, id:Dynamic) {
		
		super (version, id);
		
	}
	
	
	override private function getType ():String {
		
		return "Renderbuffer";
		
	}
	
	
}


#end