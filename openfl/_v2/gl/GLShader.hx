package openfl._v2.gl;


class GLShader extends GLObject {
	
	
	public function new (version:Int, id:Dynamic) {
		
		super (version, id);
		
	}
	
	
	override private function getType ():String {
		
		return "Shader";
		
	}
	
	
}