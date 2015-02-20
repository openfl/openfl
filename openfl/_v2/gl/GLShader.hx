package openfl._v2.gl; #if lime_legacy


class GLShader extends GLObject {
	
	
	public function new (version:Int, id:Dynamic) {
		
		super (version, id);
		
	}
	
	
	override private function getType ():String {
		
		return "Shader";
		
	}
	
	
	public override function isValid ():Bool {
		
		return id != 0 && id != null && version == GL.version;
		
	}
	
	
}


#end